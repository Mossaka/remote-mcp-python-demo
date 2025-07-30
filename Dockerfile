# Use Python 3.12+ slim image as base
FROM python:3.12-slim

# Set working directory
WORKDIR /app

# Install uv for faster dependency management
RUN pip install uv

# Copy dependency files
COPY pyproject.toml uv.lock ./

# Install dependencies using uv
RUN uv sync --frozen

# Copy source code
COPY src/ ./src/
COPY todos.db ./

# Create a non-root user for security
RUN addgroup --system appgroup && adduser --system --ingroup appgroup --home /home/appuser appuser
RUN chown -R appuser:appgroup /app
RUN mkdir -p /home/appuser/.cache && chown -R appuser:appgroup /home/appuser
USER appuser

# Set UV cache directory
ENV UV_CACHE_DIR=/home/appuser/.cache/uv

# Set FastMCP host to bind to all interfaces for Docker
ENV FASTMCP_HOST=0.0.0.0

# Expose port (adjust if your server uses a different port)
EXPOSE 8000

# Run the MCP server
CMD ["uv", "run", "python", "src/streamable_http_server.py"]