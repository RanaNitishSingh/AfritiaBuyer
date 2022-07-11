//
//  ProductArViewController.swift
//  Odoo Marketplace
//
//
//

import UIKit
import SceneKit
import ARKit
import SceneKit.ModelIO
import Kingfisher

@available(iOS 11.0, *)
class ProductArViewController: UIViewController {
    
    @IBOutlet weak var containerview: UIView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var sceneView: ARSCNView!
    var str: String!
    var texture = [String]()
    var images = [UIImage]()
    var objNode: SCNNode!
    var originalScale: SCNVector3!
    private var selectedNode: SCNNode?
    fileprivate var guideController: ArContainerViewController?
    var currentAlignment: ARPlaneAnchor.Alignment = .horizontal
    var rotationWhenAlignedHorizontally: Float = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let guideController = childViewControllers.first as? ArContainerViewController else  {
            return
        }
        if UserDefaults.standard.value(forKey: "arLoaded") != nil {
             self.containerview.removeFromSuperview()
            self.loadAr()
        } else {
            self.guideController = guideController
            self.guideController?.delegate = self
        }
        for i in 0..<texture.count {
            if let url = URL(string: texture[i]) {                  
                KingfisherManager.shared.retrieveImage(with: url, options: nil, progressBlock: nil) { result in
                        switch result {
                        case .success(let value):
                            print("Image: \(value.image). Got from: \(value.cacheType)")
                            self.images.append(value.image)
                        case .failure(let error):
                            print("Error: \(error)")                         
                    }
                }
                
                
                
//                KingfisherManager.shared.retrieveImage(with: url, options: nil, progressBlock: nil, completionHandler:  { image, error, cacheType, imageURL in
//                    self.images.append(image!)
//                })
            }
            
        }
        
        addTapGestureToSceneView()
        
        // Do any additional setup after loading the view.
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscapeLeft
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func BarButtonClicked(_ sender: Any) {
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.popViewController(animated: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        UIApplication.shared.isStatusBarHidden = true
        self.tabBarController?.tabBar.isHidden = true
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func loadAr() {
        self.setupCamera()
        sceneView.autoenablesDefaultLighting = true
        sceneView.automaticallyUpdatesLighting = true
        sceneView.delegate = self
        
        //        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        // Create a new scene
        let scene = SCNScene()
        
        // Set the scene to the view
        sceneView.scene = scene
        
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    func setupCamera() {
        guard let camera = sceneView.pointOfView?.camera else {
            fatalError("Expected a valid `pointOfView` from the scene.")
        }
        
        /*
         Enable HDR camera settings for the most realistic appearance
         with environmental lighting and physically based materials.
         */
        camera.wantsHDR = true
        camera.exposureOffset = -1
        camera.minimumExposure = -1
        camera.maximumExposure = 3
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    func addTapGestureToSceneView() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.tapSceneView(withGestureRecognizer:)))
        sceneView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func tapSceneView(withGestureRecognizer recognizer: UIGestureRecognizer) {
        self.sceneView.removeGestureRecognizer(recognizer)
        let tapLocation = recognizer.location(in: sceneView)
        let hitTestResults = sceneView.hitTest(tapLocation, types: .existingPlaneUsingExtent)
        //         sceneView.removeGestureRecognizer(recognizer)
        guard let hitTestResult = hitTestResults.first else { return }
        let translation = hitTestResult.worldTransform.translation
        let x = translation.x
        let y = translation.y
        let z = translation.z
        let position =  SCNVector3(x,y,z)
        self.setAAObject(position: position)
    }
    var check = true
}

@available(iOS 11.0, *)
extension ProductArViewController: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if check {
            check = false
            // 1
            guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
            
            // 2
            let width = CGFloat(planeAnchor.extent.x)
            let height = CGFloat(planeAnchor.extent.z)
            let plane = SCNPlane(width: width, height: height)
            
            let image = UIImage(named: "Ar-Bg-501")
            //            let node = SCNNode(geometry: SCNPlane(width: 1, height: 1))
            // 3
            plane.materials.first?.diffuse.contents = image
            
            // 4
            let planeNode = SCNNode(geometry: plane)
            
            // 5
            let x = CGFloat(planeAnchor.center.x)
            let y = CGFloat(planeAnchor.center.y)
            let z = CGFloat(planeAnchor.center.z)
            planeNode.position = SCNVector3(x,y,z)
            planeNode.eulerAngles.x = -.pi / 2
            print(planeNode)
            // 6
            node.addChildNode(planeNode)
            
            DispatchQueue.main.async {
                self.descriptionLabel.text = "Tap on surface to place object"
            }
        }
        // 7
        //        self.setAAObject()
    }
    
    func setAAObject(position: SCNVector3) {
        descriptionLabel.isHidden = true
        if let url = URL(string: str ) {
            let asset = MDLAsset(url: url)
            let childNode = SCNNode.init(mdlObject: asset.object(at: 0))
            
            print(childNode.scale, asset,SCNScene(mdlAsset: asset).rootNode.childNodes)
            print(childNode.physicsBody)
            let (min, max) = childNode.boundingBox
            let height = max.y - min.y
            print(height)
            var metrialArray = [SCNMaterial]()
            print(images)
            for i in 0..<images.count {
                let material = SCNMaterial()
                material.diffuse.contents = images[i]
                metrialArray.append(material)
            }
            childNode.geometry?.materials = metrialArray
            if !metrialArray.isEmpty {
                childNode.geometry?.materials = metrialArray
            }
            //        childNode.scale  = SCNVector3(0.2, 0.2, 0.2)
            childNode.position = position
            sceneView.scene.rootNode.addChildNode(childNode)
            
            self.objNode = childNode
            
            DispatchQueue.main.async {
                let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(self.handlePinch))
                self.sceneView.addGestureRecognizer(pinchGesture)
            }
            
            DispatchQueue.main.async {
                let swipeLeftGesture = UIPanGestureRecognizer(target: self, action: #selector(self.panGesture))
                self.sceneView.addGestureRecognizer(swipeLeftGesture)
            }
            
            DispatchQueue.main.async {
                let rotationGesture = UIRotationGestureRecognizer(target: self, action: #selector(self.viewRotated))
                self.sceneView.addGestureRecognizer(rotationGesture)
            }
        }
    }
    
    //    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
    //        guard let planeAnchor = anchor as?  ARPlaneAnchor,
    //            let planeNode = node.childNodes.first,
    //            let plane = planeNode.geometry as? SCNPlane
    //            else { return }
    //
    //        // 2
    //        let width = CGFloat(planeAnchor.extent.x)
    //        let height = CGFloat(planeAnchor.extent.z)
    //        plane.width = width
    //        plane.height = height
    //
    //        // 3
    //        let x = CGFloat(planeAnchor.center.x)
    //        let y = CGFloat(planeAnchor.center.y)
    //        let z = CGFloat(planeAnchor.center.z)
    //        planeNode.position = SCNVector3(x, y, z)
    //    }
}

extension UIColor {
    open class var transparentLightBlue: UIColor {
        return UIColor(red: 90/255, green: 200/255, blue: 250/255, alpha: 0.50)
    }
}

// For zooming
extension ProductArViewController {
    
    @objc func handlePinch(_ gesture: UIPinchGestureRecognizer) {
        
        print(gesture.state)
        guard let node = objNode else { return }
        switch gesture.state {
        case .began:
            originalScale = node.scale
            gesture.scale = CGFloat(node.scale.x)
            print("Begin:: \(originalScale)")
        case .changed:
            guard var originalScale = originalScale else { return }
            if gesture.scale > 2.0{
                return
            }
            originalScale.x = Float(gesture.scale)
            originalScale.y = Float(gesture.scale)
            originalScale.z = Float(gesture.scale)
            node.scale = originalScale
        case .ended:
            
            guard var originalScale = originalScale else { return }
            if gesture.scale > 2.0{
                return
            }
            originalScale.x = Float(gesture.scale)
            originalScale.y = Float(gesture.scale)
            originalScale.z = Float(gesture.scale)
            node.scale = originalScale
            gesture.scale = CGFloat(node.scale.x)
            
        default:
            gesture.scale = 1.0
            originalScale = nil
        }
    }
}

// Pan gesture
extension ProductArViewController {
    @objc func panGesture(_ gesture: UIPanGestureRecognizer) {
        let location = gesture.location(in: sceneView)
        
        switch gesture.state {
        case .began:
            // Choose the node to move
            
            selectedNode = objNode
        case .changed:
            // Move the node based on the real world translation
            guard let result = sceneView.hitTest(location, types: .existingPlane).first else { return }
            
            let transform = result.worldTransform
            let newPosition = float3(transform.columns.3.x, transform.columns.3.y, transform.columns.3.z)
            selectedNode?.simdPosition = newPosition
        default:
            // Remove the reference to the node
            selectedNode = nil
        }
    }
}

// View rotation
extension ProductArViewController {
    
    @objc private func viewRotated(_ gesture: UIRotationGestureRecognizer) {
        guard gesture.state == .changed else { return }
        /*
         - Note:
         For looking down on the object (99% of all use cases), we need to subtract the angle.
         To make rotation also work correctly when looking from below the object one would have to
         flip the sign of the angle depending on whether the object is above or below the camera...
         */
        self.objectRotation -= Float(gesture.rotation)
        gesture.rotation = 0
    }
    
    var objectRotation: Float {
        get {
            return objNode.eulerAngles.y
        }
        set (newValue) {
            var normalized = newValue.truncatingRemainder(dividingBy: 2 * .pi)
            normalized = (normalized + 2 * .pi).truncatingRemainder(dividingBy: 2 * .pi)
            if normalized > .pi {
                normalized -= 2 * .pi
            }
            objNode.eulerAngles.y = normalized
            if currentAlignment == .horizontal {
                rotationWhenAlignedHorizontally = normalized
            }
        }
    }
}

extension float4x4 {
    var translation: float3 {
        let translation = self.columns.3
        return float3(translation.x, translation.y, translation.z)
    }
}

protocol close {
    func close()
}

extension ProductArViewController: close {
    func close() {
        self.containerview.removeFromSuperview()
        UserDefaults.standard.set(true, forKey: "arLoaded")
        UserDefaults.standard.synchronize()
        self.loadAr()
    }
}
