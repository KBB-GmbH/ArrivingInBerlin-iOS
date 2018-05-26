//
//  HKWStartViewController.swift
//  Arriving
//
//  Created by anouk on 18/11/2017.
//  Copyright © 2017 anouk. All rights reserved.
//

import UIKit

enum Terms: String {
    case accepted = "accepted_terms"
}

class HKWStartViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        let terms = UserDefaults.standard.bool(forKey: Terms.accepted.rawValue)
        if (terms){
            performSegue(withIdentifier: "mainSegue", sender: self)
        } else {
            performSegue(withIdentifier: "langSegue", sender: self)
        }
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
