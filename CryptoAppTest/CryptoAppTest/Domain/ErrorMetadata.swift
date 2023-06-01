//
//  ErrorMetadata.swift
//  CryptoAppTest
//
//  Created by Vadim Shinkarenko on 28.05.2023.
//

import Foundation

struct ErrorMetadata: Codable {
    
    let errors: [Error]?
    let messages: Messages?
    
    struct Error: Codable {
        
        let id: String
        let messages: [String]
    }
    
    
    struct Messages: Codable {
        let common: [String]
    }
}
