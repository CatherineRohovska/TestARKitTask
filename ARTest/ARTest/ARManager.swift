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
    @Published var hasUsdz = false
    
    private weak var session: ARSession?
    private var scene: SCNScene?
    
    private override init() { }
    
    func configure(view: ARSCNView) {
        view.delegate = self

        scene = view.scene
        
        let configuration = ARWorldTrackingConfiguration()
        configuration.sceneReconstruction = .meshWithClassification
        configuration.environmentTexturing = .automatic
        session = view.session
        
        view.session.run(configuration);
    }
    
    func saveModelUSDZ() {
        let path = FileManager.default.urls(for: .documentDirectory,
                                            in: .userDomainMask)[0]
            .appendingPathComponent("model.usdz")
        
        scene?.write(to: path, delegate: nil);
        hasUsdz = true;
    }
    
    func loadPathUSDZ() -> URL {
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
            hasUsdz = false;
        } catch {
            debugPrint("Error occured")
        }
    }
    
    func clearData() {
        session = nil;
        scene = nil;
        clearModel()
    }
    
    func stopSession(completionBlock: @escaping () -> Void) {
        self.session?.pause()
        self.saveModelUSDZ()
        completionBlock()
    }
}

extension ARManager : ARSCNViewDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        guard let meshAnchor = anchor as? ARMeshAnchor else {
            return nil
        }
        let geometry = SCNGeometry.fromAnchor(meshAnchor: meshAnchor, setColors: true)
        let node = SCNNode()
        node.geometry = geometry
        return node
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let meshAnchor = anchor as? ARMeshAnchor else {
            return
        }
        let newGeometry = SCNGeometry.fromAnchor(meshAnchor: meshAnchor, setColors: true)
        node.geometry = newGeometry
    }
}
