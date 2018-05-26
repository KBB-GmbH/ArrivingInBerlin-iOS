//
//  LanguageViewController.swift
//  Arriving
//
//  Created by anouk on 16/11/2017.
//  Copyright © 2017 anouk. All rights reserved.
//

import UIKit
import Localize_Swift
import PromiseKit

class HKWLanguageViewController: UIViewController {
    var english: UIButton = UIButton()
    var german: UIButton = UIButton()
    var french: UIButton = UIButton()
    var arabic: UIButton = UIButton()
    var farsi: UIButton = UIButton()
    var kurdish: UIButton = UIButton()
    var logo: UIImageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "language".localized()
        logo = UIImageView(frame: CGRect(x: (self.view.frame.size.width - 60)/2, y: 100, width: 60, height: 60))
        logo.image = #imageLiteral(resourceName: "arriving_logo")
        view.addSubview(logo)
        english = layoutButton(name: "english".localized(), location: 0)
        view.addSubview(english)
        french = layoutButton(name: "french".localized(), location: 1)
        view.addSubview(french)
        german = layoutButton(name: "german".localized(), location: 2)
        view.addSubview(german)
        arabic = layoutButton(name: "arabic".localized(), location: 3)
        view.addSubview(arabic)
        farsi = layoutButton(name: "farsi".localized(), location: 4)
        view.addSubview(farsi)
        kurdish = layoutButton(name: "kurdish".localized(), location: 5)
        view.addSubview(kurdish)
    }
    
    func layoutButton(name: String, location: Int) -> UIButton {
        let height = 50
        let padding = 0
        let width = (self.view.frame.size.width - 200.0) / 2.0
        
        let button = UIButton(frame: CGRect(x: Int(width), y: 190 + height * location + padding * location, width: 200, height: height))
        button.setTitle(name, for: .normal)
        button.setTitleColor(.black, for: .normal)
         button.setTitleColor(.purple, for: .selected)
        button.tag = location
        
        button.addTarget(self, action: #selector(languageSelected(sender:)), for: .touchUpInside)
        return button
    }
    
    public func languageSelected(sender: UIButton) {
        let keys = [LanguageKey.English, LanguageKey.French, LanguageKey.German, LanguageKey.Arabic, LanguageKey.Farsi, LanguageKey.Sorani]
        
        print("set language \(keys[sender.tag].rawValue)")
        UserDefaults.standard.setValue(keys[sender.tag].rawValue, forKey: "language")
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        firstly {
            DataStore.sharedInstance.refreshLocations(key: keys[sender.tag])
            }.then { array -> Void in
                Localize.setCurrentLanguage(keys[sender.tag].rawValue)
                self.title = "language".localized()
                self.setTabbarTitles()
                self.navigationController?.popViewController(animated: false)
                print(array)
            }.always {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }
    
    func setTabbarTitles() {
        self.tabBarController?.tabBar.items?[0].title = "map".localized()
        self.tabBarController?.tabBar.items?[1].title = "list".localized()
        self.tabBarController?.tabBar.items?[2].title = "info".localized()
        self.tabBarController?.tabBar.items?[3].title = "about".localized()
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
