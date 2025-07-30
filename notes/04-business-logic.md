# Section 2: Building Real Functionality - Todo Management

## Slide 3: Adding Real Business Logic

**Create file:** `src/db.py`

```bash
# Install Pydantic for data validation
uv add pydantic
```

```python
import sqlite3
import os
from typing import List, Dict, Any, Optional
from pydantic import BaseModel, Field, field_validator
import logging

# Setup logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger("db")

class TodoSchema(BaseModel):
    title: str = Field(..., min_length=1, max_length=255)
    id: Optional[int] = Field(None, gt=0)
    
    @field_validator('title')
    @classmethod
    def validate_title(cls, v: str) -> str:
        if not v or v.strip() == '':
            raise ValueError('Title cannot be empty or contain only whitespace')
        return v.strip()

DB_NAME = "todos.db"

def init_db():
    """Initialize the SQLite database"""
    try:
        conn = sqlite3.connect(DB_NAME)
        cursor = conn.cursor()
        cursor.execute("""
            CREATE TABLE IF NOT EXISTS todos (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                text TEXT NOT NULL,
                completed INTEGER NOT NULL DEFAULT 0
            )
        """)
        conn.commit()
        conn.close()
        logger.info(f'Database "{DB_NAME}" initialized.')
    except Exception as error:
        logger.error(f'Error initializing database "{DB_NAME}": {error}')

# Initialize database on import
init_db()

def add_todo(text: str) -> Dict[str, Any]:
    """Add a new todo to the database"""
    logger.info(f"Adding TODO: {text}")
    
    # Validate input
    validated_input = TodoSchema(title=text)
    
    conn = sqlite3.connect(DB_NAME)
    cursor = conn.cursor()
    cursor.execute("INSERT INTO todos (text) VALUES (?)", (validated_input.title,))
    lastInsertRowid = cursor.lastrowid
    conn.commit()
    conn.close()
    return {"lastInsertRowid": lastInsertRowid}

def list_todos() -> List[Dict[str, Any]]:
    """Get all todos from the database"""
    logger.info("Listing all TODOs")
    
    conn = sqlite3.connect(DB_NAME)
    conn.row_factory = sqlite3.Row
    cursor = conn.cursor()
    cursor.execute("SELECT * FROM todos ORDER BY id")
    rows = cursor.fetchall()
    conn.close()
    return [dict(row) for row in rows]

def complete_todo(todo_id: int) -> Dict[str, Any]:
    """Mark a todo as completed"""
    logger.info(f"Completing TODO: {todo_id}")
    
    conn = sqlite3.connect(DB_NAME)
    cursor = conn.cursor()
    cursor.execute("UPDATE todos SET completed = 1 WHERE id = ?", (todo_id,))
    changes = cursor.rowcount
    conn.commit()
    conn.close()
    return {"changes": changes}

def delete_todo(todo_id: int) -> Optional[Dict[str, Any]]:
    """Delete a todo from the database"""
    logger.info(f"Deleting TODO: {todo_id}")
    
    conn = sqlite3.connect(DB_NAME)
    conn.row_factory = sqlite3.Row
    cursor = conn.cursor()
    
    # Get the todo before deleting
    cursor.execute("SELECT * FROM todos WHERE id = ?", (todo_id,))
    row = cursor.fetchone()
    
    if row:
        cursor.execute("DELETE FROM todos WHERE id = ?", (todo_id,))
        conn.commit()
        conn.close()
        return dict(row)
    
    conn.close()
    return None

def update_todo_text(todo_id: int, text: str) -> Optional[Dict[str, Any]]:
    """Update the text of a todo"""
    logger.info(f"Updating TODO {todo_id}: {text}")
    
    # Validate input
    validated_input = TodoSchema(title=text, id=todo_id)
    
    conn = sqlite3.connect(DB_NAME)
    conn.row_factory = sqlite3.Row
    cursor = conn.cursor()
    
    cursor.execute("UPDATE todos SET text = ? WHERE id = ?", (validated_input.title, todo_id))
    
    if cursor.rowcount > 0:
        cursor.execute("SELECT * FROM todos WHERE id = ?", (todo_id,))
        row = cursor.fetchone()
        conn.commit()
        conn.close()
        return dict(row) if row else None
    
    conn.close()
    return None
```
