//
//  ChartViewModel.swift
//  CryptoAppTest
//
//  Created by Vadim Shinkarenko on 30.05.2023.
//

import Foundation
import SwiftUI

class ChartViewModel: ObservableObject {
    
    let data: [Double]
    let maxY: Double
    let minY: Double
    let lineColor: Color
    let startingDate: String
    let endingDate: String
    
    init(data: [Double], maxY: Double, minY: Double, lineColor: Color, startingDate: String, endingDate: String) {
        
        self.data = data
        self.maxY = maxY
        self.minY = minY
        self.lineColor = lineColor
        self.startingDate = startingDate
        self.endingDate = endingDate
    }
    
    convenience init(coin: CoinModel) {
        
        let data = coin.sparklineIn7D.price
        
        let priceChange = (data.last ?? 0) - (data.first ?? 0)
        
        let endingDate = DateFormatter.convertDateFrom(string: coin.lastUpdated)
        let qwe = DateFormatter.convertStringFromDate(coin.lastUpdated).addingTimeInterval(-7*24*60*60)
        let startingDate = DateFormatter.convertToString(from: qwe)
        
        self.init(
            data: coin.sparklineIn7D.price,
            maxY: data.max() ?? 0,
            minY: data.min() ?? 0,
            lineColor: priceChange > 0 ? .green : .red,
            startingDate: startingDate,
            endingDate: endingDate)
    }
}
