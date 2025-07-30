# Slide 5: Converting to HTTP with FastMCP

```bash
# Copy our existing tools.py to create the HTTP version
cp src/tools.py src/streamable_http_server.py
```

```python
if __name__ == "__main__":
    mcp.run(transport="streamable-http")
```
