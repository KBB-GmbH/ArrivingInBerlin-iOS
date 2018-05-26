//
//  HKWAboutViewController.swift
//  Arriving
//
//  Created by anouk on 24/10/2017.
//  Copyright © 2017 anouk. All rights reserved.
//

import UIKit
import Localize_Swift

class HKWAboutViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var itemsList: UITableView!
    var sections = ["Settings", "About"]
    var items = [["language".localized(), "contact".localized()], ["privacy_title".localized(), "terms_title".localized(), "legal_title".localized(), "project_title".localized()]]
    let reuseIdentifier = "catCellTable"
    
    override func viewDidLoad() {
        super.viewDidLoad()
         NotificationCenter.default.addObserver(self, selector: #selector(setText), name: NSNotification.Name(LCLLanguageChangeNotification), object: nil)
        self.title = "about".localized()
        let frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height - 100.0)
        itemsList = UITableView(frame: frame, style: .plain)
        itemsList.dataSource = self
        itemsList.delegate = self
        let nib = UINib(nibName: "CategoryTableCell", bundle: nil)
        itemsList.register(nib, forCellReuseIdentifier: reuseIdentifier)
        itemsList.backgroundColor = UIColor.clear
        view.addSubview(itemsList)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        setText()
        itemsList.reloadData()
    }
    
    func setText() {
        items = [["language".localized(), "contact".localized()], ["privacy_title".localized(), "terms_title".localized(), "legal_title".localized(), "project_title".localized()]]
         self.title = "about".localized()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.section == 1) {
            let controller = HKWPrivacyViewController()
            switch indexPath.row {
            case 0:
                controller.selection = 0
                break;
            case 1:
                controller.selection = 1
                break;
            case 2:
                controller.selection = 2
                break;
            case 3:
                controller.selection = 3
                break;
            default:
                controller.selection = 0
                break;
            }
            self.navigationController?.pushViewController(controller, animated: true)
        } else {
            switch indexPath.row {
            case 0:
                let controller = HKWLanguageViewController()
                self.navigationController?.pushViewController(controller, animated: true)
                break;
            case 1:
                let controller = HKWContactViewController()
                 self.navigationController?.pushViewController(controller, animated: true)
                break;
            default:
               let controller = HKWLanguageViewController()
                self.navigationController?.pushViewController(controller, animated: true)
                break;
            }
           
        }
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier,
                                                 for: indexPath as IndexPath) as! CategoryTableCell
        cell.cleanCell()
        cell.imageView?.image = nil
        cell.titleLabel.text = items[indexPath.section][indexPath.row]
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items[section].count
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
