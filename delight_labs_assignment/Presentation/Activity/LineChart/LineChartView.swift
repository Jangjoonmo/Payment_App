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
    
    @State var incomeData: [Double] = []
    @State var expenseData: [Double] = []

    var body: some View {
        VStack {
            LineChartView(incomeData: viewModel.incomeData, expenseData: viewModel.expenseData, incomeColor: Color(uiColor: UIColor(named: "GreenColor")!), expenseColor: Color(uiColor: UIColor(named: "MainColor")!))
//            LineChartView(data: viewModel.expenseData, lineColor: .blue)
        }
    }
}


struct LineChartView: View {
    var incomeData: [Double]
    var expenseData: [Double]
    var incomeColor: Color
    var expenseColor: Color

    var minY: Double { min(incomeData.min() ?? 0, expenseData.min() ?? 0) }
    var maxY: Double { max(incomeData.max() ?? 1, expenseData.max() ?? 1) }
    
//    var average: Double { (incomeData.reduce(0, +) + expenseData.reduce(0, +)) / Double(incomeData.count + expenseData.count) }
//
//    var minY: Double { average * 0.5 }
//    var maxY: Double { average * 1.5 }

    @State private var endPoint: CGFloat = .zero

    var body: some View {
        VStack {
            GeometryReader { geometry in
                ZStack {
                    createPath(data: incomeData, geometry: geometry, lineColor: incomeColor)
                    createPath(data: expenseData, geometry: geometry, lineColor: expenseColor)
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
