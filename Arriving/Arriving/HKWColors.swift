//
//  HKWColors.swift
//  Arriving
//
//  Created by anouk on 05/09/17.
//  Copyright © 2017 anouk. All rights reserved.
//

import UIKit
import Foundation

extension UIButton {
    func styleForHKW() {
        layer.backgroundColor = UIColor.init(red: 135/256, green: 182/256, blue: 182/256, alpha: 1.0).cgColor
        layer.cornerRadius = 8
        layer.masksToBounds = true
        setTitleColor(UIColor.white, for: .normal)
         titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 20)
    }
}

extension UIColor  {
    public class func hkwDarkGreen() -> UIColor {
//        return UIColor(red: 54/256, green: 113/256, blue: 113/256, alpha: 1.0)
        return UIColor.white
    }
    
    public class func hkwMediumGreen() -> UIColor {
        return UIColor.init(red: 135/256, green: 182/256, blue: 182/256, alpha: 1.0)
    }
    
    public class func hkwLightGreen() -> UIColor {
        return UIColor(red: 223/256, green: 236/256, blue: 236/256, alpha: 1.0)
    }
    
    public class func hkwUltraLightGreen() -> UIColor {
       return UIColor(red: 22/256, green: 46/256, blue: 46/256, alpha: 1.0)
    }
    
    public class func hkwUltraDarkGreen() -> UIColor {
        return UIColor(red: 229/256, green: 240/256, blue: 240/256, alpha: 1.0)
    }

}
