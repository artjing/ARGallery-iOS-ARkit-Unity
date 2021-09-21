//
//  ViewController.swift
//  ARGallery
//
//  Created by 董静 on 6/17/21.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet weak var sceneView: ARSCNView!
    
    public var currentNumber : Int?
    
    // Define all SCNNode
    var currentNode : SCNNode?
    var node1 : SCNNode?
    var node2 : SCNNode?
    var node3 : SCNNode?
    var node4 : SCNNode?
    var node5 : SCNNode?
    var node6 : SCNNode?

    var imageNodes = [SCNNode]()
    
    // for image recognition
    enum CardType: String {
        case leftImage   = "leftImage"
        case rightImage  = "rightImage"
    }
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        sceneView.addGestureRecognizer(UIPinchGestureRecognizer(target: self, action: #selector(pinched(_:))))
        
        // Create all new scene, change the .usdz in your Assets folder
        let scene = SCNScene(named: "art.scnassets/5.usdz")!
        node4 = scene.rootNode
        let scene1 = SCNScene(named: "art.scnassets/1.usdz")
        node1 = scene1!.rootNode
        let scene2 = SCNScene(named: "art.scnassets/2.usdz")
        node2 = scene2!.rootNode
        let scene3 = SCNScene(named: "art.scnassets/3.usdz")
        node3 = scene3!.rootNode
        let scene4 = SCNScene(named: "art.scnassets/5.usdz")
        node4 = scene4!.rootNode
        let scene5 = SCNScene(named: "art.scnassets/5.usdz")
        node5 = scene5!.rootNode
        let scene6 = SCNScene(named: "art.scnassets/6.usdz")
        node6 = scene6!.rootNode

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARImageTrackingConfiguration()
        guard let arImage = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil) else{ return}
        configuration.trackingImages = arImage
        configuration.maximumNumberOfTrackedImages = 2
        sceneView.session.run(configuration)
        sceneView.autoenablesDefaultLighting = true
        
        switch currentNumber {
        case 1:
            currentNode = node1
        case 2:
            currentNode = node2
        case 3:
            currentNode = node3
        case 4:
            currentNode = node4
        case 5:
            currentNode = node5
        case 6:
            currentNode = node6
        default:
            break
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    // MARK: - ARKit functions
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        
        let node = SCNNode()
        var myNode : SCNNode?
        //myNode = node4
        
        // ImageAnchor
        if let imageAnchor = anchor as? ARImageAnchor {
            let size = imageAnchor.referenceImage.physicalSize
            let plane = SCNPlane(width: size.width, height: size.height)
            plane.firstMaterial?.diffuse.contents = UIColor.white.withAlphaComponent(0.8)
            plane.cornerRadius = 0.005
            let planeNode = SCNNode(geometry: plane)
            //planeNode.eulerAngles.x = -.pi / 2
            node.addChildNode(planeNode)
            
            // process the image recognition, define the name in the Assets ARResource folder
            switch imageAnchor.referenceImage.name {
            case CardType.leftImage.rawValue:
                myNode = node5
            case CardType.rightImage.rawValue:
                myNode = node5
            default:
                break
            }
            
            // animation
            let shapeSpin = SCNAction.rotateBy(x: 0, y: 1.5 * .pi, z: 0, duration: 10)
            let repeatSpin = SCNAction.repeatForever(shapeSpin)
            myNode?.runAction(repeatSpin)
            
            // add to the node
            guard let shape = myNode else {
                return nil
            }
            node.addChildNode(shape)
            imageNodes.append(node)

        }
        return node
    }
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        if (imageNodes.count == 2) {
            let positionOne = SCNVector3ToGLKVector3(imageNodes[0].position)
            let positionTwo = SCNVector3ToGLKVector3(imageNodes[1].position)
            let distance    = GLKVector3Distance(positionOne, positionTwo)
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
        currentNode = node
        /* traditial way of loading model
         guard let container = sceneView.scene.rootNode.childNode(withName: "ship", recursively: false) else{return}
         container.removeFromParentNode()
         node.addChildNode(container)
         container.isHidden = false
         */
        addModel()
        
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
    
    // MARK: - Private functions
    @objc func pinched(_ recognizer: UIPinchGestureRecognizer)
    {
        if recognizer.state == .changed {
            guard let sceneView = recognizer.view as? ARSCNView else{
                return
            }
            
            let touch = recognizer.location(in: sceneView)
            let hitTestResults = sceneView.hitTest(touch, options: nil)
            if let hitTest = hitTestResults.first {
                
                let rockNode = hitTest.node
                let xx = Float(recognizer.scale) * rockNode.scale.x
                let yy = Float(recognizer.scale) * rockNode.scale.y
                let zz = Float(recognizer.scale) * rockNode.scale.z

                rockNode.scale = SCNVector3(xx,
                                            yy,
                                            zz)
                
                self.sceneView.scene.rootNode.addChildNode(rockNode)
                
                recognizer.scale = 1
            }
        }
    }

    private func spinJump(node: SCNNode) {
        
        let shapeNode = node.childNodes[1]
        let shapeSpin = SCNAction.rotateBy(x: 0, y: 2 * .pi, z: 0, duration: 1)
        shapeSpin.timingMode = .easeInEaseOut
        
        let up = SCNAction.moveBy(x: 0, y: 0.03, z: 0, duration: 0.5)
        up.timingMode = .easeInEaseOut
        let down = up.reversed()
        let upDown = SCNAction.sequence([up, down])
        
        shapeNode.runAction(shapeSpin)
        shapeNode.runAction(upDown)
    }
    
    @IBAction func clearModels(_ sender: Any) {
        for node in self.sceneView!.scene.rootNode.childNodes {
            node.removeFromParentNode()
        }
    }
    
    // Define some fancy graphic in here
    @IBAction func addBezel(_ sender: Any) {
        
        //let path = UIBezierPath()
        //path.move(to: CGPoint(x: 0, y: 0))
        //path.addLine(to: CGPoint(x: 0, y: 0.2))
        //path.addLine(to: CGPoint(x: 0.2, y: 0.3))
        //path.addLine(to: CGPoint(x: 0.4, y: 0.2))
        //path.addLine(to: CGPoint(x: 0.4, y: 0.0))
        //let shape = SCNShape(path: path, extrusionDepth: 0.2)
        //node.geometry = shape
        
        let node = SCNNode()
        node.geometry?.firstMaterial?.specular.contents = UIColor.white
        node.geometry?.firstMaterial?.diffuse.contents = UIColor.white
        node.geometry?.firstMaterial?.transparency = 0.5
        node.position = SCNVector3(x: 0, y: 0, z: -0.7)
        self.sceneView.scene.rootNode.addChildNode(node)
        
        for _ in 0..<20 {
            let boxNode = SCNNode(geometry: SCNBox(width: CGFloat(Float.random(in: 0..<0.1)),
                                                   height: CGFloat(Float.random(in: 0..<0.2)),
                                                   length: CGFloat(Float.random(in: 0..<0.1)), chamferRadius: 0))
            
            boxNode.geometry?.firstMaterial?.diffuse.contents = Int.random(in: 0..<6)<5 ? UIColor.black : UIColor.white
            boxNode.geometry?.firstMaterial?.transparency = 0.7
            boxNode.position = SCNVector3(CGFloat(Float.random(in: -0.2..<0.2)),
                                          CGFloat(Float.random(in: -0.6..<0.6)),
                                          CGFloat(Float.random(in: -0.2..<0.2)))
            
            node.addChildNode(boxNode)
        }
    }
    
    private func addModel() {
        
        let node = SCNNode()
        node.geometry?.firstMaterial?.specular.contents = UIColor.white
        node.geometry?.firstMaterial?.diffuse.contents = UIColor.white
        node.geometry?.firstMaterial?.transparency = 0.5
        node.position = SCNVector3(x: 0, y: 0, z: -0.7)
        self.sceneView.scene.rootNode.addChildNode(node)
        
        for _ in 0..<20 {
            let boxNode = SCNNode(geometry: SCNBox(width: CGFloat(Float.random(in: 0..<0.01)),
                                                   height: CGFloat(Float.random(in: 0..<0.01)),
                                                   length: CGFloat(Float.random(in: 0..<0.01)),
                                                   chamferRadius: 0))
            
            boxNode.geometry?.firstMaterial?.diffuse.contents = Int.random(in: 0..<2)==0 ? UIColor.black : UIColor.white
            boxNode.geometry?.firstMaterial?.transparency = 0.5
            boxNode.position = SCNVector3(CGFloat(Float.random(in: -0.2..<0.2)),
                                          CGFloat(Float.random(in: -0.2..<0.2)),
                                          CGFloat(Float.random(in: -0.2..<0.2)))
            node.addChildNode(boxNode)
        }
    }
}
