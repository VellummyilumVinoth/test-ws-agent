
import ballerina/mcp;
import ballerina/time;

// mcp:Listener is deprecated as of mcp 1.3.0 — use mcp:StreamableHttpListener.
listener mcp:StreamableHttpListener mcpListener = check new (9092);

@mcp:StreamableHttpServiceConfig {
    info: {
        name: "Notes MCP Server",
        version: "1.0.0"
    },
    // STATEFUL: session id is issued on initialize and persists per client.
    sessionMode: mcp:STATEFUL
}
service mcp:StreamableHttpService /mcp on mcpListener {

    @mcp:Tool {
        description: "Add a note to the current session and return the updated note count"
    }
    remote function addNote(mcp:Session session, string text) returns int|error {
        string[] notes = session.hasKey("notes") ? check session.getWithType("notes") : [];
        notes.push(text);
        session.set("notes", notes);
        return notes.length();
    }

    @mcp:Tool {
        description: "List all notes stored in the current session"
    }
    remote function listNotes(mcp:Session session) returns string[]|error {
        return session.hasKey("notes") ? check session.getWithType("notes") : [];
    }

    @mcp:Tool {
        description: "Clear all notes in the current session"
    }
    remote function clearNotes(mcp:Session session) returns string {
        session.set("notes", <string[]>[]);
        return "Notes cleared";
    }

    // No @mcp:Tool annotation needed — the doc comment below is used as the
    // tool description when the annotation is omitted.
    # Get the current server time.
    # + return - ISO 8601 formatted current UTC time
    remote function getServerTime() returns string {
        return time:utcToString(time:utcNow());
    }
}
