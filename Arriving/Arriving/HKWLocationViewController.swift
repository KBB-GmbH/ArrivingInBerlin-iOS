//
//  HKWLocationViewController.swift
//  Arriving
//
//  Created by anouk on 11/09/17.
//  Copyright © 2017 anouk. All rights reserved.
//

import UIKit
import PromiseKit
import Localize_Swift

class HKWLocationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var locationList: UITableView!
    let reuseIdentifier = "locationCell"
    var locations: Array<Location> = []
    public var categoryID: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
         NotificationCenter.default.addObserver(self, selector: #selector(getLocations), name: NSNotification.Name(LCLLanguageChangeNotification), object: nil)
        self.title = DataStore.sharedInstance.categoryTitleForID(catID: categoryID)
        locationList = configureTable()
        view.addSubview(locationList)
        let image = #imageLiteral(resourceName: "Map")
        let btn = UIButton(frame: CGRect(x: 0, y: 8, width: 25, height: 25))
        btn.tintColor = .white
        btn.setImage(image, for: .normal)
        btn.addTarget(self, action: #selector(HKWLocationViewController.showMap), for: .touchUpInside)
        let mapButton = UIBarButtonItem(customView: btn)
        navigationItem.setRightBarButton(mapButton, animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getLocations()
    }
    
    func configureTable() -> UITableView {
        let frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height - 44.0)
        let locationTable = UITableView(frame: frame, style: .plain)
        locationTable.dataSource = self
        locationTable.delegate = self
        let nib = UINib(nibName: "LocationTableCell", bundle: nil)
        locationTable.register(nib, forCellReuseIdentifier: reuseIdentifier)
        locationTable.backgroundColor = UIColor.white
        return locationTable
    }

    func showMap(){
        if let vc = getMapController(), let cat = Category(rawValue: categoryID) {
            vc.showLocationsForCategory(category: cat)
        }
        self.tabBarController?.selectedIndex = 0
    }
    
    func showSelected(location: Location){
        if let vc = getMapController() {
            vc.showPopup = true
            vc.showSelectedLocation(location: location)
        }
        self.tabBarController?.selectedIndex = 0
    }
    
    func getMapController() -> HKWMapViewController? {
        guard let tab = self.tabBarController, let nav = tab.childViewControllers[0] as? UINavigationController, let vc = nav.childViewControllers[0] as? HKWMapViewController else { return nil }
        return vc
    }
    
    func getLocations(){
        let lang = UserDefaults.standard.value(forKey: "language") as? String ?? "en"
        let languageKey = LanguageKey(rawValue: lang)!
        firstly {
            DataStore.sharedInstance.getLocations(key: languageKey)
            }.then { array -> Void in
                self.locations = array.filter({ $0.categoryID == self.categoryID})
            }.always {
               self.locationList.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.row == 0) {
            showMap()
        } else {
            let index = indexPath.row - 1
            showSelected(location: locations[index])
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
 
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier,
                                                 for: indexPath as IndexPath) as! LocationTableCell
        cell.cleanCell()
        
        if (indexPath.row == 0){
            cell.titleLabel.text = "all".localized()
        } else {
            let index = indexPath.row - 1
            cell.titleLabel.text = locations[index].title
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (categoryID == 14 || categoryID == 8) {
            return 1
        } else {
            return locations.count + 1
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

