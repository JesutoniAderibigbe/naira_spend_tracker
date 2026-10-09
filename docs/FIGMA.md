# Figma setup for step 5

You need a Figma link that points at a frame with the app's colours and text
styles. A free Figma account is enough.

## Option 1: use the facilitator's file

If your facilitator shared a Figma link, open it, select the **Tokens** frame
and copy its link:

- Figma desktop: select the frame and press Ctrl/Cmd + L.
- Figma web: select the frame and copy the browser URL.

A valid link contains both a file ID and `node-id=`.

## Option 2: make your own in 5 minutes

1. Create a new design file called **Naira Spend Tracker**.
2. Add a frame named **Tokens**.
3. Inside it, draw six rectangles and create a **colour style** (or variable)
   for each:

   | Style name | Hex |
   | --- | --- |
   | `brand/primary` | `#008751` |
   | `brand/on-primary` | `#FFFFFF` |
   | `brand/secondary` | `#F2A900` |
   | `surface/background` | `#F7F9F7` |
   | `surface/card` | `#E3F1E8` |
   | `text/muted` | `#5B6B62` |

4. Add three text layers and create a **text style** for each:

   | Style name | Font | Size | Weight |
   | --- | --- | --- | --- |
   | `headline/amount` | Inter | 32 | Bold |
   | `title/section` | Inter | 18 | Semi Bold |
   | `body/default` | Inter | 14 | Regular |

5. Copy the link to the **Tokens** frame.

`design/tokens.json` in the `04-final` branch holds these same values, so you
can compare what your agent extracted with the reference.

## Connecting the MCP server

| Host | Server | How |
| --- | --- | --- |
| Claude Code | Official Figma remote MCP | Already in `.mcp.json`. Run `/mcp`, pick **figma**, **Authenticate**. Or install the plugin: `claude plugin install figma@claude-plugins-official` |
| Cursor | Official Figma remote MCP | Already in `.cursor/mcp.json`, or `/add-plugin figma`. Click **Connect** and allow access. |
| VS Code Copilot | Official Figma remote MCP | Already in `.vscode/mcp.json`. Click **Start**, then **Allow Access**. |
| Antigravity, `agy`, others | Community `figma-flutter-mcp` | Already in `.agents/mcp_config.json`. Create a personal access token in Figma, put it in `FIGMA_API_KEY` (see `.env.example`), restart the agent. |

Never commit your Figma token. `.env` is git-ignored for that reason.
