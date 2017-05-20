//
//  InterpolationModel.swift
//  GraphDrawer
//
//  Created by Lildan on 4/23/17.
//  Copyright © 2017 Lildan. All rights reserved.
//

import Foundation

class InterpolationModel {
    
    var N : Int = 2
    var a : Double = 0
    var b : Double = 2
    var epsilon : Double = 0.001
    
    var sumOfAllPrevFuncValuesInInternalNodes : Double = 0
    var sumfafb : Double = 0
    
    func analyticFunction (arg: Double)->Double {
        return pow(1+arg*arg*arg, 0.5)
        /*
         var value = calculatedFunction[arg]
        if value == nil {
            value = pow(1+arg*arg*arg, 0.5)
            calculatedFunction[arg] = value!
        }
        return value!
        */
    }
    
    var calculatedFunction : [Double: Double] = [:]
    
    let analyticFunctionLiteral = "(1+x^3)^(1/2)"

    func CalculateIntegral ()->Double {
        
        if N == 1 {
            sumfafb = analyticFunction(arg: a) + analyticFunction(arg: b)
        }
        let step =  (b - a) / Double(N)
        
        let sumOfAllEvenFuncValuesInInternalNodes = sumOfAllPrevFuncValuesInInternalNodes
        
        var sumOfAllOddFuncValuesInInternalNodes = 0.0
        var i : Int = 1
        
        while i <= N / 2 {
            sumOfAllOddFuncValuesInInternalNodes += analyticFunction(arg: a + Double(2*i-1)*step)
            i += 1
        }
        
        sumOfAllPrevFuncValuesInInternalNodes = sumOfAllEvenFuncValuesInInternalNodes + sumOfAllOddFuncValuesInInternalNodes
        
        let result = (step/3.0)*(sumfafb + 4*sumOfAllOddFuncValuesInInternalNodes + 2*sumOfAllEvenFuncValuesInInternalNodes)
        
        return result
    }
    
    func Solve (forPrecision eps: Double, _ a: Double, _ b: Double) -> Double {
        self.a = a
        self.b = b
        self.epsilon = eps
        N = 2
        
        var prevValue = 0.0
        var value = 0.0
        while true {
            value = CalculateIntegral()
            
            if abs(value - prevValue) < epsilon {
                break
            }
            prevValue = value
            N *= 2
        }
        return value
    }
}
