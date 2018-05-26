//
//  HKWLanguageStartup.swift
//  Arriving
//
//  Created by anouk on 17/11/2017.
//  Copyright © 2017 anouk. All rights reserved.
//

import UIKit
import Localize_Swift

class HKWLanguageStartup: UIViewController {

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
        title = "Language".localized()
        logo = UIImageView(frame: CGRect(x: (self.view.frame.size.width - 60)/2, y: 80, width: 60, height: 60))
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
        let height = 60
        let padding = 0
        let width = (self.view.frame.size.width - 200.0) / 2.0
        
        let button = UIButton(frame: CGRect(x: Int(width), y: 180 + height * location + padding * location, width: 200, height: height))
        button.setTitle(name, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(.purple, for: .selected)
        button.tag = location
        
        button.addTarget(self, action: #selector(languageSelected(sender:)), for: .touchUpInside)
        return button
    }
    
    public func languageSelected(sender: UIButton) {
        let keys = [LanguageKey.English, LanguageKey.French, LanguageKey.German, LanguageKey.Arabic, LanguageKey.Farsi, LanguageKey.Sorani]
        Localize.setCurrentLanguage(keys[sender.tag].rawValue)
        print("set language \(keys[sender.tag].rawValue)")
        UserDefaults.standard.setValue(keys[sender.tag].rawValue, forKey: "language")
        //Go to the next VC
        performSegue(withIdentifier: "welcomeSegue", sender: self)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
