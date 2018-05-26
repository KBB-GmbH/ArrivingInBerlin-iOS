//
//  HKWContactViewController.swift
//  Arriving
//
//  Created by anouk on 24/10/2017.
//  Copyright © 2017 anouk. All rights reserved.
//

import UIKit
import Localize_Swift
import MessageUI

class HKWContactViewController: UIViewController, MFMailComposeViewControllerDelegate {
    var titleLabel: UILabel!
    var text: UITextView!
    var emailBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
          NotificationCenter.default.addObserver(self, selector: #selector(languageChange), name: NSNotification.Name(LCLLanguageChangeNotification), object: nil)
          view.backgroundColor = .white
        
        titleLabel = UILabel(frame: CGRect(x: 20, y: 75, width: view.frame.size.width - 40 , height: 60.0))
        titleLabel.font = UIFont(name: "HelveticaNeue", size: 22)
        titleLabel.text = "contact".localized()
        titleLabel.textAlignment = .center
        view.addSubview(titleLabel)
        
        text = UITextView(frame: CGRect(x: 20, y: 150.0, width: view.frame.size.width - 40, height: 150.0))
        text.text = "contact_text".localized()
        text.font = UIFont(name: "HelveticaNeue", size: 17)
        text.textAlignment = .center
        text.isUserInteractionEnabled = false
        view.addSubview(text)
        
        emailBtn = UIButton(frame: CGRect(x: 80, y: 320, width: view.frame.size.width - 160, height: 60.0))
        emailBtn.setTitle("send_email".localized(), for: .normal)
        emailBtn.addTarget(self, action: #selector(sendEmail), for: .touchUpInside)
        emailBtn.styleForHKW()
        view.addSubview(emailBtn)
        // Do any additional setup after loading the view.
    }

    func sendEmail() {
        guard MFMailComposeViewController.canSendMail() else {
            sendPopup()
            return
        }
        
        let composeVC = MFMailComposeViewController()
        composeVC.mailComposeDelegate = self
        composeVC.setToRecipients(["arriving-in-berlin@hkw.de"])
        composeVC.setSubject("Feedback iOS App")
        present(composeVC, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }

    func sendPopup() {
        let alert = UIAlertController(title: "email_error".localized(), message: "email_error_message".localized(), preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok".localized(), style: .default, handler: nil)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func languageChange() {
        titleLabel.text = "contact".localized()
        text.text = "contact_text".localized()
        emailBtn.setTitle("send".localized(), for: .normal)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
