//
//  ServerAgentProtocol.swift
//  CryptoAppTest
//
//  Created by Vadim Shinkarenko on 28.05.2023.
//

import SwiftUI
import Combine

protocol ServerAgentProtocol {
    
    var action: PassthroughSubject<Action, Never> { get }
    
    func executeCommand<Command: ServerCommand>(command: Command, completion: @escaping (Result<Command.Response, ServerAgentError>) -> Void)
    
    func executeCommand<Command>(command: Command) async throws -> Command.Response where Command: ServerCommand
    
    func uploadFileTask<Command>(command: Command, fileUrl: URL) async throws -> Result<Command.Response, ServerAgentError> where Command: ServerCommand
    
}

protocol ServerCommand {
    
    associatedtype Payload: Encodable
    associatedtype Response: Decodable
    
    var token: String? { get }
    var endpoint: String { get }
    var method: ServerCommandMethod { get }
    var parameters: [ServerCommandParameter]? { get }
    var payload: Payload? { get }
}


enum ServerAgentError: Error {
    
    case requestCreationError(Error)
    case sessionError(Error)
    case emptyResponseData
    case curruptedData(Error, status: ResponseStatus? = nil)
    case serverStatus(errorMessage: String)
    
    enum ResponseStatus: Int {
        case badRequest = 400
        case forbidden = 403
        case notFound = 404
        case internalServerError = 500
        case badGateway = 502
        case serviceUnavailable = 503
    }
}

enum ServerRequestCreationError: Error {
    
    case unableCreateCommand
    case unableConstructURL
    case unableCounstructURLWithParameters
    case unableEncodePayload(Error)
}

enum ServerCommandMethod: String {
    
    case post = "POST"
    case get = "GET"
    case put = "PUT"
    case delete = "DELETE"
    case patch = "PATCH"
}

struct ServerCommandParameter {
    
    let name: String
    let value: String
}

enum ServerAgentAction {
    
    struct NetworkActivityEvent: Action { }
    struct NotAuthorized: Action { }
}
