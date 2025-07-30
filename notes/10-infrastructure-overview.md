# Slide 8: Infrastructure Overview

"The `infra/` folder contains our Azure infrastructure as code:"

- `resources.bicep` - Defines our Container App, Container Registry, and monitoring
- `apim-api/` - API Management configuration for enterprise features
- `main.bicep` - Orchestrates the entire deployment

```bash
# Test the deployed server
npx @modelcontextprotocol/inspector https://mcp-container-py.blacksea-1835d48f.eastus.azurecontainerapps.io/mcp
```
