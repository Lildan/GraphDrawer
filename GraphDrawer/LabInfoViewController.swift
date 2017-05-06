//
//  LabInfoController.swift
//  GraphDrawer
//
//  Created by Lildan on 4/23/17.
//  Copyright © 2017 Lildan. All rights reserved.
//

import Foundation
import UIKit

class LabInfoViewController: UIViewController {
    
    // View
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    @IBAction func showGraphTap(_ sender: Any) {
        
    }
    var model: Lab5Model = Lab5Model()
    
    var viewsNumber: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    

    
    private struct Storyboard {
        static let ShowGraph = "ShowGraph"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var destination = segue.destination
        if let navigationController = destination as? UINavigationController {
            destination = navigationController.visibleViewController ?? destination
        }
        if let identifier = segue.identifier,
        identifier == Storyboard.ShowGraph,
        let vc = destination as? GraphViewController {
            vc.yForX = model.function
            vc.navigationItem.title = model.functionLiteral
        }
    }
}

