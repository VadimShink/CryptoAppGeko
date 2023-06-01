//
//  MainDetailViewModel.swift
//  CryptoAppTest
//
//  Created by Vadim Shinkarenko on 1.06.2023.
//

import Foundation

final class MainDetailViewModel: ObservableObject {
    
    var chartViewModel: ChartViewModel?
    
    let detailModel: CoinModel
    let closeAction: () -> Void
    
    private let model: Model
    
    init(model: Model, detailModel: CoinModel, closeAction: @escaping () -> Void) {
        
        self.model = model
        self.detailModel = detailModel
        self.closeAction = closeAction
        
        self.chartViewModel = ChartViewModel(coin: detailModel)
    }
}
