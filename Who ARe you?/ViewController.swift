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
    var playButton = UIButton()
    var checkButton = UIButton()
    var passButton = UIButton()
    
    let node = SCNNode()
    let random = Random3DNodes()


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
        
        playButton.frame = CGRect(x: viewWidth/3.2, y: viewHeight/2 + 200, width: 160 , height: 80)
        playButton.backgroundColor = .orange
        
        playButton.addTarget(self, action: #selector(playButtonRecognizer(_:)), for: .touchDown)

        sceneView.addSubview(playButton)

    }
    
    func checkButtonFunc() {
        let viewHeight = self.view.frame.height
        let viewWidth = self.view.frame.width
        
        passButton.frame = CGRect(x: viewWidth/1.6, y: viewHeight/2 + 200, width: 160 , height: 80)
        passButton.backgroundColor = .orange
        
        passButton.addTarget(self, action: #selector(handleCheckButton(_:)), for: .touchDown) //vai realizar uma ação quando tocado
        
        sceneView.addSubview(passButton)
    }
    
    func passButtonFunc() {
        let viewHeight = self.view.frame.height
        let viewWidth = self.view.frame.width
        
        checkButton.frame = CGRect(x: viewWidth/500, y: viewHeight/2 + 200, width: 160 , height: 80)
        checkButton.backgroundColor = .orange
        
        checkButton.addTarget(self, action: #selector(handlePassButton(_:)), for: .touchDown) //vai realizar uma ação quando tocado
        
        sceneView.addSubview(checkButton)
    }
    
    
    @objc func handleCheckButton(_ gestureRecognize: UIGestureRecognizer){ //Quando clica em acerto, faz algo
        face.removeFromParentNode()
        face = random.random3DPicker()
        node.addChildNode(face)
    }
    
    @objc func handlePassButton(_ gestureRecognize: UIGestureRecognizer){ // QUando clica em passar, faz algo
        
    }
    
    @objc func playButtonRecognizer(_ gestureRecognize: UIGestureRecognizer){
            checkButtonFunc()
            passButtonFunc()
            playButton.removeFromSuperview()
    }
    
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        
        guard let faceAnchor = anchor as? ARFaceAnchor else { return nil }
        currentFaceAnchor = faceAnchor

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
