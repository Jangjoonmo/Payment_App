//
//  LineChartView.swift
//  delight_labs_assignment
//
//  Created by 장준모 on 2/23/24.
//

import SwiftUI
import RxSwift
import RxCocoa

struct ContentView: View {
    @StateObject var viewModel = LineChartViewModel()

    var body: some View {
        VStack {
            LineChartView(data: viewModel.incomeData, lineColor: .green)
            LineChartView(data: viewModel.expenseData, lineColor: .blue)
        }
    }
}

struct LineChartView: View {
    var data: [Double]
    var lineColor: Color
    
    var minY: Double { data.min() ?? 0 }
    var maxY: Double { data.max() ?? 1 }
    
    @State private var endPoint: CGFloat = .zero
    
    var curGradient: LinearGradient {
        LinearGradient(
            gradient: Gradient(
                colors: [
                    lineColor.opacity(0.5),
                    lineColor.opacity(0.2),
                    lineColor.opacity(0.05)
                ]
            ),
            startPoint: .top,
            endPoint: .bottom
        )
    }
    
    var body: some View {
        VStack {
            GeometryReader { geometry in
                ZStack {
                    
                    Path { path in
                        for i in data.indices {
                            let xPosition = geometry.size.width / Double(data.count - 1) * Double(i)
                            let yPosition = (1 - (data[i] - minY) / (maxY - minY)) * Double(geometry.size.height)
                            let point = CGPoint(x: xPosition, y: yPosition)
                            
                            if i == 0 {
                                path.move(to: CGPoint(x: point.x, y: geometry.size.height))
                                path.addLine(to: point)
                            } else {
                                path.addLine(to: point)
                            }
                            
                            if i == data.indices.last {
                                path.addLine(to: CGPoint(x: geometry.size.width, y: geometry.size.height))
                            }
                        }
                    }
                    .fill(curGradient)
                    
                    
                    Path { path in
                        for i in data.indices {
                            let xPosition = geometry.size.width / Double(data.count - 1) * Double(i)
                            let yPosition = (1 - (data[i] - minY) / (maxY - minY)) * Double(geometry.size.height)
                            let point = CGPoint(x: xPosition, y: yPosition)
                            
                            if i == 0 {
                                path.move(to: point)
                            } else {
                                path.addLine(to: point)
                            }
                        }
                    }
                    .trim(from: 0, to: endPoint)
                    .stroke(lineColor, lineWidth: 2)
                }
            }
            .onAppear {
                withAnimation(.linear(duration: 2)) {
                    self.endPoint = 1
                }
            }
            HStack {
                Text(Date().addingTimeInterval(-6 * 24 * 60 * 60), formatter: dateFormatter)
                Spacer()
                Text(Date(), formatter: dateFormatter)
            }
        }
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return formatter
    }
}
