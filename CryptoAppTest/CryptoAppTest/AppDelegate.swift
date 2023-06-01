//
//  AppDelegate.swift
//  CryptoAppTest
//
//  Created by Vadim Shinkarenko on 28.05.2023.
//

import Foundation
import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
    
    var model: Model {
        
        let environment = ServerAgent.Environment.test
        
        let serverAgent = ServerAgent(environment: environment)
        
        let localContext = LocalAgent.Context(cacheFolderName: "cache", encoder: JSONEncoder(), decoder: JSONDecoder(), fileManager: FileManager.default)
        let localAgent = LocalAgent(context: localContext)
        
        let model = Model(serverAgent: serverAgent, localAgent: localAgent)
        
        return model
    }
    
    static var shared: AppDelegate { return UIApplication.shared.delegate as! AppDelegate }
}
