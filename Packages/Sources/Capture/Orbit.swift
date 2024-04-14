//
//  Orbit.swift
//
//
//  Created by 日野森寛也 on 2024/04/14.
//

import Foundation

enum Orbit: CaseIterable {
    case orbit1, orbit2, orbit3
    
    func next() -> Self {
        let currentIndex = Self.allCases.firstIndex(of: self)!
        let nextIndex = Self.allCases.index(after: currentIndex)
        return Self.allCases[nextIndex == Self.allCases.endIndex ? Self.allCases.endIndex - 1 : nextIndex]
    }
    
    static var max: Self { allCases.last! }
}
