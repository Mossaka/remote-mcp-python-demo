from mcp.server.fastmcp import FastMCP

# Create an MCP server using FastMCP
mcp = FastMCP("dummy-mcp-server")

@mcp.tool()
def hello_world(name: str) -> str:
    """Simple hello world tool"""
    return f"Hello, {name}!"