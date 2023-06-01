//
//  LocalAgentProtocol.swift
//  CryptoAppTest
//
//  Created by Vadim Shinkarenko on 28.05.2023.
//

import Foundation

protocol LocalAgentProtocol {
    
    func store<T>(_ data: T) throws where T : Encodable
    func load<T>(type: T.Type) -> T? where T : Decodable
    func clear<T>(type: T.Type) throws
    func fileName<T>(for type: T.Type) -> String
}

extension LocalAgentProtocol {
    
    func fileName<T>(for type: T.Type) -> String {
        
        "\(type.self).json"
            .lowercased()
            .replacingOccurrences(of: "<", with: "_")
            .replacingOccurrences(of: ">", with: "")
            .replacingOccurrences(of: " ", with: "_")
            .replacingOccurrences(of: ",", with: "")
    }
}
