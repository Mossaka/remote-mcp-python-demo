# Slide 4.1: Testing with VS Code Copilot

**Add to your VS Code settings:**

```json
"my-todo-mcp-server": {
    "type": "stdio",
    "command": "uv",
    "args": [
        "run",
        "mcp",
        "run",
        "/path/to/your/project/src/tools.py"
    ]
}
```
