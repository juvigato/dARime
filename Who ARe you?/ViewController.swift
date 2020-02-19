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
    var pontuação:Int = 0
    var timerLabelWorks = UILabel()
    var lblPontuacao = UILabel()
    var timer = Timer()
    var tempo = 60
    var boolTimer = false
    
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
         
        playButton.setTitle("Jogar", for: .normal)
        playButton.titleLabel?.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        playButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Thin", size: 35)
        
        playButton.addTarget(self, action: #selector(playButtonRecognizer(_:)), for: .touchDown)

        sceneView.addSubview(playButton)
    }
    
    func createPassButton() {
        let viewHeight = self.view.frame.height
        let viewWidth = self.view.frame.width
        
        passButton.frame = CGRect(x: viewWidth/1.6, y: viewHeight/2 + 200, width: 160 , height: 80)
        passButton.backgroundColor = .orange
        
        passButton.addTarget(self, action: #selector(handleCheckButton(_:)), for: .touchDown) //vai realizar uma ação quando tocado
        
        sceneView.addSubview(passButton)
    }
    
    func createCheckButton() {
        let viewHeight = self.view.frame.height
        let viewWidth = self.view.frame.width
        
        checkButton.frame = CGRect(x: viewWidth/500, y: viewHeight/2 + 200, width: 160 , height: 80)
        checkButton.backgroundColor = .orange
        
        checkButton.addTarget(self, action: #selector(handlePassButton(_:)), for: .touchDown) //vai realizar uma ação quando tocado
        
        createLabelTimer()
        iniciarTimer()
        
        sceneView.addSubview(checkButton)
    }
    
    func createLabelTimer() {
        timerLabelWorks.frame = CGRect(x: 0, y: 0, width: 200, height: 100 )
        timerLabelWorks.font = timerLabelWorks.font.withSize(50)
        timerLabelWorks.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        timerLabelWorks.center = CGPoint(x: (self.view.frame.width/2), y: (self.view.frame.height)/10)
        timerLabelWorks.textAlignment = .center
        timerLabelWorks.text = "60"
        self.view.addSubview(timerLabelWorks)
    }
    
    func createLblPontuacao() {
        lblPontuacao.frame = CGRect(x: 0, y: 0, width: 250, height: 100 )
        lblPontuacao.font = timerLabelWorks.font.withSize(40)
        lblPontuacao.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        lblPontuacao.center = CGPoint(x: (self.view.frame.width/2), y: (self.view.frame.height)/1.5)
        lblPontuacao.textAlignment = .center
        lblPontuacao.text = ("Pontuação: \(String(pontuação))")
        self.view.addSubview(lblPontuacao)
    }
    
    func iniciarTimer(){
        if boolTimer == false {
            updateTimer()
            boolTimer = true
        }
    }
    
    func updateTimer(){
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: {[weak self] (_) in
            guard let strongSelf = self else {return}
            
            strongSelf.tempo -= 1
            strongSelf.timerLabelWorks.text = "\(strongSelf.tempo)"
            
            //strongSelf.timer.invalidate() isso para o timer
            if strongSelf.tempo == 0 || strongSelf.pontuação == 2 {
                strongSelf.timer.invalidate()
//                strongSelf.timerLabelWorks.text = "Parou"
                strongSelf.timerLabelWorks.isHidden = true
                strongSelf.createLblPontuacao()
            }
        })
    }
    
    //Quando clica em acerto, faz algo
    @objc func handleCheckButton(_ gestureRecognize: UIGestureRecognizer){
        face.removeFromParentNode()
        face = random.random3DPicker()
        
        
        
        if face.name == "vazio" {
            // venceu
            
        } else {
            pontuação += 1
            node.addChildNode(face)
        }
    }
    
    // Quando clica em passar, faz algo
    @objc func handlePassButton(_ gestureRecognize: UIGestureRecognizer){
        
    }
    
    @objc func playButtonRecognizer(_ gestureRecognize: UIGestureRecognizer){
            createPassButton()
            createCheckButton()
            playButton.removeFromSuperview()
    }
    
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        
        guard let faceAnchor = anchor as? ARFaceAnchor else { return nil }
        currentFaceAnchor = faceAnchor

//        face = random.random3DPicker()
//
//        node.addChildNode(face)
        
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
