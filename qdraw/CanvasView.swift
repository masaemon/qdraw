//
//  CanvasView.swift
//  qdraw
//
//  Created by masaemon on 9/28/19.
//  Copyright © 2019 masaemon. All rights reserved.
//

import UIKit

class CanvasView: UIImageView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    private let baseSize: CGFloat = 12.0
    private var color: UIColor = UIColor.black

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            if touch.type == .pencil {
                drawLine(touch: touch)
            }
        }
    }

    private func drawLine(touch: UITouch) {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0.0)
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        
        image?.draw(in: bounds)
        updateContext(context: context, touch: touch)

        image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }

    private func updateContext(context: CGContext, touch: UITouch) {
        let previousLocation = touch.previousLocation(in: self)
        let location = touch.location(in: self)
        let width = getLineWidth(touch: touch)
        
        color.setStroke()
        context.setLineWidth(width)
        context.setLineCap(.round)
        context.setLineJoin(.round)
        context.move(to: previousLocation)
        context.addLine(to: location)
        context.strokePath()
    }

    private func getLineWidth(touch: UITouch) -> CGFloat {
        return baseSize
    }
    
    func initCreateCanvas() {
        var initImg: UIImage! = nil
        let imageSize = CGSize(width: 500, height: 500)
        let imageRect = CGRect(x: 0, y:0, width: 500, height: 500)
        UIGraphicsBeginImageContextWithOptions(imageSize, false, 0.0)
        UIColor.white.setFill()
        UIRectFill(imageRect)
        self.image?.draw(in: imageRect)
        initImg = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.image = initImg
        self.image?.draw(in: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height))
    }

    func clearCanvas(animated: Bool) {
        if animated {
            UIView.animate(withDuration: 0.5, animations: {
                self.alpha = 0
            }, completion: { finished in
                self.alpha = 1
                self.image = nil
                self.initCreateCanvas()
            })
        } else {
            self.image = nil
            self.initCreateCanvas()
        }
    }
}
