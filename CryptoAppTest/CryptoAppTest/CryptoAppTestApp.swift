//
//  CryptoAppTestApp.swift
//  CryptoAppTest
//
//  Created by Vadim Shinkarenko on 28.05.2023.
//

import SwiftUI

@main
struct CryptoAppTestApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var model: Model {
        
        let environment = ServerAgent.Environment.test
        
        let serverAgent = ServerAgent(environment: environment)
        
        let localContext = LocalAgent.Context(cacheFolderName: "cache", encoder: JSONEncoder(), decoder: JSONDecoder(), fileManager: FileManager.default)
        let localAgent = LocalAgent(context: localContext)
        
        let model = Model(serverAgent: serverAgent, localAgent: localAgent)
        
        return model
    }
    
    var mainTabBarViewModel: MainTabBarViewModel {
        
        return MainTabBarViewModel(model: model)
    }
    
    var body: some Scene {
        WindowGroup {
            MainTabBarView(viewModel: mainTabBarViewModel)
        }
    }
}
