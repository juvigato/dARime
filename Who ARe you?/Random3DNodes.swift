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
    lazy var faceCat = SCNReferenceNode(named: "cabeca")
    lazy var faceDog = SCNReferenceNode(named: "cat")
    lazy var arrayMascaras: [String] = []
    
    func random3DPicker() -> SCNReferenceNode {
        
        faceCat.name = "cat"
        faceDog.name = "dog"
        
        let random3D: [SCNReferenceNode] = [faceCat, faceDog]
        var random = Int.random(in: 0..<random3D.count)
        
        if arrayMascaras.contains(random3D[random].name!) {
            print("yes")
        }
        
        arrayMascaras.append(random3D[random].name!)
        
        return random3D[random]
    }
}
