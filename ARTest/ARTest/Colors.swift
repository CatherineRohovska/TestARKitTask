//
//  Colors.swift
//  ARTest
//
//  Created by Roll'n'Code on 22.08.2024.
//

import Foundation
import ARKit

let VECTOR_WHITE : SIMD4<Float> = SIMD4<Float>(1.0, 1.0, 1.0, 1.0)
let VECTOR_YELLOW: SIMD4<Float> = SIMD4<Float>(1.0, 1.0, 0, 1.0)
let VECTOR_BLUE: SIMD4<Float> = SIMD4<Float>(0, 0, 1.0, 1.0)
let VECTOR_GREEN: SIMD4<Float> = SIMD4<Float>(0, 1.0, 0.0, 1.0)
let VECTOR_GRAY: SIMD4<Float> = SIMD4<Float>(0, 0.0, 0.0, 0.7)
let VECTOR_RED: SIMD4<Float> = SIMD4<Float>(1.0, 0.0, 0.0, 1.0)

extension ARMeshClassification {
    var description: String {
        switch self {
        case .ceiling: return "Ceiling"
        case .door: return "Door"
        case .floor: return "Floor"
        case .seat: return "Seat"
        case .table: return "Table"
        case .wall: return "Wall"
        case .window: return "Window"
        case .none: return "None"
        @unknown default: return "Unknown"
        }
    }
    
    var color: UIColor {
        switch self {
        case .ceiling: return .yellow
        case .door: return .red
        case .floor: return .green
        case .wall: return .blue
        case .window: return .white
        default: return .gray
        }
    }
    
    var colorVector: SIMD4<Float> {
        switch self {
        case .ceiling: return VECTOR_YELLOW
        case .door: return VECTOR_RED
        case .floor: return VECTOR_GREEN
        case .wall: return VECTOR_BLUE
        case .window: return VECTOR_WHITE
        default: return VECTOR_GRAY
        }
    }
}
