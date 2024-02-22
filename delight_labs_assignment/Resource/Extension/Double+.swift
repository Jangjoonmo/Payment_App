//
//  Double+.swift
//  delight_labs_assignment
//
//  Created by 장준모 on 2/23/24.
//

import Foundation

extension Double {
    func rounded(toPlaces places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
