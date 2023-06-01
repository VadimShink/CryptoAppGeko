//
//  ChartView.swift
//  CryptoAppTest
//
//  Created by Vadim Shinkarenko on 30.05.2023.
//

import SwiftUI


struct ChartView: View {
    
    @ObservedObject var viewModel: ChartViewModel
    
    @State private var percentage: CGFloat = 0
    
    var body: some View {
        
        VStack {

            ChartView
                .frame(height: 200)
                .background(ChartBackground)
                .overlay(ChartYAxis.padding(.horizontal, 4), alignment: .leading)
            
            ChartDateLabels
                .padding(.horizontal, 4)
        }
        .font(.caption)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                withAnimation(.linear(duration: 2.0)) {
                    percentage = 1.0
                }
            }
        }
    }
}

struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        ChartView(viewModel: .init(coin: dev.coin))
    }
}

extension ChartView {
    
    private var ChartView: some View {
        
        GeometryReader { geometry in
            
            Path { path in
                
                for index in viewModel.data.indices {
                    
                    let xPosition = geometry.size.width / CGFloat(viewModel.data.count) * CGFloat(index + 1)
                    
                    let yAxis = viewModel.maxY - viewModel.minY
                    
                    let yPosition = (1 - CGFloat((viewModel.data[index] - viewModel.minY) / yAxis)) * geometry.size.height
                    
                    if index == 0 {
                        path.move(to: CGPoint(x: xPosition, y: yPosition))
                    }
                    path.addLine(to: CGPoint(x: xPosition, y: yPosition))
                    
                }
            }
            .trim(from: 0, to: percentage)
            .stroke(viewModel.lineColor, style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
        }
    }
    
    private var ChartBackground: some View {
        
        VStack {
            
            Divider()
            
            Spacer()
            
            Divider()
            
            Spacer()
            
            Divider()
        }
    }
    
    private var ChartYAxis: some View {
        
        VStack {
            
            Text(viewModel.maxY.formattedWithAbbreviations())
            
            Spacer()
            
            Text(((viewModel.maxY + viewModel.minY) / 2).formattedWithAbbreviations())
            
            Spacer()
            
            Text(viewModel.minY.formattedWithAbbreviations())
        }
    }
    
    private var ChartDateLabels: some View {
        
        HStack {
            
            Text(viewModel.startingDate)

            Spacer()

            Text(viewModel.endingDate)
        }
    }
}
