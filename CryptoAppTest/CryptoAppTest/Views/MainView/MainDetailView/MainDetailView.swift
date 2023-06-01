//
//  MainDetailView.swift
//  CryptoAppTest
//
//  Created by Vadim Shinkarenko on 28.05.2023.
//

import SwiftUI


struct MainDetailView: View {
    
    @ObservedObject var viewModel: MainDetailViewModel
    
    var body: some View {
        
        ZStack {
            
            ScrollView {
                
                if let chart = viewModel.chartViewModel {
                    ChartView(viewModel: chart)
                }
                
                Text(viewModel.detailModel.name)
                
                ForEach(0..<10) { _ in
                    
                    RoundedRectangle(cornerRadius: 8)
                        .foregroundColor(.gray)
                        .frame(height: 250)
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    
                } label: {
                    Image(systemName: "gear")
                }

            }
            
            ToolbarItem {
                Button {
                    
                } label: {
                    Image(systemName: "gear")
                }
            }
            
        }
        .navigationTitle(viewModel.detailModel.name)
    }
}

struct MainDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MainDetailView(viewModel: .init(model: .emptyMock, detailModel: dev.coin, closeAction: {}))
    }
}
