import vinothvellummyilum/ai.wso2.integration;
import ballerina/log;
import ballerina/http;
import ballerina/websocket;

listener http:Listener httpListener = check new (9090, httpVersion = "1.1");
// listener integration:CloudVoiceListener wsListener = check new (9091);

// service /voiceagent on wsListener {
//     isolated remote function onChatMessage(integration:ChatMessage message) returns string|error {
//         log:printInfo("Message: ", input = message);
//         string response = check mathTutorAgent.run(message.message, message.sessionId);
//         log:printInfo("Response: ", output = response);
//         return response;
//     }
// }
listener websocket:Listener wsListener = check new (9091);

service on new integration:CloudVoiceListener(listenOn = wsListener) {
    isolated remote function onChatMessage(integration:ChatMessage message) returns string|error {
        log:printInfo("Message: ", input = message);
        string response = check mathTutorAgent.run(message.message, message.sessionId);
        log:printInfo("Response: ", output = response);
        return response;
    }
}
