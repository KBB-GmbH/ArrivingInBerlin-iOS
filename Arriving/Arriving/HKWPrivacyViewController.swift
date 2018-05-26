//
//  HKWPrivacyViewController.swift
//  Arriving
//
//  Created by anouk on 24/10/2017.
//  Copyright © 2017 anouk. All rights reserved.
//

import UIKit
import Localize_Swift

extension UITextView {
    func styleForInfo(attrText: NSAttributedString) {
        self.isUserInteractionEnabled = true
        self.isEditable = false
        self.isScrollEnabled = true
        self.attributedText = attrText
    }
}


class HKWPrivacyViewController: UIViewController, UIScrollViewDelegate {
    var text: String = ""
    var titleTxt: String = ""
    var selection: Int = 0
    var txt: UITextView = UITextView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: NSNotification.Name(LCLLanguageChangeNotification), object: nil)

        view.backgroundColor = .white
        setTitleText(selection: selection)
        title = titleTxt
        let txt = UITextView(frame: CGRect(x: 30, y: 80, width: self.view.frame.width - 60.0, height: self.view.frame.height - 100))
        do {
            let html = "<div style='font-family:Helvetica Neue;font-size:18'>\(text)</div>"
            let str = try NSAttributedString(data:html.data(using: String.Encoding.unicode, allowLossyConversion: true)!, options: [NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType], documentAttributes: nil)
            txt.styleForInfo(attrText: str)
        } catch {
            print(error)
        }
        view.addSubview(txt)
    }
    
    func setText() {
        setTitleText(selection: selection)
        do {
            let html = "<div style='font-family:Helvetica Neue;font-size:18'>\(text)</div>"
            let str = try NSAttributedString(data:html.data(using: String.Encoding.unicode, allowLossyConversion: true)!, options: [NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType], documentAttributes: nil)
            txt.styleForInfo(attrText: str)
        } catch {
            print(error)
        }
    }
    
    func setTitleText(selection: Int) {
        switch selection {
        case 0:
            text = "privacy_text".localized()
            titleTxt = "privacy_title".localized()
            break;
        case 1:
            text = "terms_details_txt".localized()
            titleTxt = "terms_title".localized()
            break;
        case 2:
            text = "legal_text".localized()
            titleTxt = "legal_title".localized()
            break;
        case 3:
            text = "project_text".localized()
            titleTxt = "project_title".localized()
            break;
        default:
            text = "privacy_text".localized()
            titleTxt = "privacy_title".localized()
            break;
        }
    
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
