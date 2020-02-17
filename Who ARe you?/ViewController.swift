//
//  ViewController.swift
//  Who ARe you?
//
//  Created by Guilherme Enes on 17/02/20.
//  Copyright © 2020 Guilherme Enes. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSessionDelegate {
    
    @IBOutlet var sceneView: ARSCNView!
    var currentFaceAnchor: ARFaceAnchor?
    var contentNode = SCNNode()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard ARFaceTrackingConfiguration.isSupported else {
            fatalError("Face tracking is not supported on this device")
        }
        sceneView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let configuration = ARFaceTrackingConfiguration()
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
           super.viewWillDisappear(animated)
           sceneView.session.pause()
    }

    
}

extension ViewController: ARSCNViewDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        
        guard let faceAnchor = anchor as? ARFaceAnchor else { return nil }
        currentFaceAnchor = faceAnchor
        
        contentNode = SCNReferenceNode(named: "cabeca")
        
//        let nodeTeste = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0)
//        nodeTeste.firstMaterial?.diffuse.contents = UIColor.orange
//        nodeTeste.firstMaterial?.isDoubleSided = true
//        let nnode = SCNNode(geometry: nodeTeste)
        
        
        
        return contentNode
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        
        guard let faceAnchor = anchor as? ARFaceAnchor
        else { return }
        
        
    }
    
}
