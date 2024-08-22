//
//  ARManager.swift
//  ARTest
//
//  Created by Roll'n'Code on 21.08.2024.
//

import Foundation
import ARKit
import SceneKit

class ARManager : NSObject {
    static let shared = ARManager()
    private var session: ARSession?
    private var coloriser = Coloriser()
    
    private override init() { }
    
    func configure(view: ARSCNView) {
        view.session.delegate = self
        view.delegate = self
        let configuration = ARWorldTrackingConfiguration()
        configuration.sceneReconstruction = .meshWithClassification
        configuration.environmentTexturing = .automatic
        session = view.session
        view.session.run(configuration, options: [.resetTracking, .removeExistingAnchors]);
    }
    
    func nearbyFaceWithClassification(to array: [ARMeshAnchor], completionBlock: @escaping (SIMD3<Float>?, ARMeshClassification) -> Void) {
        guard let frame = session?.currentFrame else {
            completionBlock(nil, .none)
            return
        }
        
        var meshAnchors = array.compactMap({ $0 as? ARMeshAnchor })
        
        //        let cutoffDistance: Float = 2.0
        //        meshAnchors.removeAll { distance($0.transform.position, location) > cutoffDistance }
        //        meshAnchors.sort { distance($0.transform.position, location) < distance($1.transform.position, location) }
        DispatchQueue.global().async {
            for anchor in meshAnchors {
                for index in 0..<anchor.geometry.faces.count {
                    let geometricCenterOfFace = anchor.geometry.centerOf(faceWithIndex: index)
                    var centerLocalTransform = matrix_identity_float4x4
                    centerLocalTransform.columns.3 = SIMD4<Float>(geometricCenterOfFace.0, geometricCenterOfFace.1, geometricCenterOfFace.2, 1)
                    let centerWorldPosition = (anchor.transform * centerLocalTransform).position
                    let classification: ARMeshClassification = anchor.geometry.classificationOf(faceWithIndex: index)
                    completionBlock(centerWorldPosition, classification)
                }
            }
            
            // Let the completion block know that no result was found.
            completionBlock(nil, .none)
        }
    }
    
}

extension ARManager : ARSessionDelegate {
    func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
        let meshAnchors = anchors.compactMap({$0 as? ARMeshAnchor })
    }
}

extension ARManager : ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
        
    }
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        guard let meshAnchor = anchor as? ARMeshAnchor else {
            return nil
        }
        let geometry = SCNGeometry(arGeometry: meshAnchor.geometry)
        
        let classification = meshAnchor.geometry.classificationOf(faceWithIndex: 0)
        let defaultMaterial = SCNMaterial()
        defaultMaterial.fillMode = .lines
        defaultMaterial.diffuse.contents = classification.color
        geometry.materials = [defaultMaterial]
        let node = SCNNode()
        node.geometry = geometry
        return node
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let meshAnchor = anchor as? ARMeshAnchor else {
            return
        }
        let newGeometry = SCNGeometry(arGeometry: meshAnchor.geometry)
        
        let classification = meshAnchor.geometry.classificationOf(faceWithIndex: 0)
        let defaultMaterial = SCNMaterial()
        defaultMaterial.fillMode = .lines
        defaultMaterial.diffuse.contents = classification.color
        newGeometry.materials = [defaultMaterial]
        node.geometry = newGeometry
    }
}
