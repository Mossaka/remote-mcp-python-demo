# Slide 4: Creating Multiple MCP Tools

**Create file:** `src/tools.py`

```python
from mcp.server.fastmcp import FastMCP
from typing import List
from db import (
    add_todo,
    list_todos,
    complete_todo,
    delete_todo,
    update_todo_text,
)

# Create an MCP server using FastMCP
mcp = FastMCP("todo-mcp-server")

@mcp.tool()
def add_todo_tool(title: str) -> List[str]:
    """Add a new TODO item to the list. Provide a title for the task you want to add. Returns a confirmation message with the new TODO id."""
    info = add_todo(title)
    return [f"Added TODO: {title} (id: {info['lastInsertRowid']})"]

@mcp.tool()
def list_todos_tool() -> List[str]:
    """List all TODO items. Returns a formatted list of all tasks with their ids, titles, and completion status."""
    todos = list_todos()
    if not todos or len(todos) == 0:
        return ["No TODOs found."]
    
    return [
        f"TODO: {todo['text']} (id: {todo['id']}){' [completed]' if todo['completed'] else ''}"
        for todo in todos
    ]

@mcp.tool()
def complete_todo_tool(id: int) -> List[str]:
    """Mark a TODO item as completed. Provide the id of the task to mark as done. Returns a confirmation message or an error if the id does not exist."""
    info = complete_todo(id)
    if info["changes"] == 0:
        return [f"TODO with id {id} not found."]
    return [f"TODO with id {id} marked as completed."]

@mcp.tool()
def delete_todo_tool(id: int) -> List[str]:
    """Delete a TODO item from the list. Provide the id of the task to delete. Returns a confirmation message or an error if the id does not exist."""
    row = delete_todo(id)
    if not row:
        return [f"TODO with id {id} not found."]
    return [f"Deleted TODO: {row['text']} (id: {id})"]

@mcp.tool()
def update_todo_text_tool(id: int, text: str) -> List[str]:
    """Update the text of a todo. Provide the id of the todo and the new text."""
    row = update_todo_text(id, text)
    if not row:
        return [f"TODO with id {id} not found."]
    return [f"Updated text for todo with id {id} to \"{text}\""]
```

```bash
# Test the new server with multiple tools
uv run mcp dev src/tools.py
```
