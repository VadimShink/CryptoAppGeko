//
//  String+Converting.swift
//  CryptoAppTest
//
//  Created by Vadim Shinkarenko on 28.05.2023.
//

import Foundation

extension String {
    
    func isPositive() -> Bool {
        
        if let number = Double(self) {
            return number >= 0
        }
        return false
    }
}
