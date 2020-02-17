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

class ViewController: UIViewController, ARSessionDelegate, ARSCNViewDelegate {
    
    @IBOutlet var sceneView: ARSCNView!
    var currentFaceAnchor: ARFaceAnchor?
    var contentNode = SCNNode()
    var face:SCNNode = SCNNode()
    var buttonT = UIButton()
    
    let node = SCNNode()

    
    var needChange = true


    override func viewDidLoad() {
        super.viewDidLoad()
        
        createButton()
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
    
    func createButton() {
        
        let viewHeight = self.view.frame.height
        let viewWidth = self.view.frame.width
        
        buttonT.frame = CGRect(x: viewWidth/1.60, y: viewHeight/2 + 200, width: 160 , height: 80)
        buttonT.backgroundColor = .orange
        
        buttonT.addTarget(self, action: #selector(handleButton(_:)), for: .touchDown)

        sceneView.addSubview(buttonT)

    }
    
    @objc func handleButton(_ gestureRecognize: UIGestureRecognizer){
        if needChange {
            buttonT.addTarget(self, action: #selector(handleButton(_:)), for: .touchDown)

            needChange = false
            face.removeFromParentNode()
            face = Random3DNodes().random3DPicker()
            node.addChildNode(face)
        } else {
            needChange = true
        }
    }
    
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        
        guard let faceAnchor = anchor as? ARFaceAnchor else { return nil }
        currentFaceAnchor = faceAnchor
        
        let random = Random3DNodes()
        
        face = random.random3DPicker()
        
        node.addChildNode(face)
        
        return node
    }
        
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        
        guard let faceAnchor = anchor as? ARFaceAnchor
        else { return }
        
//        if !faceAnchor.isTracked && needChange {
//
//            needChange = false
//            face.removeFromParentNode()
//            face = Random3DNodes().random3DPicker()
//            node.addChildNode(face)
//        } else {
//            needChange = true
//        }
        
    }
    
}
