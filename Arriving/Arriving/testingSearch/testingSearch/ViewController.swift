//
//  ViewController.swift
//  testingSearch
//
//  Created by anouk on 08/09/17.
//  Copyright © 2017 anouk. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {
    
    var search: UISearchController!


    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.purple
        let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "LocationSearchTable") as! LocationSearchController
        search = UISearchController(searchResultsController: locationSearchTable)
        search.searchResultsUpdater = locationSearchTable
        let searchBar = search!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Search for places"
        navigationItem.titleView = search?.searchBar
        search.hidesNavigationBarDuringPresentation = false
        search.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

