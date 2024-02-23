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
    @ObservedObject var viewModel: LineChartViewModel
    
    init(viewModel: LineChartViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
//        VStack {
//            LineChartView(viewModel: viewModel, incomeColor: Color(uiColor: UIColor(named: "GreenColor") ?? .green), expenseColor: Color(uiColor: UIColor(named: "MainColor") ?? .blue))
//        }
        VStack {
            if viewModel.isLoading {
                // 로딩 인디케이터 표시
                ActivityIndicator()
            } else {
                // 그래프 표시
                LineChartView(viewModel: viewModel, incomeColor: Color(uiColor: UIColor(named: "GreenColor") ?? .green), expenseColor: Color(uiColor: UIColor(named: "MainColor") ?? .blue))                    }
        }
    }
}

struct LineChartView: View {
    
    @ObservedObject var viewModel: LineChartViewModel
    
    var incomeColor: Color
    var expenseColor: Color
    
    var minY: Double { min(viewModel.incomeData.min() ?? 0, viewModel.expenseData.min() ?? 0) }
    var maxY: Double { max(viewModel.incomeData.max() ?? 1, viewModel.expenseData.max() ?? 1) }
    
    @State private var endPoint: CGFloat = .zero
    
    var body: some View {
        VStack {
            GeometryReader { geometry in
                ZStack {
                    createPath(data: viewModel.incomeData, geometry: geometry, lineColor: incomeColor)
                    createPath(data: viewModel.expenseData, geometry: geometry, lineColor: expenseColor)
                }
            }
            .onAppear {
                print("Income data: \(viewModel.incomeData)")
                print("Expense data: \(viewModel.expenseData)")
                
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
    func createPath(data: [Double], geometry: GeometryProxy, lineColor: Color) -> some View {
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
            .fill(curGradient(lineColor: lineColor))
            
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
    
    func curGradient(lineColor: Color) -> LinearGradient {
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
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return formatter
    }
}

struct ActivityIndicator: UIViewRepresentable {
    func makeUIView(context: UIViewRepresentableContext<ActivityIndicator>) -> UIActivityIndicatorView {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.startAnimating()
        return indicator
    }
    
    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<ActivityIndicator>) {
        // No-op
    }
}
