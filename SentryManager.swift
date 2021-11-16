import Sentry

final class SentryManager {
    static let shared = SentryManager()
    
    enum NetworkRequestState: String {
        case failure = "NETWORK REQUEST FAILURE: "
        case success = "NETWORK REQUEST SUCCESS: "
    }
    
    func start(with dsn: String) {
        SentrySDK.start { options in
            options.dsn = dsn
            options.debug = false
        }
    }
    
    func log(with message: Message) {
        SentrySDK.capture(message: message.build()) { [weak self] scope in
            guard let self = self else { return }
            scope.setLevel(message.level)
            scope.setFingerprint([message.route()])
        }
    }
    
    func captureObjectMappingError(with error: DecodingError, model: Decodable.Type) {
        SentrySDK.capture(message:
        """
        \n OBJECT MAPPING FAILED:
        \n For model: \(model.self)
        \n Error message: \(error.localizedDescription)
        \n Reason: \(error)
        """)
    }
}

extension SentryManager {
    struct Message {
        var state: NetworkRequestState = .success
        var request: URLRequest?
        var response: HTTPURLResponse?
        var responseData: Data = Data("RESPONSE BODY NOT AVAILABLE".utf8)
        var level: SentryLevel = .info
        
        func route() -> String {
            guard let request = request else { return "NOT AVAILABLE"}
            return request.debugDescription.replacingOccurrences(of: "https://wheretowheel.us/api", with: "")
        }
        
        func build() -> String {
            var message = ""
            message += "\n \(state.rawValue)\(route())\n"
            
            if let request = request {
            message += """
            \n Request HTTP Method Type: \(request.httpMethod ?? "Unknown")
            \n Request URL: \(request.debugDescription)
            \n Request Headers: \(request.allHTTPHeaderFields ?? [:])
            \n Request Body: \(String(describing: try? JSONSerialization.jsonObject(with: request.httpBody ?? Data("REQUEST BODY NOT AVAILABLE".utf8), options: [])))\n
            """
            }
            
            if let response = response {
            message += """
            \n Response Status Code: \(response.statusCode)
            \n Response Headers: \(response.allHeaderFields)
            \n Response Body: \(String(describing: try? JSONSerialization.jsonObject(with: responseData, options: [])))
            """
            }
            
            return message
        }
    }
}

