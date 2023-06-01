//
//  CoinRowView.swift
//  CryptoAppTest
//
//  Created by Vadim Shinkarenko on 28.05.2023.
//

import SwiftUI


struct CoinRowView: View {
    
    @ObservedObject var viewModel: CoinRowViewModel
    
    var body: some View {
        
        HStack(spacing: 8) {
            
            Circle()
                .frame(width: 40, height: 40)
            
            VStack(alignment: .leading, spacing: 0) {
                
                Text(viewModel.name)
                    .font(.headline)
                
                Text(viewModel.symbol.uppercased())
                    .foregroundColor(.gray)
            }
            
            Spacer(minLength: 10)
            
            VStack(alignment: .trailing) {
                
                Text(viewModel.currentPrice)
                    .bold()
                
                HStack {
                    
                    Text(viewModel.priceChange24h)
                    
                    Text(viewModel.priceChangePercentage24h)
                }
                .foregroundColor(viewModel.isPositive ? .green : .red)
            }
        }
        .background {
            Color.white.opacity(0.001)
        }
        .onTapGesture {
            viewModel.action(viewModel.id)
        }
    }
}

struct CoinRowView_Previews: PreviewProvider {
    static var previews: some View {
        
        CoinRowView(viewModel: .init(
            id: UUID().uuidString,
            name: "Bitcoin",
            symbol: "btc",
            image: "https://assets.coingecko.com/coins/images/1/large/bitcoin.png?1547033579",
            currentPrice: 27199,
            priceChange24h: 499.87,
//            priceChange24h: 0,
            priceChangePercentage24h: 1.87225,
            action: { _ in })
        )
            .padding(.horizontal, 16)
        
        SystemFontHelper()
    }
}

struct SystemFontHelper: View {
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 8) {
            
            Text("This is system font: body")
                .font(.body)
            
            Text("This is system font: callout")
                .font(.callout)
            
            Text("This is system font: caption")
                .font(.caption)
            
            Text("This is system font: caption2")
                .font(.caption2)
            
            Text("This is system font: footnote")
                .font(.footnote)
            
            VStack(alignment: .leading, spacing: 8) {
                
                Text("This is system font: headline")
                    .font(.headline)
                
                Text("This is system font: largeTitle")
                    .font(.largeTitle)
                
                Text("This is system font: subheadline")
                    .font(.subheadline)
                
                Text("This is system font: title")
                    .font(.title)
                
                Text("This is system font: title2")
                    .font(.title2)
                
                Text("This is system font: title3")
                    .font(.title3)
            }
        }
    }
}
