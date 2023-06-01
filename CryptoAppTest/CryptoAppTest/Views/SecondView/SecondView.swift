//
//  SecondView.swift
//  CryptoAppTest
//
//  Created by Vadim Shinkarenko on 28.05.2023.
//

import SwiftUI

final class SecondViewModel: ObservableObject {
    
    private let model: Model
    
    init(model: Model) {
        self.model = model
    }
    
    func goToTheFirstTab() {
        self.model.action.send(TabBarAction.ChangeTab(selectedTab: 1))
    }
}

struct SecondView: View {
    
    @ObservedObject var viewModel: SecondViewModel
    
    var body: some View {
        
        ScrollView {
            
            VStack {
                
                Button("Go to the first tab") {
                    print("button is tapped")
                    
                    viewModel.goToTheFirstTab()
                }
            }
        }
    }
}

struct SecondView_Previews: PreviewProvider {
    static var previews: some View {
        SecondView(viewModel: .init(model: .emptyMock))
    }
}
