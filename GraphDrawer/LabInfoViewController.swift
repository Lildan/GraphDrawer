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
    
    var dataInputPage : DataInputPageView! = nil
    var divDifPage : UIView! = nil
    var polyInfoPage : UIView! = nil
    var polyValuesPage : PolynomValuesPageView! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var pages = [UIView]()
        
        dataInputPage = createDataInputPage()
        pages.append(dataInputPage)
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
    
    func createDataInputPage () -> DataInputPageView {
        let page = DataInputPageView()
        page.frame.size = scrollView.bounds.size
        var yOffSet = CGFloat(0)
        
        let headerHeight : CGFloat = 35
        let header = createDefaultPageHeader(text: "Data Input Page", withHeight: headerHeight)
        page.addSubview(header)
        yOffSet += headerHeight
        
        let label1 = UILabel()
        label1.text = model.analyticFunctionLiteral
        label1.textAlignment = NSTextAlignment.center
        label1.frame = CGRect(x: 0, y: yOffSet, width: page.bounds.width, height: headerHeight)
        page.addSubview(label1)
        yOffSet += headerHeight
        
        let cellA = createDefaultCell()
        cellA.text = "a ="
        cellA.frame = CGRect(x: CGFloat(0.0), y: yOffSet , width: page.bounds.width * CGFloat(0.1), height: headerHeight)
        page.addSubview(cellA)
        
        page.enterATextField = UITextField()
        page.enterATextField!.frame = CGRect(x: page.bounds.width * CGFloat(0.1), y: yOffSet , width: page.bounds.width * CGFloat(0.4), height: headerHeight)
        page.enterATextField!.placeholder = String(model.a)
        page.enterATextField!.layer.borderColor = UIColor.gray.cgColor
        page.enterATextField!.layer.borderWidth = 1
        page.enterATextField!.layer.cornerRadius = 5
        page.enterATextField!.textAlignment = NSTextAlignment.center
        page.enterATextField!.returnKeyType = .done
        page.enterATextField!.delegate = self
        page.enterATextField?.tag = 1
        page.addSubview(page.enterATextField!)
        
        let cellB = createDefaultCell()
        cellB.text = "b ="
        cellB.frame = CGRect(x: page.bounds.width * CGFloat(0.5), y: yOffSet , width: page.bounds.width * CGFloat(0.1), height: headerHeight)
        page.addSubview(cellB)
        
        page.enterBTextField = UITextField()
        page.enterBTextField!.frame = CGRect(x: page.bounds.width * CGFloat(0.6), y: yOffSet , width: page.bounds.width * CGFloat(0.4), height: headerHeight)
        page.enterBTextField!.placeholder = String(model.b)
        page.enterBTextField!.layer.borderColor = UIColor.gray.cgColor
        page.enterBTextField!.layer.borderWidth = 1
        page.enterBTextField!.layer.cornerRadius = 5
        page.enterBTextField!.textAlignment = NSTextAlignment.center
        page.enterBTextField!.returnKeyType = .done
        page.enterBTextField!.delegate = self
        page.enterBTextField?.tag = 2
        page.addSubview(page.enterBTextField!)
        yOffSet += CGFloat(2)*headerHeight
        
        let cellN = createDefaultCell()
        cellN.text = "n ="
        cellN.frame = CGRect(x: page.bounds.width * CGFloat(0.25), y: yOffSet , width: page.bounds.width * CGFloat(0.1), height: headerHeight)
        page.addSubview(cellN)
        
        page.enterNTextField = UITextField()
        page.enterNTextField!.frame = CGRect(x: page.bounds.width * CGFloat(0.35), y: yOffSet , width: page.bounds.width * CGFloat(0.4), height: headerHeight)
        page.enterNTextField!.placeholder = String(model.N)
        page.enterNTextField!.layer.borderColor = UIColor.lightGray.cgColor
        page.enterNTextField!.layer.borderWidth = 1
        page.enterNTextField!.layer.cornerRadius = 5
        page.enterNTextField!.textAlignment = NSTextAlignment.center
        page.enterNTextField!.returnKeyType = .done
        page.enterNTextField!.delegate = self
        page.enterNTextField?.tag = 3
        page.addSubview(page.enterNTextField!)
        yOffSet += CGFloat(2)*headerHeight
        
        page.recalculateButton = UIButton()
        page.recalculateButton?.setTitle("Recalculate", for: .normal)
        page.recalculateButton?.addTarget(self, action: #selector(recalculateButtonTap), for: .touchUpInside)
        page.recalculateButton?.frame = CGRect(x: page.bounds.width * CGFloat(0.25), y: yOffSet , width: page.bounds.width * CGFloat(0.5), height: headerHeight)
        page.recalculateButton?.backgroundColor = UIColor.black
        page.addSubview(page.recalculateButton!)
        yOffSet += headerHeight
    
        
        
        return page
    }
    
    func recalculateButtonTap () {
        if dataInputPage.enterATextField?.layer.borderColor == UIColor.green.cgColor &&
            dataInputPage.enterBTextField?.layer.borderColor == UIColor.green.cgColor &&
            dataInputPage.enterNTextField?.layer.borderColor == UIColor.green.cgColor {
            
            let a = Double((dataInputPage.enterATextField?.text)!)!
            let b = Double((dataInputPage.enterBTextField?.text)!)!
            let N = Int((dataInputPage.enterNTextField?.text)!)!
            
            if b <= a {
                dataInputPage.enterATextField?.layer.borderColor = UIColor.red.cgColor
                dataInputPage.enterBTextField?.layer.borderColor = UIColor.red.cgColor
                return
            }
            
            model.updateData(iN: N, ia: a, ib: b)
            
            var pages = [UIView]()
            
            var page : UIView = createDividedDifferencesPageView()
            page.frame = divDifPage.frame
            divDifPage.removeFromSuperview()
            divDifPage = page
            pages.append(divDifPage)
            
            page = createPolynomInformationPageView()
            page.frame =  polyInfoPage.frame
            polyInfoPage.removeFromSuperview()
            polyInfoPage = page
            pages.append(polyInfoPage)
            
            page = createPolynomValuesPageView()
            page.frame = polyValuesPage.frame
            polyValuesPage.removeFromSuperview()
            polyValuesPage = page as! PolynomValuesPageView
            pages.append(polyValuesPage)
            
            // Adding pages to the scrollview
            for page in pages {
                scrollView.addSubview(page)
            }
            
        }
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
        label3.text = "Analytic function"
        label3.textAlignment = NSTextAlignment.center
        label3.frame = CGRect(x: 0, y: headerHeight*9, width: page.bounds.width, height: headerHeight)
        page.addSubview(label3)
        
        let labelLinearApproximation = UILabel()
        labelLinearApproximation.text = model.analyticFunctionLiteral
        labelLinearApproximation.textAlignment = NSTextAlignment.center
        labelLinearApproximation.numberOfLines = 0
        labelLinearApproximation.frame = CGRect(x: CGFloat(15), y: headerHeight*10 , width: page.bounds.width - 30, height: headerHeight)
        page.addSubview(labelLinearApproximation)
        
        let label4 = UILabel()
        label4.text = "Residual member"
        label4.textAlignment = NSTextAlignment.center
        label4.frame = CGRect(x: 0, y: headerHeight*11, width: page.bounds.width, height: headerHeight)
        page.addSubview(label4)
        
        let label5 = UILabel()
        label5.text = "R(x) = f(x) - L(x)"
        label5.textAlignment = NSTextAlignment.center
        label5.frame = CGRect(x: 0, y: headerHeight*12, width: page.bounds.width, height: headerHeight)
        page.addSubview(label5)
        
        return page
    }
    
    
    func createPolynomValuesPageView () -> PolynomValuesPageView {
        let page = PolynomValuesPageView()
        model.calculateMaxDerrOnAB()
        page.frame.size = scrollView.bounds.size
        
        var yOffSet = CGFloat(0)
        let headerHeight : CGFloat = 35
        
        let header = createDefaultPageHeader(text: "Functions' Values", withHeight: headerHeight)
        page.addSubview(header)
        yOffSet += headerHeight
        
        var cellWidth = scrollView.bounds.size.width / CGFloat(3)
        
        for i in 0..<model.args.count {
            let cellX = createDefaultCell()
            cellX.frame = CGRect(x: CGFloat(i)*cellWidth, y: yOffSet, width: cellWidth, height: headerHeight)
            var xtxt = "x"
            var counter  = 0
            
            while counter <= i {
                xtxt = xtxt + "'"
                counter += 1
            }
            cellX.text = xtxt + "=" + String(model.args[i])
            page.addSubview((cellX))
        }
        yOffSet += headerHeight
        
        cellWidth = scrollView.bounds.size.width / CGFloat(4)
        
        for i in 0..<model.args.count {
            let cellLX = createDefaultCell()
            cellLX.frame = CGRect(x: 0, y: yOffSet, width: cellWidth, height: headerHeight)
            var value = roundDouble(model.interpolationPolynomFunction(model.args[i]), toPrecision: 4)
            var xtxt = "x"
            var counter  = 0
            while counter <= i {
                xtxt = xtxt + "'"
                counter += 1
            }
            var txt = "L(" + xtxt + ")=" + String(value)
            cellLX.text = txt
            page.addSubview(cellLX)
            
            let cellAX = createDefaultCell()
            cellAX.frame = CGRect(x: cellWidth, y: yOffSet, width: cellWidth, height: headerHeight)
            value = roundDouble(model.analyticFunction(model.args[i]), toPrecision: 4)
            txt = "f(" + xtxt + ")=" + String(value)
            cellAX.text = txt
            page.addSubview(cellAX)
            
            let cellRX = createDefaultCell()
            cellRX.frame = CGRect(x: cellWidth*CGFloat(2), y: yOffSet, width: cellWidth, height: headerHeight)
            value = roundDouble(model.calculateRealMistake(arg: (model.args[i])), toPrecision: 4)
            txt = "R(" + xtxt + ")=" + String(abs(value))
            cellRX.text = txt
            page.addSubview(cellRX)
            
            let cellThRX = createDefaultCell()
            cellThRX.frame = CGRect(x: cellWidth*CGFloat(3), y: yOffSet, width: cellWidth, height: headerHeight)
            value = roundDouble(model.theoreticalResidual(arg: model.args[i]), toPrecision: 4)
            txt = "ThR(" + xtxt + ")=" + String(abs(value))
            cellThRX.text = txt
            page.addSubview(cellThRX)

            
            
            yOffSet += headerHeight
        }
        
        
        page.enterXTextField = UITextField()
        page.enterXTextField!.frame = CGRect(x: page.bounds.width * CGFloat(0.25), y: yOffSet + headerHeight, width: page.bounds.width * CGFloat(0.5), height: headerHeight)
        page.enterXTextField!.placeholder = "Enter X"
        page.enterXTextField!.layer.borderColor = UIColor.blue.cgColor
        page.enterXTextField!.layer.borderWidth = 2
        page.enterXTextField!.layer.cornerRadius = 5
        page.enterXTextField!.textAlignment = NSTextAlignment.center
        page.enterXTextField!.returnKeyType = .done
        page.enterXTextField!.delegate = self
        page.enterXTextField!.tag = 4
        
        page.addSubview((page.enterXTextField!))
        yOffSet += 2*headerHeight
        
        
        page.resultLXLabel = createDefaultCell()
        page.resultLXLabel?.text = "L(x)"
        page.resultLXLabel?.frame = CGRect(x: 0, y: yOffSet, width: page.bounds.width * CGFloat(0.25), height: headerHeight)
        page.addSubview(page.resultLXLabel!)
       
        
        page.resultFXLabel = createDefaultCell()
        page.resultFXLabel?.text = "f(x)"
        page.resultFXLabel?.frame = CGRect(x: page.bounds.width * CGFloat(0.25), y: yOffSet, width: page.bounds.width * CGFloat(0.25), height: headerHeight)
        page.addSubview(page.resultFXLabel!)

        page.resultRXLabel = createDefaultCell()
        page.resultRXLabel?.text = "R(x)"
        page.resultRXLabel?.frame = CGRect(x: page.bounds.width * CGFloat(0.5), y: yOffSet, width: page.bounds.width * CGFloat(0.25), height: headerHeight)
        page.addSubview(page.resultRXLabel!)
        
        page.resultTheorRXLabel = createDefaultCell()
        page.resultTheorRXLabel?.text = "ThR(x)"
        page.resultTheorRXLabel?.frame = CGRect(x: page.bounds.width * CGFloat(0.75), y: yOffSet, width: page.bounds.width * CGFloat(0.25), height: headerHeight)
        page.addSubview(page.resultTheorRXLabel!)
        yOffSet += headerHeight
        
        
        
        let labelMistake = createDefaultCell()
        labelMistake.frame = CGRect(x: CGFloat(0), y: yOffSet + headerHeight, width: page.bounds.width , height: headerHeight)
        labelMistake.text = "Maximal real mistake on [a;b] = " +  String(abs(model.maxMistake))
        page.addSubview(labelMistake)
        
        yOffSet += CGFloat(2)*headerHeight
        
        let labelThMistake = createDefaultCell()
        labelThMistake.frame = CGRect(x: CGFloat(0), y: yOffSet , width: page.bounds.width , height: headerHeight)
        
        labelThMistake.text = "Maximal theoretical mistake on [a;b] = " +  String(model.maxOfTheoreticalResidual)
        page.addSubview(labelThMistake)
        
        yOffSet += CGFloat(2)*headerHeight
        
        
        return page
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField.tag == 1 || textField.tag == 2 {
            if Double(textField.text!) != nil {
                textField.layer.borderColor = UIColor.green.cgColor
            }
            else {
                textField.layer.borderColor = UIColor.red.cgColor
            }
        }
        
        if textField.tag == 3 {
            let number = Int(textField.text!)
            if number != nil && number! >= 2 {
                textField.layer.borderColor = UIColor.green.cgColor
            }
            else {
                textField.layer.borderColor = UIColor.red.cgColor
            }
        }
        
        
        if textField.tag == 4 {
            if let number = Double(textField.text!)  {
            textField.layer.borderColor = UIColor.green.cgColor
            if let page = textField.superview as? PolynomValuesPageView {
                page.resultLXLabel?.text = "L(x)=" + String(roundDouble(model.interpolationPolynomFunction(number), toPrecision: 4))
                page.resultFXLabel?.text = "f(x)=" + String(roundDouble(model.analyticFunction(number), toPrecision: 4))
                page.resultRXLabel?.text = "R(x)=" + String(abs(roundDouble(model.calculateRealMistake(arg: number), toPrecision: 4)))
                page.resultTheorRXLabel?.text = "ThR(x)=" + String(abs(roundDouble(model.theoreticalResidual(arg: number), toPrecision: 4)))
                }
            } else {
                textField.layer.borderColor = UIColor.red.cgColor
                if let page = textField.superview as? PolynomValuesPageView {
                    page.resultLXLabel?.text = "L(x)"
                    page.resultFXLabel?.text = "f(x)"
                    page.resultRXLabel?.text = "R(x)"
                    page.resultTheorRXLabel?.text = "ThR(x)"
                }
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
            vc.secondFunc = model.analyticFunction
            vc.navigationItem.title = "Graphs"
        }
    }
}

func roundDouble (_ arg: Double, toPrecision i: Int) -> Double{
    let a = pow(10,Double(i))
    return (round(arg * a))/a
}


