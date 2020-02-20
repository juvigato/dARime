//
//  Random3DNodes.swift
//  Who ARe you?
//
//  Created by Guilherme Enes on 17/02/20.
//  Copyright © 2020 Guilherme Enes. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class Random3DNodes: SCNReferenceNode {
    lazy var faceCat = SCNReferenceNode(named: "cat")
//    lazy var face = SCNReferenceNode(named: "cabeca")
    lazy var vazio = SCNReferenceNode(named: "vazio")
    lazy var faceDuck = SCNReferenceNode(named: "duck")
    lazy var faceRat = SCNReferenceNode(named: "rat")
    
    lazy var arrayMascaras: [String] = []
    
    func random3DPicker() -> SCNReferenceNode {
        
        faceCat.name = "Gato"
//        face.name = "face"
        vazio.name = ""
        faceDuck.name = "Pato"
        faceRat.name = "Rato"
        
        let random3D: [SCNReferenceNode] = [faceCat, faceRat, faceDuck]
        var random = Int.random(in: 0..<random3D.count)
        
        while arrayMascaras.contains(random3D[random].name ?? "") {
            random = Int.random(in: 0..<random3D.count)
            if arrayMascaras.count == 3 {
                arrayMascaras.append(vazio.name!)
                return vazio
            }
        }

        arrayMascaras.append(random3D[random].name!)
        
        return random3D[random]
    }
}
