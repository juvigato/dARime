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
    lazy var faceDog = SCNReferenceNode(named: "robotHead")
    
    
    func random3DPicker() -> SCNReferenceNode {
        let random3D: [SCNReferenceNode] = [faceCat, faceDog]
        let random = Int.random(in: 0..<random3D.count)
        return random3D[random]
        
    }
}
