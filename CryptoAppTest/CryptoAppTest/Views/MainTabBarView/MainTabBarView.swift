//
//  MainTabBarView.swift
//  CryptoAppTest
//
//  Created by Vadim Shinkarenko on 28.05.2023.
//

import SwiftUI

struct MainTabBarView: View {
    
    init(viewModel: MainTabBarViewModel) {
        self.viewModel = viewModel
    }
    
    @ObservedObject var viewModel: MainTabBarViewModel
    
    var body: some View {
        
        TabView(selection: $viewModel.selectedTab) {
            
            NavigationView {
                MainView(viewModel: viewModel.main)
                    .navigationBarTitle("Main", displayMode: .inline)
            }
            .tabItem {
                HStack {
                    Text("Main")
                    Image(systemName: "house")
                }
            }
            .tag(1)
            
            NavigationView {
                SecondView(viewModel: viewModel.second)
                    .navigationBarTitle("Second Tab", displayMode: .inline)
            }
            .tabItem {
                HStack {
                    Text("Second")
                    Image(systemName: "house")
                }
            }
            .tag(2)
            
            NavigationView {
                ThirdView(viewModel: viewModel.third)
                    .navigationBarTitle("Third Tab", displayMode: .inline)
            }
            .tabItem {
                HStack {
                    Text("Third")
                    Image(systemName: "house")
                }
            }
            .tag(3)
        }
        .navigationViewStyle(.stack)
    }
}

struct MainTabBarView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabBarView(viewModel: .init(model: .emptyMock))
    }
}
