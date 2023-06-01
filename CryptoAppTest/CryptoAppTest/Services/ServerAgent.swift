//
//  ServerAgent.swift
//  CryptoAppTest
//
//  Created by Vadim Shinkarenko on 28.05.2023.
//

import Foundation
import Combine

class ServerAgent: NSObject, ServerAgentProtocol {
   
    let action: PassthroughSubject<Action, Never> = .init()

    private var baseURL: String { environment.baseURL }
    private let environment: Environment
    
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder
    
    private lazy var session: URLSession = {
        
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 600
        configuration.httpShouldSetCookies = false
        configuration.httpCookieAcceptPolicy = .never

        return URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
    }()
    
    init(environment: Environment) {
        
        self.environment = environment
        self.encoder = JSONEncoder()//.serverDate
        self.decoder = JSONDecoder()//.serverDate
    }
    
    func executeCommand<Command>(command: Command, completion: @escaping (Result<Command.Response, ServerAgentError>) -> Void) where Command : ServerCommand {
        
        do {
            
            let request = try request(with: command)
            LoggerAgent.shared.log(category: .network, message: "data request: \(request)")
            session.dataTask(with: request) { [unowned self] data, response, error in
                
                if let error = error {
                    debugPrint("DEBUG request ERROR: \(error)")
                    completion(.failure(.sessionError(error)))
                    return
                }
                
                guard let data = data else {
                    
                    completion(.failure(.emptyResponseData))
                    return
                }
                
                if let response = response as? HTTPURLResponse {
                    
                    
                    if response.statusCode == 200 {
                       
                        self.action.send(ServerAgentAction.NetworkActivityEvent())
                        
                        if let empty = EmptyData() as? Command.Response {
                            completion(.success(empty))
                            
                        } else {
                            
                            do {
//                                if let str = String(data: data, encoding: .utf8) {
//                                    print("DEBUG Response Answer \(response.url?.absoluteString ?? "") ", str)
//                                }
                                let response = try decoder.decode(Command.Response.self, from: data)
                                completion(.success(response))
                                
                            } catch {
                                if error is DecodingError {
                                    
                                    LoggerAgent.shared.log(category: .network, message: "DecodingError in \(command.endpoint)\nError: \(error)")
                                }
                                completion(.failure(.curruptedData(error)))
                            }
                        }
                    } else if response.statusCode == 204 {
                        
                        if let empty = EmptyData() as? Command.Response {
                            completion(.success(empty))
                        } else {
                            completion(.failure(.emptyResponseData))
                        }
                        
                    } else {
                        
                        if response.statusCode == 401 {
                            
                            self.action.send(ServerAgentAction.NotAuthorized())
                        }
                        
                        do {
//                            if let str = String(data: data, encoding: .utf8) {
//                                print("DEBUG Response Error \(response.url?.absoluteString ?? "") ", str)
//                            }
                            let data = try decoder.decode(ErrorMetadata.self, from: data)
                            // TODO: parse server error
                            completion(.failure(.serverStatus(errorMessage: data.errors?.first?.messages.first ?? "")))
                            
                        } catch let error {
                            if error is DecodingError {
                                
                                LoggerAgent.shared.log(category: .network, message: "DecodingError in \(command.endpoint)\nError: \(error)")
                            }
                            completion(.failure(.curruptedData(error, status: ServerAgentError.ResponseStatus(rawValue: response.statusCode))))
                        }   
                    }
                }
                
            }.resume()
            
        } catch {
//            debugPrint("DEBUG request ERROR: \(error)")
            completion(.failure(ServerAgentError.requestCreationError(error)))
        }
    }
    
    func executeCommand<Command>(command: Command) async throws -> Command.Response where Command: ServerCommand {
        
        let request = try request(with: command)
        LoggerAgent.shared.log(category: .network, message: "data request: \(request)")
        
        let (data, response) = try await session.data(for: request)
        
        guard let response = response as? HTTPURLResponse else { throw ServerAgentError.emptyResponseData }
        
        if response.statusCode == 200 {
            
            self.action.send(ServerAgentAction.NetworkActivityEvent())
            
            if let empty = EmptyData() as? Command.Response {
                
                debugPrint("DEBUG Response Answer \(response.url?.absoluteString ?? "") Empty")
                return empty
                
            } else {
                
//                if let str = String(data: data, encoding: .utf8) {
//                    print("DEBUG Response Answer \(response.url?.absoluteString ?? "") ", str)
//                }
//
                do {
                    let response = try decoder.decode(Command.Response.self, from: data)
                    return response
                }
                catch let error {
                    if error is DecodingError {
                        
                        LoggerAgent.shared.log(category: .network, message: "DecodingError in \(command.endpoint)\nError: \(error)")
                    }
                    throw ServerAgentError.curruptedData(error)
                }
            }
            
        } else {
            
            if response.statusCode == 401 {
                
                self.action.send(ServerAgentAction.NotAuthorized())
            }
            
            do {
//                if let str = String(data: data, encoding: .utf8) {
//                    print("DEBUG Response Error \(response.url?.absoluteString ?? "") ", str)
//                }
                let response = try decoder.decode(ErrorMetadata.self, from: data)
                
                throw ServerAgentError.serverStatus(errorMessage: response.errors?.first?.messages.first ?? "")
            }
            catch let error {
                if error is DecodingError {
                    
                    LoggerAgent.shared.log(category: .network, message: "DecodingError in \(command.endpoint)\nError: \(error)")
                }
                throw ServerAgentError.curruptedData(error, status: ServerAgentError.ResponseStatus(rawValue: response.statusCode))
            }
        }
    }
    
    func request<Command>(with command: Command) throws -> URLRequest where Command : ServerCommand {
        
        guard let url = URL(string: baseURL + command.endpoint) else {
            throw ServerRequestCreationError.unableConstructURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = command.method.rawValue
        
        /// Token
        if let token = command.token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        /// Parameters
        if let parameters = command.parameters, parameters.isEmpty == false {
            
            var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
            urlComponents?.queryItems = parameters.map{ URLQueryItem(name: $0.name, value: $0.value) }
            
            guard let updatedURL = urlComponents?.url else {
                throw ServerRequestCreationError.unableCounstructURLWithParameters
            }
            
            request.url = updatedURL
        }
        
        /// Body
        if let payload = command.payload {
            
            do {
                
                request.httpBody = try encoder.encode(payload)
                
            } catch {
                
                throw ServerRequestCreationError.unableEncodePayload(error)
            }
        }
        if request.httpBody != nil {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        return request
    }
    
    func uploadFileTask<Command>(command: Command, fileUrl: URL) async throws -> Result<Command.Response, ServerAgentError> where Command: ServerCommand {
        do {
            var request = try request(with: command)
            request.httpMethod = command.method.rawValue
            let boundary = "Boundary-\(UUID().uuidString)"
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            if let token = command.token {
                
                request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
                
            }
            var datas = Data()
               let fileName = fileUrl.lastPathComponent
            do {
                let fileData = try Data(contentsOf: fileUrl)
                datas.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
                datas.append("Content-Disposition: form-data; name=\"file\"; filename=\"\(fileName)\"\r\n".data(using: .utf8)!)
                datas.append("Content-Type: application/\(fileUrl.pathExtension)\r\n\r\n".data(using: .utf8)!)
                datas.append(fileData)
                datas.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
            } catch {
                print(error.localizedDescription)
            }
            let (data, response) = try await session.upload(for: request, from: datas)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                return .failure(ServerAgentError.emptyResponseData)
            }
            
            guard (200..<300).contains(httpResponse.statusCode) else {
                return .failure(ServerAgentError.serverStatus(errorMessage: String(httpResponse.statusCode)))
            }
            
            self.action.send(ServerAgentAction.NetworkActivityEvent())
            
            let responseData = try JSONDecoder().decode(Command.Response.self, from: data)
            return .success(responseData)
        } catch {
            return .failure(ServerAgentError.requestCreationError(error))
        }
    }
    
}

//MARK: - URLSessionTaskDelegate

extension ServerAgent: URLSessionTaskDelegate {
    
    func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?) {
        
        if let error = error {
            
            LoggerAgent.shared.log(level: .error, category: .network, message: "URL Session did become invalid with error: \(error.localizedDescription)")
            
        } else {
            
            LoggerAgent.shared.log(level: .error, category: .network, message: "URL Session did become invalid")
        }
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        
        if let error = error {
            
            LoggerAgent.shared.log(level: .error, category: .network, message: "URLSessionTask: \(String(describing: task.originalRequest?.url)) did complete with error: \(error.localizedDescription)")
            
        } else {
            
            LoggerAgent.shared.log(level: .error, category: .network, message: "URLSessionTask: \(String(describing: task.originalRequest?.url)) did complete unexpected")
        }
    }
}


//MARK: - Context

extension ServerAgent {
    
    public enum Environment {
        
        case test
        case prod
        
        var baseURL: String {
            
            switch self {
                case .test:
//                https://api.coingecko.com/api/v3/coins/categories/list
                    return "https://api.coingecko.com"
                    
                case .prod:
//                https://api.coingecko.com/api/v3/coins/categories/list
                    return "https://api.coingecko.com"
            }
        }
    }
}
