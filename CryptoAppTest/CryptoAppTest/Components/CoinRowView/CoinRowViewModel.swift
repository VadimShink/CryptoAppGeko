//
//  CoinRowViewModel.swift
//  CryptoAppTest
//
//  Created by Vadim Shinkarenko on 30.05.2023.
//

import Foundation

class CoinRowViewModel: Identifiable, ObservableObject {
    
    let id: String
    let name: String
    let symbol: String
    let image: String?
    let currentPrice: String
    let priceChange24h: String
    let priceChangePercentage24h: String
    
    var isPositive: Bool = false
    
    let action: (String) -> Void
    
    init(id: String, name: String, symbol: String, image: String?, currentPrice: Double, priceChange24h: Double, priceChangePercentage24h: Double, action: @escaping (String) -> Void) {
        
        self.id = id
        self.name = name
        self.symbol = symbol
        self.image = image
        self.currentPrice = currentPrice.asCurrencyWith2Decimals()
        self.priceChange24h = priceChange24h.asSignedCurrencyWith2Decimals()
        self.priceChangePercentage24h = priceChangePercentage24h.asPercentString()
        
        self.isPositive = priceChange24h.isPositive()
        self.action = action
        
//        print("INIT: \(self.id)")
    }
    
    convenience init(coin: CoinModel, action: @escaping (String) -> Void) {
        self.init(
            id: coin.id,
            name: coin.name,
            symbol: coin.symbol,
            image: coin.image,
            currentPrice: coin.currentPrice,
            priceChange24h: coin.priceChange24H ?? 0,
            priceChangePercentage24h: coin.priceChangePercentage24H ?? 0,
            action: action)
    }
}
