import ballerina/ai;
import ballerina/http;
import ballerinax/ai.wso2.integration;
import ballerina/log;
import ballerina/websocket;

listener http:Listener httpListener = check new (9090, httpVersion = "1.1");
listener websocket:Listener wsListener = check new (9091);
listener ai:Listener chatAgentListener = new (listenOn = httpListener);

service on new integration:CloudVoiceListener(listenOn = wsListener) {
    isolated remote function onChatMessage(integration:ChatMessage message) returns string|error {
        log:printInfo("Message: ", input = message);
        string response = check mathTutorAgent.run(message.message, message.sessionId);
        log:printInfo("Response: ", output = response);
        return response;
    }
}

service /mathTutor on chatAgentListener {
    resource function post chat(@http:Payload ai:ChatReqMessage request) returns ai:ChatRespMessage|error {
        string stringResult = check mathTutorAgent.run(request.message, request.sessionId);
        return {message: stringResult};
    }
}
