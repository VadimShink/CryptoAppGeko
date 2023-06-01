//
//  Model.swift
//  CryptoAppTest
//
//  Created by Vadim Shinkarenko on 28.05.2023.
//

import Foundation
import Combine

class Model {
    
    //MARK: - Interface
    let action: PassthroughSubject<Action, Never> = .init()
    
    //MARK: - Private
    private var bindings: Set<AnyCancellable>
    private let queue = DispatchQueue(label: "Vadim.Shinkarenko.CryptoAppTest", qos: .userInitiated, attributes: .concurrent)
    
    //MARK: - Services
    internal let serverAgent: ServerAgentProtocol
    internal let localAgent: LocalAgentProtocol
    
    //MARK: - Init
    init(serverAgent: ServerAgentProtocol, localAgent: LocalAgentProtocol) {
        
        bindings = []
        
        self.serverAgent = serverAgent
        self.localAgent = localAgent
        
        bind()
    }
    
    private func bind() {
        
    }
}

//MARK: - EmptyMock
/// Для превью
extension Model {
    
    static var emptyMock: Model {
        
        let environment = ServerAgent.Environment.test
        
        let serverAgent = ServerAgent(environment: environment)
        
        let localContext = LocalAgent.Context(cacheFolderName: "cache", encoder: JSONEncoder(), decoder: JSONDecoder(), fileManager: FileManager.default)
        let localAgent = LocalAgent(context: localContext)
        
        let model = Model(serverAgent: serverAgent, localAgent: localAgent)
        
        return model
    }
}
