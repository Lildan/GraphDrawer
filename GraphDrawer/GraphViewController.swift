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
    var funcs : [(fu:(Double)->Double, literal: String, color: UIColor)]? = nil {
        didSet { updateUI() }
    }

    //View
    @IBOutlet weak var graphView: GraphView! {
        didSet {
            graphView.addGestureRecognizer(UIPinchGestureRecognizer(target: graphView, action: #selector(GraphView.scale(_:))))
            
            graphView.addGestureRecognizer(UIPanGestureRecognizer(target: graphView, action: #selector(GraphView.originMove(_:))))
            
            let doubleTapRecognizer = UITapGestureRecognizer(target: graphView, action: #selector(GraphView.origin(_:)))
            doubleTapRecognizer.numberOfTapsRequired = 2
            graphView.addGestureRecognizer((doubleTapRecognizer))
            
            updateUI()
        }
    }
    
    func updateUI() {
        if let gv = graphView {
            gv.funcs = funcs
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad ()
    }
}
