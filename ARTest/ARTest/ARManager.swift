//
//  ARManager.swift
//  ARTest
//
//  Created by Roll'n'Code on 21.08.2024.
//

import Foundation
import ARKit
import SceneKit

class ARManager : NSObject, ObservableObject {
    static let shared = ARManager()
    @Published var hasMesh = false
    
    private weak var session: ARSession?
    private var worldMap: ARWorldMap?
    private var scene: SCNScene?
    
    private override init() { }
    
    func configure(view: ARSCNView) {
        view.session.delegate = self
        view.delegate = self
        
        let url = loadPath()
        
        let modelRootNode = try? SCNScene(url: url, options: [.checkConsistency: true])
        if (modelRootNode != nil) {
            view.scene = modelRootNode!
        }

        
        scene = view.scene
        
        let configuration = ARWorldTrackingConfiguration()
        configuration.sceneReconstruction = .meshWithClassification
        configuration.environmentTexturing = .automatic
        if (worldMap != nil) {
            configuration.initialWorldMap = worldMap
        }
        session = view.session
        
        
        view.session.run(configuration);
    }
    
    func saveModel() {
        let path = FileManager.default.urls(for: .documentDirectory,
                                            in: .userDomainMask)[0]
            .appendingPathComponent("model.usdz")
        
        scene?.write(to: path, delegate: nil);
        hasMesh = true;
    }
    
    func loadPath() -> URL {
        let path = FileManager.default.urls(for: .documentDirectory,
                                            in: .userDomainMask)[0]
            .appendingPathComponent("model.usdz")
        return path
    }
    
    func clearModel() {
        let path = FileManager.default.urls(for: .documentDirectory,
                                            in: .userDomainMask)[0]
            .appendingPathComponent("model.usdz")
        do
        {
            try FileManager().removeItem(at: path)
            hasMesh = false;
        } catch {
            debugPrint("Error occured")
        }
    }
    
    func clearData() {
        session = nil;
        scene = nil;
        worldMap = nil;
        clearModel()
    }
    
    func stopSession(completionBlock: @escaping () -> Void) {
        session?.getCurrentWorldMap(completionHandler: { map, error in
            if (error != nil) {
                debugPrint("An error occured")
            } else {
                self.worldMap = map
            }
            self.session?.pause()
            self.saveModel()
            completionBlock()
        })
        
    }
    
    func nearbyFaceWithClassification(to array: [ARMeshAnchor], completionBlock: @escaping (SIMD3<Float>?, ARMeshClassification) -> Void) {
        guard let _ = session?.currentFrame else {
            completionBlock(nil, .none)
            return
        }
        
        let meshAnchors = array.compactMap({ $0 as? ARMeshAnchor })
        
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
    
    private func loadMeshes() {
        
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
