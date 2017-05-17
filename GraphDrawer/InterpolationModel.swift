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
    
    
    func updateData (iN: Int, ia: Double, ib: Double) {
        N = iN
        a = ia
        b = ib
        dividedDifferences = calculateDD()
}
    
    var analyticFunction : (Double) -> Double = {
        return 2*log($0 + 2)
    }
    
    var maxOfDerrOnAB : Double = 0
    
    func analyticFunctionDerrivativeWOFactorial () -> ( (Double) -> Double ) {
        return {
            var sign : Int
            if (self.N+1) % 2 == 0 {
                sign = 1
            } else {
                sign = -1
            }
            return  Double( 2*sign ) / pow($0 + 2, Double(self.N))
        }
    }
    
    func wfunction (arg: Double) -> Double {
        var res = 1.0
        
        let fT = functionTabulation
        
        for item in fT {
            res *= arg - item.arg
        }
        return res
    }
    
    func theoreticalResidual (arg: Double) ->Double {
        return maxOfDerrOnAB*wfunction(arg: arg)
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
    

    
    var maxMistake : Double {
        get {
            var arg = a
            var mist = calculateRealMistake(arg: arg)
            var maxMist = mist
            let h = 0.00001
            
            while arg <= b {
                mist = calculateRealMistake(arg: arg)
                if mist < maxMist{
                    maxMist = mist
                }
                arg += h
            }
            return mist
        }
    }
    

        
    func calculateMaxDerrOnAB ()  {
            var arg = a
            let function = analyticFunctionDerrivativeWOFactorial()
            var value = abs(function(arg))
            var max = value
            let h = 0.0001
            
            while arg <= b {
                value = abs(function(arg))
                if value > max {
                    max = value
                }
                arg += h
            }
            maxOfDerrOnAB = max
        }
    
    
    var maxOfTheoreticalResidual : Double {
        get {
            var arg = a
            var value = abs(theoreticalResidual(arg: arg))
            var max = value
            let h = 0.0001
            
            while arg <= b {
                value = abs(theoreticalResidual(arg: arg))
                if value > max {
                    max = value
                }
                arg += h
            }
            return max
        }
    }
    
    func calculateRealMistake (arg: Double) -> Double {
        return analyticFunction(arg) - interpolationPolynomFunction(arg)
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
    
    var analyticFunctionLiteral : String {
        get {
            let result = "f(x) = 2*ln(x+2)"
            return result
        }
    }
}
