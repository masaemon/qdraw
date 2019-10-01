//
//  ViewController.swift
//  qdraw
//
//  Created by masaemon on 9/28/19.
//  Copyright © 2019 masaemon. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {

    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var canvasView: CanvasView!
    override func viewDidLoad() {
        super.viewDidLoad()
        canvasView.layer.borderColor = UIColor.blue.cgColor
        canvasView.layer.borderWidth = 5
        canvasView.initCreateCanvas()
        // Do any additional setup after loading the view.
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        canvasView.touchesMoved(touches, with: event)
    }
    
    @IBAction func clearDraw(_ sender: Any) {
        self.canvasView.clearCanvas(animated: false)
        self.textLabel.text = ""
    }
    
    @IBAction func submitDrawing(_ sender: Any) {
        textLabel.text = "はんていちゅう"
        
        //判定する用のURL
        let urlString = ""
        let image: UIImage? = canvasView.image
        let pngImage: UIImage = UIImage(data: image!.pngData()!)!
        let resizeImage: UIImage = pngImage.resize(width: 28, height: 28)!
        let imageString = encodeImageToBase(image: pngImage)
        let parameters = ["img": imageString]
        UIImageWriteToSavedPhotosAlbum(resizeImage, nil, nil, nil)
        Alamofire.request(urlString, method: .post, parameters: parameters).responseJSON { response in
            switch response.result {
            case .success(let JSON):
                let response = JSON as! NSDictionary
                let answer = response.object(forKey: "answer")
                self.textLabel.text = answer as! String
            case .failure(_):
                self.textLabel.text = "もう一回おくってください"
            }
        }
    }

    private func encodeImageToBase(image: UIImage) -> String {
        let imageData : Data = image.pngData()! as Data
        let strBase64 = imageData.base64EncodedString()
        return strBase64
    }
}

extension UIImage {
    func tint(color: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        let drawRect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIRectFill(drawRect)
        draw(in: drawRect, blendMode: .destinationIn, alpha: 1)
        let tintedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return tintedImage!
    }
    
    func resize(width: Int, height: Int) -> UIImage? {
        let resizedSize = CGSize(width: width, height: height)
        UIGraphicsBeginImageContextWithOptions(resizedSize, false, 0.0) // 変更
        draw(in: CGRect(origin: .zero, size: resizedSize))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return resizedImage
    }
}
