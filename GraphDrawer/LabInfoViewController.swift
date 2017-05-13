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
        
        scrollView.addSubview(createDividedDifferencesPageView())
    }
    
    func createDividedDifferencesPageView () -> UIView {
        let page = UIView()
        page.frame.size = scrollView.bounds.size
        
        let header = UILabel()
        header.text = "Divided Differences Table"
        header.textAlignment = NSTextAlignment.center
        let headerHeight : CGFloat = 35
        header.frame = CGRect(x: 0, y: 0, width: page.bounds.width, height: headerHeight)
        page.addSubview(header)
        
        let rowNumber = model.functionTabulation.count + 2
        let columnNumber = model.dividedDifferences.count + 1
        
        let cellWidth = page.bounds.size.width / CGFloat(columnNumber)
        let cellHeight = (page.bounds.size.height - headerHeight) / CGFloat(rowNumber)
        
        let cellBorderColor = UIColor.blue.cgColor
        let cellBorderWidth = CGFloat(1)
        
        // Adding top header like: X f() f(;)...
        for i in 0..<columnNumber {
            let cell = createDefaultCell(cellBorderColor,cellBorderWidth)
            cell.frame = CGRect(x: CGFloat(i)*cellWidth, y: headerHeight, width: cellWidth, height: cellHeight)

            
            // inserting appropriate text
            if i == 0 {
                cell.text = "X"
            }
            else {
                var txt = "f("
                for _ in 0..<(i-1) {
                    txt += ";"
                }
                txt += ")"
                cell.text = txt
            }
            
            page.addSubview(cell)
        }
        
        // adding column of x values
        let yOffSet = headerHeight + cellHeight
        for i in 0..<model.functionTabulation.count {
            let cell = createDefaultCell(cellBorderColor,cellBorderWidth)
            cell.frame = CGRect(x: CGFloat(0), y: yOffSet + CGFloat(i)*cellHeight, width: cellWidth, height: cellHeight)
            cell.text = String(model.functionTabulation[i].arg)
            page.addSubview(cell)
        }
        
        let xOffSet = cellWidth
        var addYOffSet = CGFloat(0)
        // adding divided differences themselves into table
        for j in 0..<model.dividedDifferences.count {
            for i in 0..<model.dividedDifferences[j].count {
                
                let cell = createDefaultCell(cellBorderColor, cellBorderWidth)
                cell.frame = CGRect(x: xOffSet + cellWidth * CGFloat(j),
                                    y: yOffSet + cellHeight * (CGFloat(i)+addYOffSet),
                                    width: cellWidth,
                                    height: cellHeight)
            
                cell.text = String((round(100*model.dividedDifferences[j][i]))/100)
                page.addSubview(cell)
            }
            addYOffSet += CGFloat(0.5)
        }
        
        return page
    }
    
    func createDefaultCell (_ bColor: CGColor? = nil, _ bWidth: CGFloat = CGFloat(0)) -> UILabel {
        
        let cell = UILabel()
        cell.textAlignment = NSTextAlignment.center
        cell.adjustsFontSizeToFitWidth = true
        
        if bColor != nil {
        cell.layer.borderColor = bColor
        cell.layer.borderWidth = bWidth
        }
        return cell
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

