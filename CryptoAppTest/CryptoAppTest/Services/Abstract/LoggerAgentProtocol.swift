//
//  LoggerAgentProtocol.swift
//  CryptoAppTest
//
//  Created by Vadim Shinkarenko on 28.05.2023.
//

import Foundation
import OSLog

protocol LoggerAgentProtocol {
    
    func log(level: LoggerAgentLevel, category: LoggerAgentCategory, message: String, file: String, line: Int)
}

enum LoggerAgentLevel {
    
    case debug
    case info
    case `default`
    case error
    case fault
}

enum LoggerAgentCategory: String, CaseIterable {
    
    case model
    case ui
    case network
    case cache
    case session
}
