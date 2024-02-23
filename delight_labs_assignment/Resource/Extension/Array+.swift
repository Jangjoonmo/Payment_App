//
//  Array+.swift
//  delight_labs_assignment
//
//  Created by 장준모 on 2/23/24.
//

import Foundation

//배열을 주어진 크기의 하위 배열로 나누는 Extension
extension Array {
    func chunks(of size: Int) -> [[Element]] {
        stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}
