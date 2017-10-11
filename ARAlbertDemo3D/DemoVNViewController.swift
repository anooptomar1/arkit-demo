//
//  DemoVNViewController.swift
//  ARAlbertDemo3D
//
//  Created by Glenna L Buford on 9/26/17.
//  Copyright © 2017 Glenna L Buford. All rights reserved.
//

import UIKit
import Vision

class DemoVNViewController: UIViewController {
    
    @IBOutlet weak var glennaImageView: UIImageView!
    @IBOutlet weak var bezierPathView: UIView!
    
    let faceDetection = VNDetectFaceRectanglesRequest()
    let faceDetectionRequest = VNSequenceRequestHandler()
    
    let faceLandmarksDetectionRequest = VNSequenceRequestHandler()
    
    private var lastObservation: VNDetectedObjectObservation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //because vision framework operates in the opposite coordinate system
        bezierPathView.layer.sublayerTransform = CATransform3DMakeScale(1.0, -1.0, 1.0);
    }
    
    override func viewDidAppear(_ animated: Bool) {
        guard let image = glennaImageView.image else {
            fatalError("wtf")
        }
        
        let faceLandmarksRequest = VNDetectFaceLandmarksRequest { (request, error) in
            if let results = request.results as? [VNFaceObservation] {
                print(results)
                for faceObservation in results {
                    
                    guard let faceLandmarks = faceObservation.landmarks else {
                        continue
                    }
                    
                    if let nose = faceLandmarks.nose {
                        let nosePoints = nose.pointsInImage(imageSize: self.glennaImageView.bounds.size)
                        
                        self.drawPointsOnImage(nosePoints)
                    }
                    
                    if let rightEye = faceLandmarks.rightEye {
                        let rightEyePoints = rightEye.pointsInImage(imageSize: self.glennaImageView.bounds.size)
                        
                        self.drawPointsOnImage(rightEyePoints)
                    }
                    
                    if let leftEye = faceLandmarks.leftEye {
                        let leftEyePoints = leftEye.pointsInImage(imageSize: self.glennaImageView.bounds.size)
                        
                        self.drawPointsOnImage(leftEyePoints)
                    }
                    
                    if let rightEyebrow = faceLandmarks.rightEyebrow {
                        let rightEyebrowPoints = rightEyebrow.pointsInImage(imageSize: self.glennaImageView.bounds.size)
                        
                        self.drawPointsOnImage(rightEyebrowPoints)
                    }
                    
                    if let leftEyebrow = faceLandmarks.leftEyebrow {
                        let leftEyebrowPoints = leftEyebrow.pointsInImage(imageSize: self.glennaImageView.bounds.size)
                        
                        self.drawPointsOnImage(leftEyebrowPoints)
                    }
                    
                    if let outerLips = faceLandmarks.outerLips {
                        let outerLipsPoints = outerLips.pointsInImage(imageSize: self.glennaImageView.bounds.size)
                        
                        self.drawPointsOnImage(outerLipsPoints)
                    }
                }
            }
        }
        
        // vision
        let requestHandler = VNImageRequestHandler(cgImage: image.cgImage!, options: [:])
        
        try? requestHandler.perform([faceLandmarksRequest])
    }
    
    func drawPointsOnImage(_ points: [CGPoint]) {
        
        let bezierPath = UIBezierPath.pathWithPoints(points)
        
        let bezierPathLayer = CAShapeLayer()
        bezierPathLayer.strokeColor = UIColor.red.cgColor
        bezierPathLayer.fillColor = UIColor.red.cgColor
        bezierPathLayer.lineWidth = 5.0
        
        bezierPathLayer.path = bezierPath.cgPath
        
        self.bezierPathView.layer.addSublayer(bezierPathLayer)
    }
}

extension UIBezierPath {
    class func pathWithPoints(_ points: [CGPoint]) -> UIBezierPath {
        let path = UIBezierPath()
        path.lineWidth = 2.0
        
        path.move(to: points[0])
        let otherPoints = points.suffix(points.count - 1)
        
        for point in otherPoints {
            path.addLine(to: point)
        }
        
        path.close()
        
        return path
    }
}