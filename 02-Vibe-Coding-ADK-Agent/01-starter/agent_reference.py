from google.adk.agents import Agent
from google.adk.tools.mcp_tool import McpToolset
from google.adk.tools.mcp_tool.mcp_session_manager import StdioConnectionParams
from mcp import StdioServerParameters
import logging
import os
import sys

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

agent_instruction = """
    Use the 'load_web_page' tool to fetch content from a URL provided by the user.
    """

root_agent = Agent(
    model="gemini-2.5-flash",
    name="root_agent",
    instruction=agent_instruction,
    tools=[
        McpToolset(
            connection_params=StdioConnectionParams(
                server_params=StdioServerParameters(
                    command=sys.executable,
                    args=[os.path.join(os.path.dirname(os.path.abspath(__file__)), "../", "mcp_server.py")],
                    env=os.environ.copy()
                ),
                timeout=120
            )
        )
    ],
)