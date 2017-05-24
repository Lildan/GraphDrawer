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
    var model : CalculationModel = CalculationModel()
    
    var dataInputPage : DataInputPageView! = nil
    var pages : [UIView]! = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         pages = [UIView]()
        
        dataInputPage = createDataInputPage()
        scrollView.addSubview(dataInputPage)
        var maxHeight = CGFloat(0)

        for funci in model.funcs {
            let page = createTabulationPage(funci)
            if page.bounds.size.height > maxHeight {
                maxHeight = page.bounds.size.height
            }
            pages.append(page)
        }
        
        // Adding pages to the scrollview
        for (i, page) in pages.enumerated() {
            page.frame.origin.x = scrollView.bounds.width * CGFloat(i+1)
            page.frame.origin.y = 0
            scrollView.addSubview(page)
        }
        
        scrollView.contentSize.width = scrollView.bounds.size.width*CGFloat(pages.count)
        scrollView.contentSize.height = maxHeight
        scrollView.isPagingEnabled = true
    }
    func redrawTabPages () {
        
        for i in 0..<pages.count {
            pages[i].removeFromSuperview()
        }
        
        pages = [UIView]()
        var maxHeight = CGFloat(0)
        
        for funci in model.funcs {
            let page = createTabulationPage(funci)
            if page.bounds.size.height > maxHeight {
                maxHeight = page.bounds.size.height
            }
            pages.append(page)
        }
        
        // Adding pages to the scrollview
        for (i, page) in pages.enumerated() {
            page.frame.origin.x = scrollView.bounds.width * CGFloat(i+1)
            page.frame.origin.y = 0
            scrollView.addSubview(page)
        }
        
        scrollView.contentSize.width = scrollView.bounds.size.width*CGFloat(pages.count)
        scrollView.contentSize.height = maxHeight
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
        label1.text = ""
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
        cellN.text = "tabulation ="
        cellN.frame = CGRect(x: 0, y: yOffSet , width: page.bounds.width * CGFloat(0.4), height: headerHeight)
        page.addSubview(cellN)
        
        page.enterTabulationTextField = UITextField()
        page.enterTabulationTextField!.frame = CGRect(x: page.bounds.width * CGFloat(0.35), y: yOffSet , width: page.bounds.width * CGFloat(0.4), height: headerHeight)
        page.enterTabulationTextField!.layer.borderColor = UIColor.green.cgColor
        page.enterTabulationTextField!.layer.borderWidth = 1
        page.enterTabulationTextField!.layer.cornerRadius = 5
        page.enterTabulationTextField!.textAlignment = NSTextAlignment.center
        page.enterTabulationTextField!.returnKeyType = .done
        page.enterTabulationTextField!.delegate = self
        
        page.enterTabulationTextField?.text = String(model.tabulation)
        page.enterTabulationTextField?.tag = 3
        page.addSubview(page.enterTabulationTextField!)
        yOffSet += CGFloat(2)*headerHeight
        
        page.recalculateButton = UIButton()
        page.recalculateButton?.setTitle("Set", for: .normal)
        page.recalculateButton?.addTarget(self, action: #selector(calculateButtonTap), for: .touchUpInside)
        page.recalculateButton?.frame = CGRect(x: page.bounds.width * CGFloat(0.25), y: yOffSet , width: page.bounds.width * CGFloat(0.5), height: headerHeight)
        page.recalculateButton?.backgroundColor = UIColor.white
        page.recalculateButton?.setTitleColor( .blue , for: .normal)
        page.addSubview(page.recalculateButton!)
        yOffSet += headerHeight

        
        return page
    }
    
    func createTabulationPage (_ arg: (fu:(Double)->Double, literal: String, color: UIColor)) -> UIView {
        let page = UIView()
        page.frame.size = scrollView.bounds.size
        var yOffSet = CGFloat(0)
        
        let headerHeight : CGFloat = 35
        let header = createDefaultPageHeader(text: arg.literal, withHeight: headerHeight)
        header.textColor = arg.color
        page.addSubview(header)
        yOffSet += headerHeight
        
        
        let cellWidth = page.bounds.size.width / CGFloat(2)
        var X = model.a
        while X <= model.b {
            let XLabel = createDefaultCell()
            XLabel.frame = CGRect(x: 0, y: yOffSet, width: cellWidth, height: headerHeight)
            XLabel.text = String(X)
            page.addSubview(XLabel)
            
            let ValueLabel = createDefaultCell()
            ValueLabel.frame = CGRect(x: cellWidth, y: yOffSet, width: cellWidth, height: headerHeight)
            ValueLabel.text = String(arg.fu(X))
            page.addSubview(ValueLabel)

            yOffSet += headerHeight
            X += model.tabulation
        }
        
        page.bounds.size.height = yOffSet
        
        
        return page
        
    }
    
    func calculateButtonTap () {
        if dataInputPage.enterATextField?.layer.borderColor == UIColor.green.cgColor &&
            dataInputPage.enterBTextField?.layer.borderColor == UIColor.green.cgColor &&
            dataInputPage.enterTabulationTextField?.layer.borderColor == UIColor.green.cgColor {
            
            let a = Double((dataInputPage.enterATextField?.text)!)!
            let b = Double((dataInputPage.enterBTextField?.text)!)!
            let tab = Double(((dataInputPage.enterTabulationTextField?.text)!)!)!
            
            if b <= a {
                dataInputPage.enterATextField?.layer.borderColor = UIColor.red.cgColor
                dataInputPage.enterBTextField?.layer.borderColor = UIColor.red.cgColor
                return
            }
            model.a = a
            model.b = b
            model.tabulation = tab

            redrawTabPages()
            
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
        vc.funcs = model.funcs
        vc.navigationItem.title = "Graphs"
        }
    }
}

func roundDouble (_ arg: Double, toPrecision i: Int) -> Double{
    let a = pow(10,Double(i))
    return (round(arg * a))/a
}


