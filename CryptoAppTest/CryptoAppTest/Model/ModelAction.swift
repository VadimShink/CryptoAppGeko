//
//  ModelAction.swift
//  CryptoAppTest
//
//  Created by Vadim Shinkarenko on 28.05.2023.
//

import Foundation

enum ModelAction {
    
    enum App {
    
        struct Launched: Action {}
        
        struct Activated: Action {}
        
        struct Inactivated: Action {}
    }
}
