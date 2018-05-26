//
//  HKWWelcomeViewController.swift
//  Arriving
//
//  Created by anouk on 17/11/2017.
//  Copyright © 2017 anouk. All rights reserved.
//

import UIKit

class HKWWelcomeViewController: UIViewController {
    @IBOutlet weak var nxt: UIButton!
    @IBOutlet weak var text1: UITextView!
    @IBOutlet weak var text2: UITextView!
    @IBOutlet weak var name: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        name.text = "main_title".localized()
        text1.text = "screen_one".localized()
        text2.text = "screen_two".localized()
        nxt.setTitle("next".localized(), for: .normal)
        nxt.styleForHKW()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
