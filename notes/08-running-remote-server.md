# Slide 6: Running Your Remote Server

```bash
# Start the HTTP server (FastMCP uses port 3000 by default)
uv run python src/streamable_http_server.py
```

```bash
# Test the HTTP server (in a new terminal)
npx @modelcontextprotocol/inspector http://127.0.0.1:3000/mcp
```
