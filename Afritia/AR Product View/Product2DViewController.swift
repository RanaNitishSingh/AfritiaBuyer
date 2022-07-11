//
//  Product2DViewController.swift
//  Getkart
//
//  Created by bhavuk.chawla on 09/10/18.
//  Copyright © 2018 kunal. All rights reserved.
//

import UIKit
import AVFoundation

class Product2DViewController: UIViewController {

//    @IBOutlet weak var captureButton: UIButton!
//    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var scroll: UIScrollView!
    @IBOutlet weak var imgOverlay: UIImageView!
    
    let captureSession = AVCaptureSession()
    let stillImageOutput = AVCaptureStillImageOutput()
    var previewLayer : AVCaptureVideoPreviewLayer?
    var img: UIImage?
    
    // If we find a device we'll store it here for later use
    var captureDevice : AVCaptureDevice?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scroll.maximumZoomScale = 5.0
        scroll.minimumZoomScale = 1.0
        scroll.clipsToBounds = false
        scroll.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        captureSession.sessionPreset = AVCaptureSession.Preset.high
        
        if let devices = AVCaptureDevice.devices() as? [AVCaptureDevice] {
            // Loop through all the capture devices on this phone
            for device in devices {
                // Make sure this particular device supports video
                if (device.hasMediaType(AVMediaType.video)) {
                    // Finally check the position and confirm we've got the back camera
                    if(device.position == AVCaptureDevice.Position.back) {
                        captureDevice = device
                        if captureDevice != nil {
                            print("Capture device found")
                            beginSession()
                        }
                    }
                }
            }
        }
    }
    
    func beginSession() {
        
        do {
            try captureSession.addInput(AVCaptureDeviceInput(device: captureDevice!))
            stillImageOutput.outputSettings = [AVVideoCodecKey:AVVideoCodecJPEG]
            
            if captureSession.canAddOutput(stillImageOutput) {
                captureSession.addOutput(stillImageOutput)
            }
            
        }
        catch {
            print("error: \(error.localizedDescription)")
        }
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        // this is what displays the camera view. But - it's on TOP of the drawn view, and under the overview. ??
        self.view.layer.addSublayer(previewLayer)
        previewLayer.frame = self.view.layer.frame
        
        
        imgOverlay.frame = self.view.frame
        imgOverlay.image = img
        self.view.bringSubview(toFront: scroll)
        self.view.bringSubview(toFront: imgOverlay)
//          self.view.bringSubview(toFront: bottomView)
//        self.view.bringSubview(toFront: captureButton)
        self.imgOverlay.isUserInteractionEnabled = true
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.gestureRecognizerMethod(_:)))
        self.imgOverlay.addGestureRecognizer(panGestureRecognizer)
        
        let pinch = UITapGestureRecognizer(target: self, action: #selector(self.gestureRecognizerMethod1(_:)))
        self.imgOverlay.addGestureRecognizer(pinch)
        captureSession.startRunning()
        print("Capture session running")
    }
    
    @objc func gestureRecognizerMethod1(_ sender: UITapGestureRecognizer) {
        if scroll.zoomScale == 1.0 {
            scroll.zoom(to: zoomRectForScale(scale: scroll.maximumZoomScale, center: sender.location(in: sender.view)), animated: true)
        } else {
            scroll.setZoomScale(1, animated: true)
        }
    }
    
    @objc func gestureRecognizerMethod(_ recognizer: UIPanGestureRecognizer?) {
        if recognizer?.state == .began || recognizer?.state == .changed {
            let touchLocation: CGPoint = (recognizer?.location(in: view))!
            imgOverlay?.center = touchLocation
        }
    }

    @IBAction func captureClicked(_ sender: Any) {
        if let videoConnection = stillImageOutput.connection(with: AVMediaType.video) {
            stillImageOutput.captureStillImageAsynchronously(from: videoConnection) {
                (imageDataSampleBuffer, error) -> Void in
                if let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(imageDataSampleBuffer!) {
                    UIImageWriteToSavedPhotosAlbum(UIImage(data: imageData)!, nil, nil, nil)
                    self.saveImage(data: imageData)
                }
            }
        }
    }
    
   
    func saveImage(data: Data) {
        let bottomImage = UIImage(data: data)
        let topImage = imgOverlay.image
        
        let newSize = CGSize(width: 100  , height: 100)// set this to what you need
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        
        bottomImage?.draw(in: CGRect(origin: CGPoint.zero, size: CGSize(width: UIScreen.main.bounds.width  , height:  UIScreen.main.bounds.height)))
        topImage?.draw(in: CGRect(origin: CGPoint.zero, size: newSize))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
       
        UIImageWriteToSavedPhotosAlbum(newImage!, nil, nil, nil)
        
         UIGraphicsEndImageContext()
//        self.imgOverlay.image = newImage
    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension Product2DViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imgOverlay
    }
    
    func zoomRectForScale(scale: CGFloat, center: CGPoint) -> CGRect {
        var zoomRect = CGRect.zero
        zoomRect.size.height = imgOverlay.frame.size.height / scale
        zoomRect.size.width  = imgOverlay.frame.size.width  / scale
        let newCenter = scroll.convert(center, from: imgOverlay)
        zoomRect.origin.x = newCenter.x - (zoomRect.size.width / 2.0)
        zoomRect.origin.y = newCenter.y - (zoomRect.size.height / 2.0)
        return zoomRect
    }
}
