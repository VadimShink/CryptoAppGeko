//
//  LoggerAgent.swift
//  CryptoAppTest
//
//  Created by Vadim Shinkarenko on 28.05.2023.
//

import Foundation
import OSLog

class LoggerAgent: LoggerAgentProtocol {
    
    static let shared = LoggerAgent()
    static let subsystem = "Vadim.Shinkarenko.CryptoAppTest"
    
    private let modelLogger = Logger(subsystem: subsystem, category: LoggerAgentCategory.model.rawValue)
    private let uiLogger = Logger(subsystem: subsystem, category: LoggerAgentCategory.ui.rawValue)
    private let networkLogger = Logger(subsystem: subsystem, category: LoggerAgentCategory.network.rawValue)
    private let cacheLogger = Logger(subsystem: subsystem, category: LoggerAgentCategory.cache.rawValue)
    private let sessionLogger = Logger(subsystem: subsystem, category: LoggerAgentCategory.session.rawValue)
    
    func log(level: LoggerAgentLevel = .default, category: LoggerAgentCategory, message: String, file: String = #file, line: Int = #line) {
        
        let logMessage = "\(extractFileName(from: file)): \(message), #:\(line)"
        let logger = logger(for: category)
        
        switch level {
            case .debug: logger.debug("\(logMessage, privacy: .public)")
            case .info: logger.info("\(logMessage, privacy: .public)")
            case .default: logger.notice("\(logMessage, privacy: .public)")
            case .error: logger.error("\(logMessage, privacy: .public)")
            case .fault: logger.fault("\(logMessage, privacy: .public)")
        }
    }
    
    private func logger(for category: LoggerAgentCategory) -> Logger {
        
        switch category {
            case .model: return modelLogger
            case .ui: return uiLogger
            case .network: return networkLogger
            case .cache: return cacheLogger
            case .session: return sessionLogger
        }
    }
    
    private func extractFileName(from path: String) -> String {
        path.components(separatedBy: "/").last?.components(separatedBy: ".").first ?? ""
    }
}
