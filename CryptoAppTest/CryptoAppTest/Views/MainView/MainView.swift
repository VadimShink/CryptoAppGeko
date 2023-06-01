//
//  MainView.swift
//  CryptoAppTest
//
//  Created by Vadim Shinkarenko on 28.05.2023.
//

import SwiftUI


struct MainView: View {
    
    @ObservedObject var viewModel: MainViewModel
    
    var body: some View {
        
        ZStack {
            
            NavigationLink("", isActive: $viewModel.isLinkActive) {
                
                if let link = viewModel.link  {
                    
                    switch link {
                        case .detailView(let viewModel):
                            MainDetailView(viewModel: viewModel)
                    }
                }
            }
            
            ScrollView {
                
                LazyVStack(alignment: .leading, spacing: 8) {
                    
                    ForEach(viewModel.coinList) { coin in
                        
                        CoinRowView(viewModel: coin)
                            .onAppear {
                                viewModel.loadMoreContent(currentCoin: coin)
                            }
                    }
                }
                .padding(.horizontal, 16)
                
                if viewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(.circular)
                }
            }
            .refreshable {
                await viewModel.loadScreenData()
            }
        }
        
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(viewModel: .init(model: .emptyMock))
    }
}
