//
//  HKWLocationView.swift
//  Arriving
//
//  Created by anouk on 27/09/17.
//  Copyright © 2017 anouk. All rights reserved.
//

import UIKit

protocol HKWLocationViewDelegate: class {
    func getWalkingDirection(_ location:Location)
    func goToMaps(_ location:Location)
}

class HKWLocationView: UIView {
    var delegate: HKWLocationViewDelegate?
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var popupButton: UIButton!
    @IBOutlet weak var popupText: UITextView!
    @IBOutlet weak var popupImage: UIImageView!
    @IBOutlet weak var popupTitle: UILabel!
    var location: Location?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        loadNib()
    }
    
    func loadNib(){
        let bundle = Bundle(for: type(of: self))
        let nibName = "HKWLocation"
        let nib = UINib(nibName: nibName, bundle: bundle)
        contentView = nib.instantiate(withOwner: self, options: nil).first as! UIView
        contentView.frame = bounds
        addSubview(contentView)
    }
    
    
    public func setValuesForLocation(location: Location) {
        popupTitle.text = location.title
        let descr : NSMutableString = "<div style='font-family:Helvetica Neue;font-size:14'>"
        
        if !(location.text == nil) {
            if !(location.text?.isEmpty)! {
                descr.append("\(location.text!) </br></br>")
            }
        }
        
        if !(location.address == nil) {
            if !(location.address?.isEmpty)! {
                let subA = location.address!.toLengthOf(length: 10).replacingOccurrences(of: "*", with: "")
                descr.append("<b>Address: </b> \(subA) </br>")
            }
        }
        
        if !(location.telefon == nil) {
            if !(location.telefon?.isEmpty)! {
                let subP = location.telefon!.toLengthOf(length: 8).replacingOccurrences(of: "*", with: "")
                descr.append("<b>Phone: </b> \(subP) </br> ")
            }
        }
        
        if !(location.link == nil) {
            if !(location.link!.isEmpty) {
            let subL = location.link!.toLengthOf(length: 10).replacingOccurrences(of: "*", with: "")
            print(subL)
            descr.append("<b>Website: </b> <a href=\(subL)>\(subL)</a> </br> ")
            }
        }
        
        descr.append("</div>")
        let htmlStr = descr as String
        
        do {
            let str = try NSAttributedString(data: htmlStr.data(using: String.Encoding.unicode, allowLossyConversion: true)!, options: [NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType], documentAttributes: nil)
            popupText.attributedText = str
            popupText.dataDetectorTypes = .all
        } catch {
            print(error)
        }
        
        self.location = location
    }
    
    @IBAction func publicTransport(_ sender: Any) {
        if(delegate != nil && location != nil) {
            delegate!.goToMaps(location!)
        }
    }
    
    @IBAction func walkRoute(_ sender: Any) {
        if(delegate != nil && location != nil) {
            delegate!.getWalkingDirection(location!)
        }
    }
    
}
