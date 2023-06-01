//
//  LocalAgent.swift
//  CryptoAppTest
//
//  Created by Vadim Shinkarenko on 28.05.2023.
//

import Foundation

class LocalAgent: LocalAgentProtocol {
    
    private let context: Context
    
    init(context: Context) {
        
        self.context = context
    }
    
    //MARK: - Store
    func store<T>(_ data: T) throws where T : Encodable {
        LoggerAgent.shared.log(category: .cache, message: "save: \(T.self)")
        
        let dataFileName = fileName(for: T.self)
        let data = try context.encoder.encode(data)
        try data.write(to: fileURL(with: dataFileName))
        
    }
    
    //MARK: - Load
    func load<T>(type: T.Type) -> T? where T : Decodable {
        LoggerAgent.shared.log(category: .cache, message: "load: \(T.self)")
        
        let fileName = fileName(for: type)
        
        do {
            
            let data = try Data(contentsOf: fileURL(with: fileName))
            let decodedData = try context.decoder.decode(T.self, from: data)
            
            return decodedData
            
        } catch let error {
            if error is DecodingError {
                
                LoggerAgent.shared.log(category: .cache, message: "load error in \(T.self): \(error)")
            }
            return nil
        }
    }
    
    //MARK: - Clear
    func clear<T>(type: T.Type) throws {
        
        let fileName = fileName(for: type)
        try context.fileManager.removeItem(at: fileURL(with: fileName))
        LoggerAgent.shared.log(category: .cache, message: "clear: \(T.self)")
    }
    
}


//MARK: - Internal Helpers
extension LocalAgent {
    
    func rootFolderURL() throws -> URL {
        
        return try context.fileManager.rootFolderURL(with: context.cacheFolderName)
    }
    
    func fileURL(with name: String) throws -> URL {
        
        return try rootFolderURL().appendingPathComponent(name)
    }
    
}

//MARK: - Types
extension LocalAgent {
    
    struct Context {
        
        init(cacheFolderName: String, encoder: JSONEncoder, decoder: JSONDecoder, fileManager: FileManager) {
            self.cacheFolderName = cacheFolderName
            self.encoder = encoder
            self.decoder = decoder
            self.fileManager = fileManager
        }
        
        let cacheFolderName: String
        let encoder: JSONEncoder
        let decoder: JSONDecoder
        let fileManager: FileManager
    }
}

extension FileManager {
    
    func rootFolderURL(with name: String) throws -> URL {
        
        let folderURL = try url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            .appendingPathComponent(name, isDirectory: true)
        try createDirectory(at: folderURL, withIntermediateDirectories: true)
        
        return folderURL
    }
}
