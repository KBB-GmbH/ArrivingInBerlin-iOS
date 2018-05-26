//
//  HKWListViewController.swift
//  Arriving
//
//  Created by anouk on 11/09/17.
//  Copyright © 2017 anouk. All rights reserved.
//

import UIKit
import Localize_Swift

class HKWListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var categories: UITableView!
    var categoryList = [1,2,3,4,5,6,7,8,9,10,12,13,14]
    let reuseIdentifier = "catCellTable"
    
    override func viewDidLoad() {
        super.viewDidLoad()
          NotificationCenter.default.addObserver(self, selector: #selector(reload), name: NSNotification.Name(LCLLanguageChangeNotification), object: nil)
        self.title = "categories".localized()
        let frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height - 44.0)
        categories = UITableView(frame: frame, style: .plain)
        categories.dataSource = self
        categories.delegate = self
        let nib = UINib(nibName: "CategoryTableCell", bundle: nil)
        categories.register(nib, forCellReuseIdentifier: reuseIdentifier)
        categories.backgroundColor = UIColor.clear
        view.addSubview(categories)
    }

    func reload() {
        self.title = "categories".localized()
        categories.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let new = HKWLocationViewController()
        new.categoryID = categoryList[indexPath.row]
        self.navigationController?.pushViewController(new, animated: true)

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier,
                                                      for: indexPath as IndexPath) as! CategoryTableCell
        cell.cleanCell()
        cell.titleLabel.text = DataStore.sharedInstance.categoryTitleForID(catID: categoryList[indexPath.row])
        cell.icon.image = DataStore.sharedInstance.getImageForCategory(category: Category(rawValue: categoryList[indexPath.row])!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return categoryList.count
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

