//
//  GraphViewController.swift
//  GraphDrawer
//
//  Created by Lildan on 4/17/17.
//  Copyright © 2017 Lildan. All rights reserved.
//

import UIKit

class GraphViewController : UIViewController {
    
    //Model
    var yForX : ((Double) ->Double)?
    
    
    //View
    @IBOutlet weak var graphView: GraphView!
    
    func UpdateUI() {
    graphView.yForX = yForX
    }
    
    override func viewDidLoad() {
        super.viewDidLoad ()
        yForX = ((x: Double)->(Double)) {
            (x) -> cos(1/(x+2))*x
        }
            
        
    }
}
