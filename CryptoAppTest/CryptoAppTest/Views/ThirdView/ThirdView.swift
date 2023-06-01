//
//  ThirdView.swift
//  CryptoAppTest
//
//  Created by Vadim Shinkarenko on 28.05.2023.
//

import SwiftUI

final class ThirdViewModel: ObservableObject {
    
    private let model: Model
    
    init(model: Model) {
        self.model = model
    }
}

struct ThirdView: View {
    
    @ObservedObject var viewModel: ThirdViewModel
    
    var body: some View {
        
        ScrollView {
            
            VStack {
                
                ForEach(1..<15) { _ in
                    
                    RoundedRectangle(cornerRadius: 8)
                        .foregroundColor(.green)
                        .frame(height: 250)
                }
            }
            .padding(.horizontal, 16)
        }
    }
}

struct ThirdView_Previews: PreviewProvider {
    static var previews: some View {
        ThirdView(viewModel: .init(model: .emptyMock))
    }
}
