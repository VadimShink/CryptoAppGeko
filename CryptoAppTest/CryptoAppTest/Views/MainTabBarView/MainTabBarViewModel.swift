//
//  MainTabBarViewModel.swift
//  CryptoAppTest
//
//  Created by Vadim Shinkarenko on 28.05.2023.
//

import Foundation
import Combine


final class MainTabBarViewModel: ObservableObject {
    
    @Published var selectedTab = 1
    
    let main: MainViewModel
    let second: SecondViewModel
    let third: ThirdViewModel
    
    let model: Model
    
    private var bindings = Set<AnyCancellable>()
    
    init(model: Model) {
        self.model = model
        
        self.main = .init(model: model)
        self.second = .init(model: model)
        self.third = .init(model: model)
        
        bind()
    }
    
    func bind() {
        
        $selectedTab
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] selectedTab in
                model.action.send(TabBarAction.CloseAll())
            }
            .store(in: &bindings)
        
        model.action
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] action in
                
                switch action {
                        
                    case let payload as TabBarAction.ChangeTab:
                        selectedTab = payload.selectedTab
                        
                    default:
                        break
                }
            }
            .store(in: &bindings)
    }
}

//MARK: - TabBar Actions
enum TabBarAction {
    
    struct ChangeTab: Action {
        let selectedTab: Int
    }
    
    struct CloseAll: Action { }
}
