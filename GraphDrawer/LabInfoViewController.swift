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
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var pages = [UIView]()
        
        dataInputPage = createDataInputPage()
        pages.append(dataInputPage)

        
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
        let header = createDefaultPageHeader(text: "Lab work 7", withHeight: headerHeight)
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
        page.enterATextField!.layer.borderColor = UIColor.green.cgColor
        page.enterATextField!.layer.borderWidth = 1
        page.enterATextField!.layer.cornerRadius = 5
        page.enterATextField!.textAlignment = NSTextAlignment.center
        page.enterATextField!.returnKeyType = .done
        page.enterATextField!.delegate = self
        page.enterATextField?.tag = 1
        page.enterATextField?.text = "0.0"
        page.addSubview(page.enterATextField!)
        
        let cellB = createDefaultCell()
        cellB.text = "b ="
        cellB.frame = CGRect(x: page.bounds.width * CGFloat(0.5), y: yOffSet , width: page.bounds.width * CGFloat(0.1), height: headerHeight)
        page.addSubview(cellB)
        
        page.enterBTextField = UITextField()
        page.enterBTextField!.frame = CGRect(x: page.bounds.width * CGFloat(0.6), y: yOffSet , width: page.bounds.width * CGFloat(0.4), height: headerHeight)
        page.enterBTextField!.placeholder = String(model.b)
        page.enterBTextField!.layer.borderColor = UIColor.green.cgColor
        page.enterBTextField!.layer.borderWidth = 1
        page.enterBTextField!.layer.cornerRadius = 5
        page.enterBTextField!.textAlignment = NSTextAlignment.center
        page.enterBTextField!.returnKeyType = .done
        page.enterBTextField!.delegate = self
        page.enterBTextField?.tag = 2
        page.enterBTextField?.text = "2.0"
        page.addSubview(page.enterBTextField!)
        yOffSet += CGFloat(2)*headerHeight
        
        let cellN = createDefaultCell()
        cellN.text = "eps ="
        cellN.frame = CGRect(x: page.bounds.width * CGFloat(0.25), y: yOffSet , width: page.bounds.width * CGFloat(0.1), height: headerHeight)
        page.addSubview(cellN)
        
        page.enterEpsTextField = UITextField()
        page.enterEpsTextField!.frame = CGRect(x: page.bounds.width * CGFloat(0.35), y: yOffSet , width: page.bounds.width * CGFloat(0.4), height: headerHeight)
        page.enterEpsTextField!.placeholder = String(model.epsilon)
        page.enterEpsTextField!.layer.borderColor = UIColor.green.cgColor
        page.enterEpsTextField!.layer.borderWidth = 1
        page.enterEpsTextField!.layer.cornerRadius = 5
        page.enterEpsTextField!.textAlignment = NSTextAlignment.center
        page.enterEpsTextField!.returnKeyType = .done
        page.enterEpsTextField!.delegate = self
        
        page.enterEpsTextField?.text = "0.001"
        page.enterEpsTextField?.tag = 3
        page.addSubview(page.enterEpsTextField!)
        yOffSet += CGFloat(2)*headerHeight
        
        page.recalculateButton = UIButton()
        page.recalculateButton?.setTitle("Calculate Integral", for: .normal)
        page.recalculateButton?.addTarget(self, action: #selector(calculateButtonTap), for: .touchUpInside)
        page.recalculateButton?.frame = CGRect(x: page.bounds.width * CGFloat(0.25), y: yOffSet , width: page.bounds.width * CGFloat(0.5), height: headerHeight)
        page.recalculateButton?.backgroundColor = UIColor.white
        page.recalculateButton?.setTitleColor( .blue , for: .normal)
        page.addSubview(page.recalculateButton!)
        yOffSet += headerHeight
        
        page.integralValueLabel = createDefaultCell()
        page.integralValueLabel?.frame = CGRect(x: CGFloat(0), y: yOffSet, width: scrollView.bounds.width, height: headerHeight)
        page.addSubview(page.integralValueLabel!)
        yOffSet += headerHeight
        
        page.numberOfIntervalsLabel = createDefaultCell()
        page.numberOfIntervalsLabel?.frame = CGRect(x: CGFloat(0), y: yOffSet, width: scrollView.bounds.width, height: headerHeight)
        page.addSubview(page.numberOfIntervalsLabel!)
        yOffSet += headerHeight
        
        return page
    }
    
    func calculateButtonTap () {
        if dataInputPage.enterATextField?.layer.borderColor == UIColor.green.cgColor &&
            dataInputPage.enterBTextField?.layer.borderColor == UIColor.green.cgColor &&
            dataInputPage.enterEpsTextField?.layer.borderColor == UIColor.green.cgColor {
            
            let a = Double((dataInputPage.enterATextField?.text)!)!
            let b = Double((dataInputPage.enterBTextField?.text)!)!
            let eps = Double(((dataInputPage.enterEpsTextField?.text)!)!)!
            
            if b <= a {
                dataInputPage.enterATextField?.layer.borderColor = UIColor.red.cgColor
                dataInputPage.enterBTextField?.layer.borderColor = UIColor.red.cgColor
                return
            }
            let value = model.Solve(forPrecision: eps, a, b)
            
            dataInputPage.integralValueLabel?.text = "Integral value = " + String(value)
            dataInputPage.numberOfIntervalsLabel?.text = "Number of intervals used in calculation = " + String(model.N)
            
            return
        }
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

    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField.tag == 1 || textField.tag == 2 {
            let number = Double(textField.text!)
            if number != nil && number! >= -1 {
                textField.layer.borderColor = UIColor.green.cgColor
            }
            else {
                textField.layer.borderColor = UIColor.red.cgColor
            }
        }
        
        if textField.tag == 3 {
            let number = Double(textField.text!)
            if number != nil && number! > 0.0 {
                textField.layer.borderColor = UIColor.green.cgColor
            }
            else {
                textField.layer.borderColor = UIColor.red.cgColor
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
        vc.firstFunc = model.analyticFunction(arg:)
        vc.navigationItem.title = "Graphs"
        }
    }
}

func roundDouble (_ arg: Double, toPrecision i: Int) -> Double{
    let a = pow(10,Double(i))
    return (round(arg * a))/a
}


