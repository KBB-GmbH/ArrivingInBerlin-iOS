//
//  HKWInfoViewController.swift
//  Arriving
//
//  Created by anouk on 24/10/2017.
//  Copyright © 2017 anouk. All rights reserved.
//

import UIKit
import Localize_Swift

extension UITextView {
    func styleForInfo(text: String) {
        self.isUserInteractionEnabled = false
        self.isScrollEnabled = false
        self.font = UIFont.systemFont(ofSize: 15.0)
        self.text = text.localized()
    }
}

class HKWInfoViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet var sv: UIScrollView!
    let startHeight = 20.0
    let padding = 5.0
    let paddingLarge = 10.0
    let imHeight: Double = 52.0
    let imWidth: Double = 40.0
    let textHeight: Double = 75.0
    let textWidth: Double = 300.0
    var general =  UILabel()
    var final =  UILabel()
    var l1 = UITextView()
    var l2 = UITextView()
    var l3 = UITextView()
    var l4 = UITextView()
    var l5 = UITextView()
    var l6 = UITextView()
    var l7 = UITextView()
    var l8 = UITextView()
    var l9 = UITextView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
         NotificationCenter.default.addObserver(self, selector: #selector(setText), name: NSNotification.Name(LCLLanguageChangeNotification), object: nil)
        var heightIncr = 1.0
        title = "info".localized()
        sv.delegate = self
        sv.contentSize = CGSize(width: view.frame.size.width, height: 2500)
        let x: Double = Double((view.frame.size.width - 300.0) / 2)
        let xIm =  Double((view.frame.size.width - 40.0) / 2)
        
        general = UILabel(frame: CGRect(x: x, y: startHeight, width: 300.0, height: textHeight * 2))
        general.numberOfLines = 8
        general.text = "info_general".localized()
        heightIncr += 1.0
        
        let wifiwdth = CGFloat(self.view.frame.size.width/2) - CGFloat(imHeight/2)
        let imOne = UIImageView(frame: CGRect(x: Double(wifiwdth), y: startHeight + textHeight * heightIncr + paddingLarge, width: imHeight , height: imHeight))
        imOne.image = #imageLiteral(resourceName: "wifi")
        imOne.sizeThatFits(imOne.image!.size)
        
        l1 = UITextView(frame: CGRect(x: x, y: startHeight + padding + textHeight * heightIncr + paddingLarge + imHeight, width: textWidth, height: textHeight * 2.5))
        l1.styleForInfo(text: "info_internet")
        heightIncr += 2.5
        
        let imTwo = UIImageView(frame: CGRect(x: xIm, y: startHeight + paddingLarge * 2 + padding + textHeight * heightIncr + imHeight, width: imWidth, height: imHeight))
        imTwo.image = #imageLiteral(resourceName: "counseling_services_for_refugees")
        imTwo.sizeThatFits(imTwo.image!.size)
        
        l2 = UITextView(frame: CGRect(x: x, y: startHeight + padding * 2 + paddingLarge * 2 + imHeight * 2 + textHeight * heightIncr, width:textWidth, height: textHeight * 4))
        l2.styleForInfo(text: "info_counseling")
        heightIncr += 4
        
        let imThree = UIImageView(frame: CGRect(x: xIm, y: startHeight + paddingLarge * 3 + padding * 2 + textHeight * heightIncr + imHeight * 2, width: imWidth, height: imHeight))
        imThree.image = #imageLiteral(resourceName: "doctors_gynaecologist_farsi")
        imThree.sizeThatFits(imTwo.image!.size)
        
        l3 = UITextView(frame: CGRect(x: x, y: startHeight + paddingLarge * 3 + padding * 2 + textHeight * heightIncr + imHeight * 3, width: textWidth, height: textHeight))
        l3.styleForInfo(text: "info_doctors")
        heightIncr += 1.0
        
        let imFour = UIImageView(frame: CGRect(x:xIm, y: startHeight + paddingLarge * 4 + padding * 3 + textHeight * heightIncr + imHeight * 3, width: imWidth, height: imHeight))
        imFour.image = #imageLiteral(resourceName: "lawyers_residence_and_asylum_law")
        imFour.sizeThatFits(imTwo.image!.size)
        
        l4 = UITextView(frame: CGRect(x: x, y: startHeight + paddingLarge * 4 + padding * 3 + textHeight * heightIncr + imHeight * 4, width: textWidth, height: textHeight))
        l4.styleForInfo(text: "info_laywers")
        heightIncr += 1.0
        
        let imFive = UIImageView(frame: CGRect(x: xIm, y: startHeight + paddingLarge * 5 + padding * 4 + textHeight * heightIncr + imHeight * 4, width: imWidth, height: imHeight))
        imFive.image = #imageLiteral(resourceName: "public_libraries")
        
        l5 = UITextView(frame: CGRect(x: x, y: startHeight + paddingLarge * 5 + padding * 4 + textHeight * heightIncr + imHeight * 5, width: textWidth, height: textHeight * 2))
        l5.styleForInfo(text: "info_libraries")
        heightIncr += 2
        
        let i6 = UIImageView(frame: CGRect(x: xIm, y: startHeight + paddingLarge * 6 + padding * 5 + textHeight * heightIncr + imHeight * 5, width: imWidth, height: imHeight))
        i6.image = #imageLiteral(resourceName: "german_language_classes")
        
        l6 = UITextView(frame: CGRect(x: x, y: startHeight + paddingLarge * 6 + padding * 5 + textHeight * heightIncr + imHeight * 6, width: textWidth, height: textHeight * 2.5))
        l6.styleForInfo(text: "info_german_courses")
        heightIncr += 2.5
        
        
        let i7 = UIImageView(frame: CGRect(x: xIm, y: startHeight + paddingLarge * 7 + padding * 6 + textHeight * heightIncr + imHeight * 6, width: imWidth, height: imHeight))
        i7.image = #imageLiteral(resourceName: "public_authorities")
        
        l7 = UITextView(frame: CGRect(x: x, y: startHeight + paddingLarge * 7 + padding * 6 + textHeight * heightIncr + imHeight * 7, width: textWidth, height: textHeight * 2))
        l7.styleForInfo(text: "info_gov")
        heightIncr += 2.0
        
        let i8 = UIImageView(frame: CGRect(x: xIm, y: startHeight + paddingLarge * 8 + padding * 7 + textHeight * heightIncr + imHeight * 7, width: imWidth, height: imHeight))
        i8.image = #imageLiteral(resourceName: "sports_and_freetime")
        
        l8 = UITextView(frame: CGRect(x: x, y: startHeight + paddingLarge * 8 + padding * 7 + textHeight * heightIncr + imHeight * 8, width: textWidth, height: textHeight * 2))
        l8.styleForInfo(text: "info_sports")
        heightIncr += 2.0
        
        let i9 = UIImageView(frame: CGRect(x: xIm, y: startHeight + paddingLarge * 9 + padding * 8 + textHeight * heightIncr + imHeight * 8, width: imWidth, height: imHeight))
        i9.image = #imageLiteral(resourceName: "shopping_and_food")
        
        l9 = UITextView(frame: CGRect(x: x, y: startHeight + paddingLarge * 9 + padding * 8 + textHeight * heightIncr + imHeight * 9, width: textWidth, height: textHeight))
        l9.styleForInfo(text: "info_shopping")
        heightIncr += 1.0
        
        final = UILabel(frame: CGRect(x: x, y: startHeight + paddingLarge * 10 + padding * 9 + textHeight * heightIncr + imHeight * 9, width: 300.0, height: textHeight * 2))
        final.numberOfLines = 8
        final.text = "info_final".localized()
        
        sv.addSubview(general)
        sv.addSubview(imOne)
        sv.addSubview(l1)
        sv.addSubview(imTwo)
        sv.addSubview(l2)
        sv.addSubview(imThree)
        sv.addSubview(l3)
        sv.addSubview(imFour)
        sv.addSubview(l4)
        sv.addSubview(imFive)
        sv.addSubview(l5)
        sv.addSubview(i6)
        sv.addSubview(l6)
        sv.addSubview(i7)
        sv.addSubview(l7)
        sv.addSubview(i8)
        sv.addSubview(l8)
        sv.addSubview(i9)
        sv.addSubview(l9)
        sv.addSubview(final)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        general.text = "info_general".localized()
        l1.styleForInfo(text: "info_internet")
        l2.styleForInfo(text: "info_counseling")
        l3.styleForInfo(text: "info_doctors")
        l4.styleForInfo(text: "info_laywers")
        l5.styleForInfo(text: "info_libraries")
        l6.styleForInfo(text: "info_german_courses")
        l7.styleForInfo(text: "info_gov")
        l8.styleForInfo(text: "info_sports")
        l9.styleForInfo(text: "info_shopping")
        final.text = "info_final".localized()
    }
    
    func setText(){
        title = "info".localized()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }


}
