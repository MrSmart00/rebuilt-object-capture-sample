//
//  FeedbackMessage.swift
//  
//
//  Created by 日野森寛也 on 2024/04/13.
//

import Foundation

public enum FeedbackMessage {
    case objectTooFar
    case objectTooClose
    case environmentTooDark
    case environmentLowLight
    case movingTooFast
    case outOfFieldOfView
    
    public func value() -> String {
        switch self {
        case .objectTooFar:
            return "Move Closer"
        case .objectTooClose:
            return "Move Farther Away"
        case .environmentTooDark, .environmentLowLight:
            return "More Light Required"
        case .movingTooFast:
            return "Move slower"
        case .outOfFieldOfView:
            return "Aim at your object"
        }
    }
}
