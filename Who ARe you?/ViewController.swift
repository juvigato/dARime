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
    var card = UIView()
    var playButton = UIButton()
    var passButton = UIButton()
    var checkButton = UIButton()
    var repeatButton = UIButton()
    var pontuação:Int = 0
    var lblTimer = UILabel()
    var lblPontuacao = UILabel()
    var lblNome = UILabel()
    var lblPalavra1 = UILabel()
    var lblPalavra2 = UILabel()
    var timer = Timer()
    var tempo = 60
    var boolTimer = false
    
    let node = SCNNode()
    let random = Random3DNodes()
    var viewHeight: CGFloat = 0.0
    var viewWidth: CGFloat = 0.0
    
    var arrayCat: [String] = ["Felino", "Miau"]
    var arrayDuck: [String] = ["Quack", "Lago"]
    var arrayDog: [String] = ["Doméstico", "Lambida"]
    var arrayMouse: [String] = ["Roedor", "Queijo"]
    var arrayMonkey: [String] = ["Banana", "Árvores"]
    
    var music = SCNAudioSource(fileNamed: "AMENO.mp3")!
    lazy var action = SCNAction.playAudio(music, waitForCompletion: false)
    let explosion = SCNParticleSystem(named: "Explode", inDirectory: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        createButton(button: playButton, divisor: 3.2, title: "Jogar", size: 35, width: 160)
        
        guard ARFaceTrackingConfiguration.isSupported else {
            fatalError("Face tracking is not supported on this device")
        }
        sceneView.delegate = self
        viewHeight = self.view.frame.height
        viewWidth = self.view.frame.width
        
        sceneView.scene.rootNode.runAction(action)
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
    
    func createCard() {
        card.backgroundColor = .orange
        card.frame = CGRect(x: view.frame.width/2, y: view.frame.height/2, width: self.view.frame.width , height: 150)
        card.center = CGPoint(x: (self.view.frame.width/2), y: (self.view.frame.height) - 90)
        createLbl(label: lblPalavra1, width: 250, size: 30, nome: "palavra1")
        createLbl(label: lblPalavra2, width: 250, size: 30, nome: "palavra2")
        sceneView.addSubview(card)
    }
    
    func createLbl(label: UILabel, width: Int, size:CGFloat, nome: String) {
        label.frame = CGRect(x: 0, y: 0, width: width, height: 100)
        label.font = lblTimer.font.withSize(size)
        label.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        label.textAlignment = .center
        if nome == "Pontuação" {
            label.text = ("Pontuação: \(String(pontuação))")
            label.center = CGPoint(x: (self.view.frame.width/2), y: (self.view.frame.height)/10)
        } else if nome == "mascara" {
            label.center = CGPoint(x: (self.view.frame.width/5), y: (self.view.frame.height)/1.13)
            label.text = face.name
        } else if nome == "" {
            label.center = CGPoint(x: (self.view.frame.width/2), y: (self.view.frame.height)/10)
        } else {
            changeLbl(label: label, nome: nome)
        }
        self.view.addSubview(label)
    }
    
    func changeLbl(label: UILabel, nome: String) {
        if nome == "palavra1" {
            label.center = CGPoint(x: (self.view.frame.width/1.3), y: (self.view.frame.height)/1.1)
            if face.name == "Gato" {
                label.text = arrayCat[0]
            } else if face.name == "Cão" {
                label.text = arrayDog[0]
            } else if face.name == "Pato" {
                label.text = arrayDuck[0]
            } else if face.name == "Rato" {
                label.text = arrayMouse[0]
            } else if face.name == "Macaco" {
                label.text = arrayMonkey[0]
            }
        } else if nome == "palavra2" {
            label.center = CGPoint(x: (self.view.frame.width/1.3), y: (self.view.frame.height)/1.15)
            if face.name == "Gato" {
                label.text = arrayCat[1]
            } else if face.name == "Cão" {
                label.text = arrayDog[1]
            } else if face.name == "Pato" {
                label.text = arrayDuck[1]
            } else if face.name == "Rato" {
                label.text = arrayMouse[1]
            } else if face.name == "Macaco" {
                label.text = arrayMonkey[1]
            }
        }
    }
    
    func createButton(button: UIButton, divisor:CGFloat, title: String, size: CGFloat, width: CGFloat) {
        button.frame = CGRect(x: viewWidth/divisor, y: viewHeight/2 + 180, width: width , height: 80)
        button.backgroundColor = .orange
        button.setTitle(title, for: .normal)
        button.titleLabel?.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        button.titleLabel?.font = UIFont(name: "HelveticaNeue-Thin", size: size)
        if button == playButton {
            button.addTarget(self, action: #selector(handlePlayButton(_:)), for: .touchDown)
            button.center = CGPoint(x: (self.view.frame.width/2), y: (self.view.frame.height)/1.3)
        } else if button == checkButton {
            button.addTarget(self, action: #selector(handleCheckButton(_:)), for: .touchDown)
            createLbl(label: lblTimer, width: 200, size: 50, nome: "")
            iniciarTimer()
        } else if button == passButton {
            button.addTarget(self, action: #selector(handlePassButton(_:)), for: .touchDown)
        } else {
            button.addTarget(self, action: #selector(handlePassButton(_:)), for: .touchDown)
            button.center = CGPoint(x: (self.view.frame.width/2), y: (self.view.frame.height)/1.3)
        }
        sceneView.addSubview(button)
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
            strongSelf.lblTimer.text = "\(strongSelf.tempo)"
            
            //strongSelf.timer.invalidate() isso para o timer
            if strongSelf.tempo == 0 || strongSelf.random.arrayMascaras.count == 6 {
                strongSelf.face.removeFromParentNode()
                strongSelf.card.removeFromSuperview()
                strongSelf.timer.invalidate()
                strongSelf.lblTimer.text = ""
                strongSelf.lblTimer.removeFromSuperview()
                strongSelf.passButton.removeFromSuperview()
                strongSelf.checkButton.removeFromSuperview()
                strongSelf.lblPalavra2.removeFromSuperview()
                strongSelf.lblPalavra1.removeFromSuperview()
                strongSelf.createLbl(label: strongSelf.lblPontuacao, width: 250, size: 40, nome: "Pontuação")
                strongSelf.createButton(button: strongSelf.repeatButton, divisor: 500, title: "Jogar de novo", size: 35, width: 250)
                strongSelf.lblNome.text = ""
                strongSelf.tempo = 60
                strongSelf.repeatButton.addTarget(self, action: #selector(strongSelf.handleRepeatButton(_:)), for: .touchDown)
            }
        })
    }
    
    //Quando clica em acerto, faz algo
    @objc func handleCheckButton(_ gestureRecognize: UIGestureRecognizer){
        face.removeFromParentNode()
        if face.name != "" {
            pontuação += 1
            face = random.random3DPicker()
            changeLbl(label: lblPalavra1, nome: "palavra1")
            changeLbl(label: lblPalavra2, nome: "palavra2")
            createLbl(label: lblNome, width: 200, size: 40, nome: "mascara")
            node.addChildNode(face)
        }
    }
    
    // Quando clica em passar, faz algo
    @objc func handlePassButton(_ gestureRecognize: UIGestureRecognizer){
        face.removeFromParentNode()
        if face.name != "" {
            face = random.random3DPicker()
            createLbl(label: lblNome, width: 200, size: 40, nome: "mascara")
            changeLbl(label: lblPalavra1, nome: "palavra1")
            changeLbl(label: lblPalavra2, nome: "palavra2")
            node.addChildNode(face)
        }
    }
    
    @objc func handlePlayButton(_ gestureRecognize: UIGestureRecognizer){
        face.removeParticleSystem(explosion!)
        face.removeFromParentNode()
        face = random.random3DPicker()
        createLbl(label: lblNome, width: 200, size: 40, nome: "mascara")
        node.addChildNode(face)
        createButton(button: passButton, divisor: 500, title: "Errou", size: 35, width: 160)
        createButton(button: checkButton, divisor: 1.6, title: "Acertou", size: 35, width: 160)
        createCard()
        sceneView.scene.rootNode.removeAllAudioPlayers()
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
        createLbl(label: lblNome, width: 200, size: 40, nome: "mascara")
        node.addChildNode(face)
        createButton(button: passButton, divisor: 500, title: "Errou", size: 35, width: 160)
        createButton(button: checkButton, divisor: 1.6, title: "Acertou", size: 35, width: 160)
        createCard()
    }
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        guard let faceAnchor = anchor as? ARFaceAnchor else { return nil }
        currentFaceAnchor = faceAnchor
        face = random.faceDorime
        node.addChildNode(face)
        face.addParticleSystem(explosion!)
        return node
    }
        
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        
        guard let faceAnchor = anchor as? ARFaceAnchor
        else { return }
        
        if tempo == 0 || random.arrayMascaras.count == 6 {
            face.removeFromParentNode()
            
        }
    }
}
