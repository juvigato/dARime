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
    var repeatButton = UIButton()
    var pontuação:Int = 0
    var timerLabelWorks = UILabel()
    var lblPontuacao = UILabel()
    var timer = Timer()
    var tempo = 60
    var boolTimer = false
    
    let node = SCNNode()
    let random = Random3DNodes()
    var viewHeight: CGFloat = 0.0
    var viewWidth: CGFloat = 0.0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        createButton()
        
        guard ARFaceTrackingConfiguration.isSupported else {
            fatalError("Face tracking is not supported on this device")
        }
        sceneView.delegate = self
        viewHeight = self.view.frame.height
        viewWidth = self.view.frame.width
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
        playButton.frame = CGRect(x: viewWidth/3.2, y: viewHeight/2 + 200, width: 160 , height: 80)
        playButton.backgroundColor = .orange
        playButton.center = CGPoint(x: (self.view.frame.width/2), y: (self.view.frame.height)/1.3)
         
        playButton.setTitle("Jogar", for: .normal)
        playButton.titleLabel?.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        playButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Thin", size: 35)
        
        playButton.addTarget(self, action: #selector(handlePlayButton(_:)), for: .touchDown)

        sceneView.addSubview(playButton)
    }
    
    func createPassButton() {
        passButton.frame = CGRect(x: viewWidth/1.6, y: viewHeight/2 + 200, width: 160 , height: 80)
        passButton.backgroundColor = .orange
        
        passButton.setTitle("Acertou", for: .normal)
        passButton.titleLabel?.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        passButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Thin", size: 35)
        
        passButton.addTarget(self, action: #selector(handleCheckButton(_:)), for: .touchDown) //vai realizar uma ação quando tocado
        
        sceneView.addSubview(passButton)
    }
    
    func createCheckButton() {
        checkButton.frame = CGRect(x: viewWidth/500, y: viewHeight/2 + 200, width: 160 , height: 80)
        checkButton.backgroundColor = .orange
        
        checkButton.setTitle("Errou", for: .normal)
        checkButton.titleLabel?.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        checkButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Thin", size: 35)
        
        checkButton.addTarget(self, action: #selector(handlePassButton(_:)), for: .touchDown) //vai realizar uma ação quando tocado
        
        createLabelTimer()
        iniciarTimer()
        
        sceneView.addSubview(checkButton)
    }
    
    func createRepeatGameButton() {
        repeatButton.frame = CGRect(x: viewWidth/500, y: viewHeight/2 + 200, width: 250 , height: 100)
        repeatButton.backgroundColor = .orange
        repeatButton.center = CGPoint(x: (self.view.frame.width/2), y: (self.view.frame.height)/1.3)
        
        repeatButton.setTitle("Jogar de novo", for: .normal)
        repeatButton.titleLabel?.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        repeatButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Thin", size: 35)
        
        repeatButton.addTarget(self, action: #selector(handlePassButton(_:)), for: .touchDown) //vai realizar uma ação quando tocado
        
        sceneView.addSubview(repeatButton)
    }
    
    func createLabelTimer() {
        timerLabelWorks.frame = CGRect(x: 0, y: 0, width: 200, height: 100 )
        timerLabelWorks.font = timerLabelWorks.font.withSize(50)
        timerLabelWorks.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        timerLabelWorks.center = CGPoint(x: (self.view.frame.width/2), y: (self.view.frame.height)/10)
        timerLabelWorks.textAlignment = .center
//        timerLabelWorks.text = "60"
        self.view.addSubview(timerLabelWorks)
    }
    
    func createLblPontuacao() {
        lblPontuacao.frame = CGRect(x: 0, y: 0, width: 250, height: 100 )
        lblPontuacao.font = timerLabelWorks.font.withSize(40)
        lblPontuacao.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        lblPontuacao.center = CGPoint(x: (self.view.frame.width/2), y: (self.view.frame.height)/10)
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
                strongSelf.timerLabelWorks.text = ""
                strongSelf.timerLabelWorks.removeFromSuperview()
                strongSelf.checkButton.removeFromSuperview()
                strongSelf.passButton.removeFromSuperview()
                strongSelf.createLblPontuacao()
                strongSelf.createRepeatGameButton()
                strongSelf.tempo = 60
                strongSelf.repeatButton.addTarget(self, action: #selector(strongSelf.handleRepeatButton(_:)), for: .touchDown)
            }
        })
    }
    
    //Quando clica em acerto, faz algo
    @objc func handleCheckButton(_ gestureRecognize: UIGestureRecognizer){
        
        if face.name != "vazio" {
            pontuação += 1
        }
        face.removeFromParentNode()
        face = random.random3DPicker()
        node.addChildNode(face)
    }
    
    // Quando clica em passar, faz algo
    @objc func handlePassButton(_ gestureRecognize: UIGestureRecognizer){
        
    }
    
    @objc func handlePlayButton(_ gestureRecognize: UIGestureRecognizer){
        face = random.random3DPicker()
        node.addChildNode(face)
        createPassButton()
        createCheckButton()
        playButton.removeFromSuperview()
    }
    
    @objc func handleRepeatButton(_ gestureRecognize: UIGestureRecognizer) {
        random.arrayMascaras = []
        pontuação = 0
        boolTimer = false
        face.removeFromParentNode()
        repeatButton.removeFromSuperview()
        lblPontuacao.removeFromSuperview()
        face = random.random3DPicker()
        node.addChildNode(face)
        createPassButton()
        createCheckButton()
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
