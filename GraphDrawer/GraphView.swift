//
//  GraphView.swift
//  GraphDrawer
//
//  Created by Lildan on 4/17/17.
//  Copyright © 2017 Lildan. All rights reserved.
//

import UIKit

class GraphView : UIView {
    var yForX : ((Double)->Double)? {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable
    var scale: CGFloat = 50.0 {didSet {setNeedsDisplay() } }
    
    @IBInspectable
    var lineWidth: CGFloat = 2.0 { didSet { setNeedsDisplay() } }
    
    @IBInspectable
    var color: UIColor = UIColor.blue { didSet {setNeedsDisplay() } }
    
    @IBInspectable
    var colrAxes: UIColor = UIColor.black { didSet { setNeedsDisplay() } }
    
    var originSet: CGPoint? { didSet {setNeedsDisplay() } }
    
    private var origin: CGPoint {
        get {
            return originSet ?? CGPoint(x: self.bounds.midX, y: self.bounds.midY)
        }
        set {
            originSet = newValue
        }
    }
    
    private var axesDrawer = AxesDrawer()
    
    override func draw(_ rect: CGRect) {
        axesDrawer.contentScaleFactor = contentScaleFactor
        axesDrawer.color = colorAxes
        axesDrawer.drawAxes(inL bouns,origin: originm pointsPerUnit: scale)
    }
}
