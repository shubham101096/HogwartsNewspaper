//
//  ViewController.swift
//  HogwartsNewspaper
//
//  Created by Shubham Mishra on 24/04/21.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.detectionImages = ARReferenceImage.referenceImages(inGroupNamed: "News Images", bundle: .main)
        configuration.maximumNumberOfTrackedImages = .max

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate

    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
        
        guard let imageAnchor = anchor as? ARImageAnchor else { return nil }
        
        let refImage = imageAnchor.referenceImage
        
        var videoScene = SKScene()
        
        if refImage.name == "harry-potter" {
            print("harry potter image detected")
            let videoNode = SKVideoNode(fileNamed: "harry-potter.mp4")
            videoNode.play()
            videoScene.size = CGSize(width: 480, height: 204)
            videoNode.position = .init(x: videoScene.size.width/2, y: videoScene.size.height/2)
            videoNode.yScale = -1
            videoScene.addChild(videoNode)
        }
        
        let imagePlane = SCNPlane(width: refImage.physicalSize.width, height: refImage.physicalSize.height)
        imagePlane.firstMaterial?.diffuse.contents = videoScene
        
        let imageNode = SCNNode(geometry: imagePlane)
        imageNode.eulerAngles.x = -.pi/2
        node.addChildNode(imageNode)
     
        return node
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
