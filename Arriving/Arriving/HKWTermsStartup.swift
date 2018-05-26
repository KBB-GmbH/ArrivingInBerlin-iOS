
//
//  HKWTermsStartup.swift
//  Arriving
//
//  Created by anouk on 17/11/2017.
//  Copyright © 2017 anouk. All rights reserved.
//

import UIKit
import Localize_Swift

class HKWTermsStartup: UIViewController {

    @IBOutlet weak var introTxt: UITextView!
    @IBOutlet weak var termsTxt: UITextView!
    @IBOutlet weak var decline: UIButton!
    @IBOutlet weak var accept: UIButton!
    @IBOutlet weak var name: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        introTxt.text = "terms_text".localized()
        let text = "privacy_text".localized()
        decline.setTitle("terms_decline".localized(), for: .normal)
        accept.setTitle("terms_agree".localized(), for: .normal)
        accept.styleForHKW()
        decline.styleForHKW()
        name.text = "terms_title".localized()
        
        do {
            let html = "<div style='font-family:Helvetica Neue;font-size:17'>\(text)</div>"
            let str = try NSAttributedString(data:html.data(using: String.Encoding.unicode, allowLossyConversion: true)!, options: [NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType], documentAttributes: nil)
            termsTxt.styleForInfo(attrText: str)
        } catch {
            print(error)
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func accepted(_ sender: Any) {
        UserDefaults.standard.set(true, forKey: Terms.accepted.rawValue)
        performSegue(withIdentifier: "startupDone", sender: self)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
