# Slide 2: Your First MCP Server

```bash
# 4. Create the src directory and our first server
mkdir src
```

```python
from mcp.server.fastmcp import FastMCP

# Create an MCP server using FastMCP
mcp = FastMCP("dummy-mcp-server")

@mcp.tool()
def hello_world(name: str) -> str:
    """Simple hello world tool"""
    return f"Hello, {name}!"
```

```bash
# 5. Test the MCP server using the built-in dev tool
uv run mcp dev src/dummy_server.py
```
