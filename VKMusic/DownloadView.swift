//
//  DownloadView.swift
//  Libraries
//
//  Created by  Dennya on 09.07.16.
//  Copyright © 2016  Dennya. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class DownloadView: UIView {
    
    @IBInspectable
    var loadingColor: UIColor = UIColor.redColor() { didSet { setNeedsDisplay() }}
    @IBInspectable
    var doneColor: UIColor = UIColor.greenColor() { didSet { setNeedsDisplay() }}
    @IBInspectable
    var ringColor: UIColor = UIColor.blackColor() { didSet { setNeedsDisplay() }}
    @IBInspectable
    var lineWidth: CGFloat = 2 { didSet { setNeedsDisplay() }}
    @IBInspectable
    var progress: Double = 0.0 { didSet { setNeedsDisplay()
        if progress == 1 { downloading = false }}}
    @IBInspectable
    var downloading: Bool = false { didSet { setNeedsDisplay() }}
    @IBInspectable
    var notLoadingColor: UIColor = UIColor.grayColor() { didSet { setNeedsDisplay() }}
    
    func pathForCircleForProgress(progress: Double) -> UIBezierPath {
        let x = bounds.size.width * CGFloat((1 - progress)) / 2
        let y = bounds.size.height * CGFloat((1 - progress)) / 2
        let width = bounds.size.width * CGFloat(progress)
        let height = bounds.size.height * CGFloat(progress)
        let path = UIBezierPath(ovalInRect: CGRect(x: x, y: y, width: width, height: height))
        return path
    }
    
    func pathForRing() -> UIBezierPath {
        let path = UIBezierPath(ovalInRect: CGRect(x: 0, y: 0, width: bounds.size.width, height: bounds.size.height))
        path.lineWidth = lineWidth
        return path
    }
    
    
    override func drawRect(rect: CGRect) {
        if progress >= 1 {
            doneColor.setFill()
            pathForCircleForProgress(1).fill()
        } else {
            if downloading {
                loadingColor.setFill()
            } else {
                notLoadingColor.setFill()
            }
            pathForCircleForProgress(max(0, progress)).fill()
            ringColor.setStroke()
            pathForRing().stroke()
        }
    }
}
