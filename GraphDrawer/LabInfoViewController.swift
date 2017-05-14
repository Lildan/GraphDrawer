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
        
        var pages = [UIView]()
        
        pages.append(createDividedDifferencesPageView())
        pages.append(createPolynomInformationPageView())
        pages.append(createPolynomValuesPageView())
        
        // Adding pages to the scrollview
        for (i, page) in pages.enumerated() {
            page.frame.origin.x = scrollView.bounds.width * CGFloat(i)
            scrollView.addSubview(page)
        }
        
        scrollView.contentSize.width = scrollView.bounds.size.width*CGFloat(pages.count)
        scrollView.isPagingEnabled = true
    }
    
    func createDividedDifferencesPageView () -> UIView {
        let page = UIView()
        page.frame.size = scrollView.bounds.size
        
        let headerHeight : CGFloat = 35
        
        let header = createDefaultPageHeader(text: "Divided Differences Table", withHeight: headerHeight)

        page.addSubview(header)
        
        let rowNumber = model.functionTabulation.count + 2
        let columnNumber = model.dividedDifferences.count + 1
        
        let cellWidth = page.bounds.size.width / CGFloat(columnNumber)
        let cellHeight = (page.bounds.size.height - headerHeight) / CGFloat(rowNumber)
        
        let cellBorderColor = UIColor.gray.cgColor
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
            
                cell.text = String(roundDouble(model.dividedDifferences[j][i], toPrecision: 2))
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
    
    func createDefaultPageHeader (text: String, withHeight height : CGFloat) -> UILabel{
        let header = UILabel()
        header.text = text
        header.textAlignment = NSTextAlignment.center
        header.frame = CGRect(x: 0, y: 0, width: scrollView.bounds.width, height: height)
        
        return header
    }
    
    func createPolynomInformationPageView ()-> UIView {
        let page = UIView()
        page.frame.size = scrollView.bounds.size
        
        let headerHeight : CGFloat = 35
        
        let header = createDefaultPageHeader(text: "Interpolation Polynom Information", withHeight: headerHeight)
        page.addSubview(header)
        
        let label1 = UILabel()
        label1.text = "Newton`s polynom coefficients"
        label1.textAlignment = NSTextAlignment.center
        label1.frame = CGRect(x: 0, y: headerHeight*2, width: page.bounds.width, height: headerHeight)
        page.addSubview(label1)
        
        let cellSize = page.bounds.width / CGFloat(model.dividedDifferences.count)
        
        for j in 0..<model.dividedDifferences.count {
            let cell = createDefaultCell()
            cell.frame = CGRect(x: CGFloat(j)*cellSize, y: headerHeight*3, width: cellSize, height: headerHeight)
            cell.text = String(roundDouble(model.dividedDifferences[j][0], toPrecision: 2))
            
            page.addSubview(cell)
        }
        
        let label2 = UILabel()
        label2.text = "Newton`s polynom by Gorner`s schema"
        label2.textAlignment = NSTextAlignment.center
        label2.frame = CGRect(x: 0, y: headerHeight*5, width: page.bounds.width, height: headerHeight)
        page.addSubview(label2)
        
        let labelGorner = UILabel()
        labelGorner.text = model.functionLiteral
        labelGorner.numberOfLines = 0
        labelGorner.frame = CGRect(x: CGFloat(15), y: headerHeight*6 , width: page.bounds.width - 30, height: headerHeight*3)
        page.addSubview(labelGorner)
 
        return page
    }
    
    
    func createPolynomValuesPageView () -> UIView {
        let page = UIView()
        page.frame.size = scrollView.bounds.size
        
        let headerHeight : CGFloat = 35
        
        let header = createDefaultPageHeader(text: "Interpolation Polynom Values", withHeight: headerHeight)
        page.addSubview(header)
        
        let args = [ 0.445 , 0.778, 0.801]
        let cellWidth = scrollView.bounds.size.width / CGFloat(2)
        
        for i in 0..<args.count {
            let cellX = createDefaultCell()
            cellX.frame = CGRect(x: 0, y: headerHeight*CGFloat(i+1), width: cellWidth, height: headerHeight)
            var txt = "x"
            var counter  = 0
            
            while counter <= i {
                txt = txt + "'"
                counter += 1
            }
            var value = args[i]
            cellX.text = txt + " = " + String(value)
            page.addSubview((cellX))
            
            let cellLX = createDefaultCell()
            cellLX.frame = CGRect(x: cellWidth, y: headerHeight*CGFloat(i+1), width: cellWidth, height: headerHeight)
            value = roundDouble(model.interpolationPolynomFunction(args[i]), toPrecision: 4)
            txt = "L(" + txt + ") = " + String(value)
            cellLX.text = txt
            page.addSubview(cellLX)
        }
        
        return page
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
            vc.yForX = model.interpolationPolynomFunction
            vc.navigationItem.title = "L(x)"
        }
    }
}

func roundDouble (_ arg: Double, toPrecision i: Int) -> Double{
    let a = pow(10,Double(i))
    return (round(arg * a))/a
}


