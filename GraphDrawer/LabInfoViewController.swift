//
//  LabInfoController.swift
//  GraphDrawer
//
//  Created by Lildan on 4/23/17.
//  Copyright © 2017 Lildan. All rights reserved.
//

import Foundation
import UIKit

class LabInfoViewController: UIViewController, UITextFieldDelegate {
    
    // View
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    @IBAction func showGraphTap(_ sender: Any) {
        
    }
    var model : InterpolationModel = InterpolationModel()
    
    var divDifPage : UIView! = nil
    var polyInfoPage : UIView! = nil
    var polyValuesPage : PolynomValuesPageView! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var pages = [UIView]()
        
        divDifPage = createDividedDifferencesPageView()
        pages.append(divDifPage)
        polyInfoPage = createPolynomInformationPageView()
        pages.append(polyInfoPage)
        polyValuesPage = createPolynomValuesPageView()
        pages.append(polyValuesPage)
        
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
        
        let label3 = UILabel()
        label3.text = "Linear approximation function"
        label3.textAlignment = NSTextAlignment.center
        label3.frame = CGRect(x: 0, y: headerHeight*9, width: page.bounds.width, height: headerHeight)
        page.addSubview(label3)
        
        let labelLinearApproximation = UILabel()
        labelLinearApproximation.text = model.linearApproximationFunctionLiteral
        labelLinearApproximation.textAlignment = NSTextAlignment.center
        labelLinearApproximation.numberOfLines = 0
        labelLinearApproximation.frame = CGRect(x: CGFloat(15), y: headerHeight*10 , width: page.bounds.width - 30, height: headerHeight)
        page.addSubview(labelLinearApproximation)
        
        
        return page
    }
    
    
    func createPolynomValuesPageView () -> PolynomValuesPageView {
        let page = PolynomValuesPageView()
        page.frame.size = scrollView.bounds.size
        
        var yOffSet = CGFloat(0)
        let headerHeight : CGFloat = 35
        
        let header = createDefaultPageHeader(text: "Functions' Values", withHeight: headerHeight)
        page.addSubview(header)
        yOffSet += headerHeight
        
        let cellWidth = scrollView.bounds.size.width / CGFloat(3)
        
        for i in 0..<model.args.count {
            let cellX = createDefaultCell()
            cellX.frame = CGRect(x: 0, y: yOffSet, width: cellWidth, height: headerHeight)
            var xtxt = "x"
            var counter  = 0
            
            while counter <= i {
                xtxt = xtxt + "'"
                counter += 1
            }
            
            cellX.text = xtxt + " = " + String(model.args[i])
            page.addSubview((cellX))
            
            let cellLX = createDefaultCell()
            cellLX.frame = CGRect(x: cellWidth, y: yOffSet, width: cellWidth, height: headerHeight)
            var value = roundDouble(model.interpolationPolynomFunction(model.args[i]), toPrecision: 4)
            var txt = "L(" + xtxt + ") = " + String(value)
            cellLX.text = txt
            page.addSubview(cellLX)
            
            let cellAX = createDefaultCell()
            cellAX.frame = CGRect(x: cellWidth*CGFloat(2), y: yOffSet, width: cellWidth, height: headerHeight)
            value = roundDouble(model.linearApproximationFunction(model.args[i]), toPrecision: 4)
            txt = "A(" + xtxt + ") = " + String(value)
            cellAX.text = txt
            page.addSubview(cellAX)
            yOffSet += headerHeight
        }
        
        let header2 = createDefaultPageHeader(text: "Sum of squares of deviations", withHeight: headerHeight)
        header2.frame.origin.y = yOffSet + headerHeight
        page.addSubview((header2))
        yOffSet += CGFloat(2)*headerHeight
        
        let cell = createDefaultCell()
        cell.frame = CGRect(x: 0, y: yOffSet, width: page.bounds.width, height: headerHeight)
        cell.textAlignment = NSTextAlignment.center
        cell.text = String(model.calculateDeviations())
        page.addSubview(cell)
        yOffSet += headerHeight
        
        
        page.enterXTextField = UITextField()
        page.enterXTextField!.frame = CGRect(x: page.bounds.width * CGFloat(0.25), y: yOffSet + headerHeight, width: page.bounds.width * CGFloat(0.5), height: headerHeight)
        page.enterXTextField!.placeholder = "Enter X"
        page.enterXTextField!.layer.borderColor = UIColor.blue.cgColor
        page.enterXTextField!.layer.borderWidth = 2
        page.enterXTextField!.layer.cornerRadius = 5
        page.enterXTextField!.textAlignment = NSTextAlignment.center
        page.enterXTextField!.returnKeyType = .done
        page.enterXTextField!.delegate = self
        
        page.addSubview((page.enterXTextField!))
        yOffSet += 2*headerHeight
        
        
        page.resultLXLabel = createDefaultCell()
        page.resultLXLabel?.text = "L(x)"
        page.resultLXLabel?.frame = CGRect(x: 0, y: yOffSet, width: page.bounds.width * CGFloat(0.5), height: headerHeight)
        page.addSubview(page.resultLXLabel!)
       
        
        page.resultAXLabel = createDefaultCell()
        page.resultAXLabel?.text = "A(x)"
        page.resultAXLabel?.frame = CGRect(x: page.bounds.width * CGFloat(0.5), y: yOffSet, width: page.bounds.width * CGFloat(0.5), height: headerHeight)
        page.addSubview(page.resultAXLabel!)
        yOffSet += headerHeight
        
        return page
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if let number = Double(textField.text!)  {
            textField.layer.borderColor = UIColor.green.cgColor
            if let page = textField.superview as? PolynomValuesPageView {
                page.resultLXLabel?.text = "L(x)=" + String(roundDouble(model.interpolationPolynomFunction(number), toPrecision: 4))
                page.resultAXLabel?.text = "A(x)=" + String(roundDouble(model.linearApproximationFunction(number), toPrecision: 4))
            }
            
        } else {
            textField.layer.borderColor = UIColor.red.cgColor
            if let page = textField.superview as? PolynomValuesPageView {
                page.resultLXLabel?.text = "L(x)"
                page.resultAXLabel?.text = "A(x)"
            }
        }
        
        return true
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
            vc.firstFunc = model.interpolationPolynomFunction
            vc.secondFunc = model.linearApproximationFunction
            vc.navigationItem.title = "Graphs"
        }
    }
}

func roundDouble (_ arg: Double, toPrecision i: Int) -> Double{
    let a = pow(10,Double(i))
    return (round(arg * a))/a
}


