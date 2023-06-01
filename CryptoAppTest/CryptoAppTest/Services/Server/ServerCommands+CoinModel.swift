//
//  ServerCommands+CoinModel.swift
//  CryptoAppTest
//
//  Created by Vadim Shinkarenko on 28.05.2023.
//

import Foundation

enum ServerCommands {
    
    enum CoinController {
        
//        https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=true&price_change_percentage=24h

        struct GetCoinModel: ServerCommand {

            let token: String? = nil
            var endpoint: String {
                "/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=20&page=\(page)&sparkline=true&price_change_percentage=24h"
            }
            let method: ServerCommandMethod = .get
            let payload: Payload? = nil
            let page: Int

            let parameters: [ServerCommandParameter]? = nil
            
            typealias Payload = EmptyData
            
            typealias Response = [CoinModel]
            
            init(page: Int) {
                self.page = page
            }
        }
    }
}
