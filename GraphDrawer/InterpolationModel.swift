//
//  InterpolationModel.swift
//  GraphDrawer
//
//  Created by Lildan on 4/23/17.
//  Copyright © 2017 Lildan. All rights reserved.
//

import Foundation
import UIKit
import Darwin

class InterpolationModel {
    
    var a : Double = 0
    var b : Double = 2
    var tabulation : Double = 0.05
    
    
    var funcs : [(fu:(Double)->Double, literal: String, color: UIColor)] =
    [
        ({return pow(M_E, -2.0*$0)*sin($0)*sin($0)}, "y = e^(-2x)*(sin(x))^2", UIColor.blue),
        ({return pow($0, 1.0/3.0) }, "y = x^(1/3)", UIColor.orange),
        ({return pow(1.0-$0, 1.0/3.0)},"y = (1-x)^(1/3)", UIColor.green),
        ({return 1-pow($0, 3.0)}, "y = 1-x^3", UIColor.purple),
        ({return pow((1-pow($0, 3.0)), 1.0/3.0)},"y = (1-x^3)^(1/3)", UIColor.brown)
    ]
    



}
