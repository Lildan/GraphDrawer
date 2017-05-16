//
//  InterpolationModel.swift
//  GraphDrawer
//
//  Created by Lildan on 4/23/17.
//  Copyright © 2017 Lildan. All rights reserved.
//

import Foundation

class InterpolationModel {
    
    let args = [ 0.445 , 0.778, 0.801]
    
    var N : Int = 5
    var a : Double = 0
    var b : Double = 2
    
    var analyticFunction : (Double) -> Double = {
        return 2*log($0 + 2)
    }
    
    var functionTabulation :[(arg:Double, value:Double)] {
        get {
            var fT = [(arg:Double, value:Double)]()
            let h : Double = (b-a)/Double(N-1)
            var x = a
            
            for _ in 1...N {
                fT.append((arg: x, value: analyticFunction(x)))
                x += h
            }
            
            return fT
            
        }
    }
    
    var interpolationPoints: [Double] = [0.445, 0.778, 0.801 ]
    
    
   lazy var dividedDifferences : [[Double]]!  = self.calculateDD()
    
    
    // Returns a function - interpolation polynom calculated by Gorner`s schema
    var interpolationPolynomFunction : (Double) -> Double {
        get {
            
            return  { (_ X: Double) -> Double  in
                var res : Double
                var i = self.dividedDifferences.count-1
                
                res = self.dividedDifferences[i][0]
                i -= 1
                let fT = self.functionTabulation
                while i >= 0 {
                    res = self.dividedDifferences[i][0] + (X - fT[i].arg) * res
                    i -= 1
                }
                return res
            }
        }
    }
    
    // Returns a string representing interpolation polynom in Gorner`s view
    var functionLiteral: String {
        get {
            let fT = functionTabulation
            var i = fT.count-1
            var dd = String(roundDouble(dividedDifferences[i][0], toPrecision: 2))
            var x_i : String
            var s : String = dd
            i -= 1
            while i>=0 {
                dd = String(roundDouble(dividedDifferences[i][0], toPrecision: 2))
                x_i = String(fT[i].arg)
                
                s = "(" + s + ")"
                s = dd + "+(x-" + x_i + ")*" + s
                i -= 1
            }
            s = "L(x)=" + s
            return s
        }
    }
    
    var linearApproximationCoefA : Double {
        get {
            let fT = functionTabulation
            let N = Double(fT.count)
            var sumX = 0.0
            var sumY = 0.0
            var sumXY = 0.0
            var sumSquareX = 0.0
            
            for item in fT {
                sumX += item.arg
                sumY += item.value
                sumXY += item.arg*item.value
                sumSquareX += item.arg*item.arg
            }
            
            let result : Double = ( N*sumXY - sumX*sumY ) / ( N*sumSquareX - sumX*sumX )
            
            return result
        }
    }
    
    var linearApproximationCoefB : Double {
        get {
            let fT = functionTabulation
            let N = Double(fT.count)
        
            var sumX = 0.0
            var sumY = 0.0
        
            for item in fT {
                sumX += item.arg
                sumY += item.value
            }
        
            let result = ( sumY - linearApproximationCoefA*sumX ) / N
            return result
        }
    }
    
    var linearApproximationFunction : (Double) -> Double {
        get {
            return {
                let result = self.linearApproximationCoefA*$0 + self.linearApproximationCoefB
                return result
            }
        }
    }
    
    var linearApproximationFunctionLiteral : String {
        get {
            let result = "A(x) = " + String(roundDouble(linearApproximationCoefA, toPrecision: 4)) + "x + " + String(roundDouble(linearApproximationCoefB, toPrecision: 4))
            return result
        }
    }
    
    func calculateDeviations ()-> Double {
        var result = 0.0
        let fT = functionTabulation
        
        for item in fT {
            result += pow(item.value - linearApproximationFunction(item.arg), 2)
        }
        return result
    }
    
    // Calculates divided differences
     func calculateDD () -> [[Double]] {
        var fT = functionTabulation
        // 0 divided difference
        var dd = [[Double]]()
        var i = 0
        while i < fT.count {
            dd.append([Double]())
            dd[0].append(fT[i].value)
            i += 1
        }
        
        // calculating rest of divided differences
        i = 0
        repeat {
            for j in 0..<dd[i].count-1 {
                dd[i+1]
                    .append((dd[i][j+1]-dd[i][j])/(fT[j+1+i].arg - fT[j].arg))
            }
            i += 1
        } while dd[i].count > 1
        
        return dd
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
