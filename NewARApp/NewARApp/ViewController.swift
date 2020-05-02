//
//  ViewController.swift
//  NewARApp
//
//  Created by Cory Green on 5/2/20.
//  Copyright © 2020 Cory Green. All rights reserved.
//

import UIKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet weak var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setting up the sceneview //
        sceneView.delegate = self
        sceneView.showsStatistics = true
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // configuration of the sceneview session //
        let config = ARWorldTrackingConfiguration()
        config.isLightEstimationEnabled = true
        config.planeDetection = .horizontal
        
        // running the session //
        sceneView.session.run(config)
        
        
        
    }
    
    
    
    // sensing touches //
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // getting a point in 3d space //
        guard let location = touches.first?.location(in: sceneView) else {
            return
        }
        
        let hitResultsFeaturePoints: [ARHitTestResult] = sceneView.hitTest(location, types: .featurePoint)
        
        if let hit = hitResultsFeaturePoints.first {
            let transformHit = hit.worldTransform

            let pointTranslation = transformHit.translation
            
            // creating a box //
            let box = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0.0)
            let boxNode = SCNNode(geometry: box)
            
            // creating a scene //
            let scene = SCNScene()
            
            // positioning the box //
            boxNode.position = SCNVector3(pointTranslation.x, pointTranslation.y, pointTranslation.z)
            
            // attaching the box to the scene //
            scene.rootNode.addChildNode(boxNode)
            
            
            
            
            
            // adding the scene to the scene view //
            sceneView.scene = scene
        }
        
        
        
        
        
        
        
        
        
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // pausing the session //
        sceneView.session.pause()
    }


}

// creating an extension of float4x4 //
extension float4x4 {
  var translation: float3 {
  let translation = self.columns.3
  return float3(translation.x, translation.y, translation.z)
  }
}

