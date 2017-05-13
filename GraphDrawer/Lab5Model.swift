//
//  Lab5Model.swift
//  GraphDrawer
//
//  Created by Lildan on 4/23/17.
//  Copyright © 2017 Lildan. All rights reserved.
//

import Foundation

class Lab5Model {
    
    var functionTabulation :[(arg:Double, value:Double)] =
        [ (0.0, 0.0),
          (0.1, 0.09983),
          (0.2, 0.19866),
          //(0.3, 0.29552),
          (0.4, 0.38941),
          (0.5, 0.47942),
          (0.6, 0.56464),
          (0.7, 0.64421),
          //(0.8, 0.71735),
          (0.9, 0.78332)
        ]
    var interpolationPoints: [Double] = [0.445, 0.778, 0.801 ]
    
    
   lazy var dividedDifferences : [[Double]]!  = self.calculateDD()
    
    
    // Returns a function - interpolation polynom calculated by Gorner`s schema
    var function :(Double) -> Double {
        get {
            
            return  { (_ X: Double) -> Double  in
                var res : Double
                var i = self.dividedDifferences.count-1
                
                res = self.dividedDifferences[i][0]
                i -= 1
                while i >= 0 {
                    res = self.dividedDifferences[i][0] + (X - self.functionTabulation[i].arg) * res
                    i -= 1
                }
                return res
            }
        }
    }
    
    // Returns a string representing interpolation polynom in Gorner`s view
    var functionLiteral: String {
        get {
            var i = functionTabulation.count-1
            var dd = String(dividedDifferences[i][0])
            var x_i : String
            var s : String = dd
            i -= 1
            while i>=0 {
                dd = String(dividedDifferences[i][0])
                x_i = String(functionTabulation[i].arg)
                
                s = dd + "x-" + x_i + ")" + s
                i -= 1
            }
            s = "L(x)=" + s
            return s
        }
    }
    
    // Calculates divided differences
     func calculateDD () -> [[Double]] {
        // 0 divided difference
        var dd = [[Double]]()
        var i = 0
        while i < functionTabulation.count {
            dd.append([Double]())
            dd[0].append(functionTabulation[i].value)
            i += 1
        }
        
        // calculating rest of divided differences
        i = 0
        repeat {
            for j in 0..<dd[i].count-1 {
                dd[i+1]
                    .append((dd[i][j+1]-dd[i][j])/(functionTabulation[j+1+i].arg - functionTabulation[j].arg))
            }
            i += 1
        } while dd[i].count > 1
        
        return dd
    }
}
