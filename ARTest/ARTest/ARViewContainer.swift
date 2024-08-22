//
//  ARViewContainer.swift
//  ARTest
//
//  Created by Roll'n'Code on 21.08.2024.
//

import SwiftUI
import RealityKit
import SceneKit
import ARKit

struct ARViewContainer: UIViewRepresentable {
    
    func makeUIView(context: Context) -> ARSCNView {
        
        let arView = ARSCNView(frame: .zero)
        ARManager.shared.configure(session: arView.session)
        return arView
        
    }
    func updateUIView(_ uiView: ARSCNView, context: Context) {
        
    }
    
}
