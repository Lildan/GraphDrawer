//
//  GraphView.swift
//  GraphDrawer
//
//  Created by Lildan on 4/17/17.
//  Copyright © 2017 Lildan. All rights reserved.
//

import UIKit

@IBDesignable
class GraphView : UIView {
    var firstFunc : ((Double)->Double)? = {-$0} {
        didSet {
            setNeedsDisplay()
        }
    }

    var secondFunc : ((Double)->Double)? = {-$0} {
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
    var colorAxes: UIColor = UIColor.black { didSet { setNeedsDisplay() } }
    
    var originSet: CGPoint? { didSet {setNeedsDisplay() } }
    
    private var origin: CGPoint {
        get {
            return originSet ?? CGPoint(x: self.bounds.midX, y: self.bounds.midY)
        }
        set {
            originSet = newValue
        }
    }
    
    func originMove(_ gesture: UIPanGestureRecognizer){
        switch gesture.state {
        case .ended: fallthrough
        case .changed:
            let translation = gesture.translation(in: self)
            if translation != CGPoint.zero {
                origin.x += translation.x
                origin.y += translation.y
                gesture.setTranslation(CGPoint.zero, in:self)
            }
        default: break
        }
    }
    
    func scale (_ gesture: UIPinchGestureRecognizer){
        if gesture.state == .changed {
            scale *= gesture.scale
            gesture.scale = 1
        }
    }
    
    func origin (_ gesture: UITapGestureRecognizer){
        if gesture.state == .ended {
            origin = gesture.location(in: self)
        }
    }

    
    private var axesDrawer = AxesDrawer()
    
    override func draw(_ rect: CGRect) {
        axesDrawer.contentScaleFactor = contentScaleFactor
        axesDrawer.color = colorAxes
        axesDrawer.drawAxes(in: bounds, origin: origin, pointsPerUnit: scale)
        drawCurveInRect(bounds, origin: origin, scale: scale, function: firstFunc, color: UIColor.orange)
        drawCurveInRect(bounds, origin: origin, scale: scale, function: secondFunc, color: UIColor.blue)
        
        /*
        let label = UILabel()
        label.text = "L(x)"
        label.textColor = UIColor.orange
        label.textAlignment = NSTextAlignment.center
        //label.backgroundColor = UIColor.clear
        label.frame = CGRect(x: 20, y: 20, width: 20, height: 20)
        label.layer.zPosition = 10
        self.addSubview(label)
        
        let label2 = UILabel()
        label2.text = "L(x)"
        label2.textColor = UIColor.blue
        label2.textAlignment = NSTextAlignment.center
        //label2.backgroundColor = UIColor.clear
        label2.frame = CGRect(x: 20, y: 40, width: 20, height: 20)
        self.addSubview(label2)
        */
    }
    
    func drawCurveInRect(_ bounds: CGRect, origin : CGPoint, scale: CGFloat, function : ((Double)->Double)?, color: UIColor ){
        
        var xGraph, yGraph : CGFloat
        var x, y : Double
        var isFirstPoint = true
        
        //
        var oldYGraph: CGFloat = 0.0
        var disContinuity: Bool {
            return abs(yGraph - oldYGraph) > max(bounds.width, bounds.height)*1.5
        }
        //
        
        if function != nil {
            color.set()
            let path = UIBezierPath()
            path.lineWidth = lineWidth
            
            for i in 0...Int(bounds.size.width * contentScaleFactor){
                xGraph = CGFloat(i) / contentScaleFactor
                
                x = Double((xGraph - origin.x)/scale)
                y = (function)!(x)
                
                guard y.isFinite else { continue }
                yGraph = origin.y - CGFloat(y)*scale
                
                if isFirstPoint {
                    path.move(to: CGPoint(x: xGraph, y: yGraph))
                    isFirstPoint = false
                } else {
                    if disContinuity {
                        isFirstPoint = true
                    } else {
                        path.addLine(to: CGPoint(x: xGraph, y: yGraph))
                    }
                }
            }
            path.stroke()
        }
    }
}
