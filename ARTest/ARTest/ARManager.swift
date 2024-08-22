//
//  ARManager.swift
//  ARTest
//
//  Created by Roll'n'Code on 21.08.2024.
//

import Foundation
import ARKit
import SceneKit

class ARManager : NSObject, ARSessionDelegate {
    static let shared = ARManager()

    private override init() { }
    
    func configure(session: ARSession) {
        session.delegate = self
        let configuration = ARWorldTrackingConfiguration();
        configuration.sceneReconstruction = .meshWithClassification;
        session.run(configuration, options: [.resetTracking, .removeExistingAnchors]);
    }
    
}
