//
//  LocationSearchTable.swift
//  Arriving
//
//  Created by anouk on 08/09/17.
//  Copyright © 2017 anouk. All rights reserved.
//

import UIKit
import Mapbox

extension HKWLocationSearchTable : UISearchResultsUpdating {
    public func updateSearchResults(for searchController: UISearchController){
        guard let searchBarText = searchController.searchBar.text, let locs = allLocations else { return }
        matchingItems = locs.filter({ containSearchTerm(search: searchBarText, location: $0)})
        self.tableView.reloadData()
    }
    
    func containSearchTerm(search: String, location: Location)-> Bool{
        var containsKey = false
        guard var searchStr = location.title else {return containsKey}
        
        searchStr += " "
        searchStr += location.description
        searchStr += " "
        searchStr += DataStore.sharedInstance.categoryTitleForID(catID: location.categoryID)
        
        if searchStr.lowercased().range(of: search.lowercased()) != nil {
            containsKey = true
        }
        return containsKey
    }
}


class HKWLocationSearchTable: UITableViewController {
    var matchingItems:[Location] = []
    var allLocations: [Location]?
    var mapSearchDelegate:MapSearch? = nil
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matchingItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        let selectedItem = matchingItems[indexPath.row]
        cell.textLabel?.text = selectedItem.title!
        cell.detailTextLabel?.text = ""
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = matchingItems[indexPath.row]
        mapSearchDelegate?.showSearchResult(location: selectedItem)
        dismiss(animated: true, completion: nil)
    }
   
}
