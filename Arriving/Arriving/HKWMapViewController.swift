//
//  ViewController.swift
//  Arriving
//
//  Created by anouk on 08/09/17.
//  Copyright © 2017 anouk. All rights reserved.
//

import UIKit
import Mapbox
import MapboxDirections
import PromiseKit
import Localize_Swift


extension String {
    
    func toLengthOf(length:Int) -> String {
        if length <= 0 {
            return self
        } else if let to = self.index(self.startIndex, offsetBy: length, limitedBy: self.endIndex) {
            return self.substring(from: to)
            
        } else {
            return ""
        }
    }
}

protocol MapSearch {
    func showSearchResult(location:Location)
}

extension HKWMapViewController: HKWLocationViewDelegate, UIActionSheetDelegate {
    func getWalkingDirection(_ location:Location) {
        if routeLine != nil {
            if let map = self.myMapView {
                map.removeAnnotation(routeLine!)
            }
        }
       let directions = Directions.shared
        let current = myMapView?.userLocation?.coordinate ?? CLLocationCoordinate2D(latitude: 52.516889, longitude: 13.388389)
        let waypoints = [
            Waypoint(coordinate: current, name: "Current Location"),
            Waypoint(coordinate: location.coordinate, name: location.title),
            ]
        let options = RouteOptions(waypoints: waypoints, profileIdentifier: .walking)
        options.includesSteps = true
        
        let _ = directions.calculate(options) { (waypoints, routes, error) in
            guard error == nil else {
                print("Error calculating directions: \(error!)")
                return
            }
            
            if let route = routes?.first, let map = self.myMapView{
                if route.coordinateCount > 0 {
                    // Convert the route’s coordinates into a polyline.
                    var routeCoordinates = route.coordinates!
                    self.routeLine = MGLPolyline(coordinates: &routeCoordinates, count: route.coordinateCount)
                    // Add the polyline to the map and fit the viewport to the polyline.
                    map.addAnnotation(self.routeLine!)
                    map.setVisibleCoordinates(&routeCoordinates, count: route.coordinateCount, edgePadding: .zero, animated: true)
                }
            }
        }
    }
    
    func goToMaps(_ location:Location) {
        let alert = UIAlertController(title: "google_maps_popup".localized(), message: "", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok".localized(), style: UIAlertActionStyle.default, handler: { _ in
            self.openMaps(location)
        }))
        
        alert.addAction(UIAlertAction(title: "cancel".localized(), style: UIAlertActionStyle.cancel, handler:nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func openMaps(_ location:Location) {
        if UIApplication.shared.canOpenURL(URL(string: "comgooglemaps://")!)
        {
            let urlString = "http://maps.google.com/?daddr=\(location.coordinate.latitude),\(location.coordinate.longitude)&directionsmode=driving"
            UIApplication.shared.openURL(URL(string: urlString)!)
        }
        else
        {
            let urlString = "http://maps.apple.com/maps?daddr=\(location.coordinate.latitude),\(location.coordinate.longitude)&dirflg=d"
            
            UIApplication.shared.openURL(URL(string: urlString)!)
        }
    }
}

class HKWMapViewController: UIViewController, MGLMapViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    var routeLine: MGLPolyline?
    var progressView: UIProgressView?
    var downloadButton: UIButton!
    var locationButton: UIButton!
    var popupWindow: HKWLocationView!
    var search: UISearchController!
    var showCategoryID: Int?
    var myMapView: MGLMapView?
    var locations: Array<Location> = []
    var categories: UICollectionView!
    var locationSearchTable: HKWLocationSearchTable?
    let ids = [1,2,3,4,5,6,7,8,9,10,12,13,14]
    var showPopup = false
    private let reuseIdentifier = "categoryCell"
    private let CAT_WIDTH = 170.0
    private let CAT_HEIGHT = 60.0
    private let CELL_HEIGHT = 60.0
    private let CELL_WIDTH = 160.0
    private let margin = 10.0
    private let baseZoomLevel: Double = 12.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
          NotificationCenter.default.addObserver(self, selector: #selector(languageChange), name: NSNotification.Name(LCLLanguageChangeNotification), object: nil)
        if let lang = UserDefaults.standard.value(forKey: "language") as? String {
            Localize.setCurrentLanguage(lang)
        }
        
        myMapView = configureAndLoadMapview(lat: 52.516889, lon: 13.388389)
        view.addSubview(myMapView!)
        UITextView.appearance().linkTextAttributes = [ NSForegroundColorAttributeName: UIColor.blue ]
        view.backgroundColor = UIColor.hkwDarkGreen()
        
        categories = addCategoriesView()
        view.addSubview(categories)
    
        downloadButton = addDownloadButton()
        view.addSubview(downloadButton)
        
        locationButton = addLocationButton()
        view.addSubview(locationButton)
        
        setupSearch()
        
        popupWindow = HKWLocationView(frame: CGRect(x: 0, y: 70, width: view.frame.size.width, height: 250))
        view.addSubview(popupWindow)
        popupWindow.isHidden = true
        popupWindow?.delegate = self
        popupWindow.popupButton.addTarget(self, action: #selector(HKWMapViewController.closePopupFromButton), for: .touchUpInside)
        
        setTabbarTitles()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        showPopup = false
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        locations = []
        if !showPopup {
            closePopup(zoomBack: true)
        }
        categories.reloadData()
        addLocations()
    }
    
    func setTabbarTitles() {
        self.tabBarController?.tabBar.items?[0].title = "map".localized()
        self.tabBarController?.tabBar.items?[1].title = "list".localized()
        self.tabBarController?.tabBar.items?[2].title = "info".localized()
        self.tabBarController?.tabBar.items?[3].title = "about".localized()
    }
    
    func addDownloadButton() -> UIButton {
        let button = UIButton(frame: CGRect(x: 80, y: 85, width: 50, height: 50))
        button.layer.cornerRadius = 6
        button.layer.masksToBounds = true
        button.imageEdgeInsets = UIEdgeInsetsMake(0,0,0,0);
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(HKWMapViewController.downloadMap), for: .touchUpInside)
        button.setImage(UIImage(named: "download")?.withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }
    
    func addLocationButton() -> UIButton {
        let button = UIButton(frame: CGRect(x: 15, y: 85, width: 50, height: 50))
        button.layer.cornerRadius = 6
        button.layer.masksToBounds = true
        button.imageEdgeInsets = UIEdgeInsetsMake(10,10,10,10);
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(HKWMapViewController.showUserLocation), for: .touchUpInside)
        button.setImage(UIImage(named: "location")?.withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }
    
    func addCategoriesView() -> UICollectionView {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        
        layout.itemSize = CGSize(width: CAT_WIDTH, height: CAT_HEIGHT)
        layout.scrollDirection = .horizontal
        
        let frame = CGRect(x: 0, y: view.frame.size.height-150, width: view.frame.size.width, height:  70)
        let cat = UICollectionView(frame: frame, collectionViewLayout: layout)
        cat.dataSource = self
        cat.delegate = self
        let nib = UINib(nibName: "CategoryCell", bundle: nil)
        cat.register(nib, forCellWithReuseIdentifier: "categoryCell")
        
        cat.backgroundColor = UIColor.clear
        cat.allowsSelection = true
        cat.isScrollEnabled = true
        cat.isPagingEnabled = true
        cat.showsHorizontalScrollIndicator = true
        cat.showsVerticalScrollIndicator = false
        return cat
    }
    
    
    func setupSearch(){
        locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "LocationSearchTable") as? HKWLocationSearchTable
        locationSearchTable!.allLocations = locations
        locationSearchTable!.mapSearchDelegate = self
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
    
    func configureAndLoadMapview(lat: CLLocationDegrees, lon: CLLocationDegrees) -> MGLMapView{
        //setup mapbox:
        let url = URL(string: "mapbox://styles/mapbox/streets-v10")
        let frame = CGRect(x: view.bounds.origin.x, y: view.bounds.origin.y, width: view.frame.size.width, height: view.frame.size.height)
        let mapView = MGLMapView(frame: frame , styleURL: url)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.setCenter(CLLocationCoordinate2D(latitude: lat, longitude: lon), zoomLevel: baseZoomLevel, animated: false)
        mapView.delegate = self
        mapView.showsUserLocation = true
//        mapView.userTrackingMode = .follow
        
        return mapView
    }
    
    func addLocations(){
        let lang = UserDefaults.standard.value(forKey: "language") as? String ?? "en"
        print(lang)
        let languageKey = LanguageKey(rawValue: lang)!
        firstly {
            DataStore.sharedInstance.getLocations(key: languageKey)
            }.then { array -> Void in
                self.locations = array
                if (self.locationSearchTable != nil) {
                    self.locationSearchTable!.allLocations = self.locations
                    if let cid = self.showCategoryID, let cat =  Category(rawValue: cid){
                        self.showLocationsForCategory(category: cat)
                    }
                }
                print(array)
            }.always {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }
    
    func languageChange() {
        removeAnnotationsFromView()
        addLocations()
    }
    
    //**************************** Button Actions ******************************************//
    func downloadMap() {
        NotificationCenter.default.addObserver(self, selector: #selector(offlinePackProgressDidChange), name: NSNotification.Name.MGLOfflinePackProgressChanged, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(offlinePackDidReceiveError), name: NSNotification.Name.MGLOfflinePackError, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(offlinePackDidReceiveMaximumAllowedMapboxTiles), name: NSNotification.Name.MGLOfflinePackMaximumMapboxTilesReached, object: nil)
        
        let alert = UIAlertController(title: "".localized(), message: "download_button_message".localized(), preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok".localized(), style: .default, handler: {_ in self.startOfflinePackDownload()})
        alert.addAction(ok)
        alert.addAction(UIAlertAction(title: "cancel".localized(), style: .cancel, handler: nil))
    
        self.present(alert, animated: true, completion: nil)
    }
    
    func showUserLocation() {
        if let map = myMapView, let loc = map.userLocation {
            myMapView!.setCenter(loc.coordinate, zoomLevel: baseZoomLevel, animated: false)
        }
    }
    
    func closePopup(zoomBack:Bool) {
        if !popupWindow.isHidden {
            popupWindow.isHidden = true
        }
        
        if let _ = myMapView {
            if zoomBack {
                myMapView!.setCenter(myMapView!.centerCoordinate, zoomLevel: baseZoomLevel, animated: false)
            }
        }
    }
    
    func closePopupFromButton() {
        closePopup(zoomBack: false)
    }
    
    //**************************** Mapview Functions ******************************************//
    
    public func removeAnnotationsFromView() {
        guard let map = myMapView else {
            return
        }
        
        if let annos = map.annotations {
            map.removeAnnotations(annos)
        }
    }
    
    public func showLocationsForCategory(category: Category) {
        guard let map = myMapView else {
            return
        }
        
        closePopup(zoomBack: true)
        
        if let annos = map.annotations {
            map.removeAnnotations(annos)
        }
        
        let cat = locations.filter({ $0.category == category})
        map.addAnnotations(cat)
    }
    
    func showMarkers(markers: Dictionary<String, Any>){
        print("show markers")
        
    }
    
    func mapView(_ mapView: MGLMapView, imageFor annotation: MGLAnnotation) -> MGLAnnotationImage? {
        if let a = annotation as? Location {
            var annotationImage = mapView.dequeueReusableAnnotationImage(withIdentifier: "icon_\(a.categoryID)")
            if annotationImage == nil {
                var image = DataStore.sharedInstance.getImageForCategory(category: a.category)
                image = image.withAlignmentRectInsets(UIEdgeInsets(top: 10, left: 10, bottom: image.size.height/2, right: 10))
                annotationImage = MGLAnnotationImage(image: image, reuseIdentifier: "icon_\(a.categoryID)")
            
            }
            return annotationImage
        }
        return nil
    }
    

    // Use the default marker. See also: our view annotation or custom marker examples.
    func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
        return nil
    }
    
    // Allow callout view to appear when an annotation is tapped.
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
   
        if let a = annotation as? Location {
            popupWindow?.setValuesForLocation(location: a)
        }
        
        popupWindow?.isHidden = false
        let lat = annotation.coordinate.latitude + 0.0039
        mapView.setCenter(CLLocationCoordinate2D(latitude: lat, longitude: annotation.coordinate.longitude), zoomLevel: 15, animated: false)
        return false
    }
    
    func mapView(_ mapView: MGLMapView, strokeColorForShapeAnnotation annotation: MGLShape) -> UIColor {
        // Give our polyline a unique color by checking for its `title` property
        return .red
    }
    

    //**************************** Category Picker ******************************************//
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        
        
        return UIEdgeInsetsMake(-5, 5, 15, 5)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return ids.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier,
                                                      for: indexPath as IndexPath) as! CategoryCollectionViewCell
        cell.cleanCell()
        cell.titleLabel.text = DataStore.sharedInstance.categoryTitleForID(catID: ids[indexPath.row])
        cell.icon.image = DataStore.sharedInstance.getImageForCategory(category: Category(rawValue: ids[indexPath.row])!)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        closePopup(zoomBack: true)
        if let cat = Category(rawValue: ids[indexPath.row]) {
            showLocationsForCategory(category: cat)
        } else {
            print("category not found")
        }
    }
    
    
    //**************************** Offline Map ******************************************//
    
    func startOfflinePackDownload() {
        guard let _ = myMapView else {return}
        let bounds = MGLCoordinateBounds(sw: CLLocationCoordinate2D(latitude: 52.555820, longitude: 13.219299), ne: CLLocationCoordinate2D(latitude: 52.365878, longitude: 13.572235))

        let region = MGLTilePyramidOfflineRegion(styleURL: myMapView!.styleURL, bounds: bounds, fromZoomLevel: 12, toZoomLevel: 15)
        
        // Store some data for identification purposes alongside the downloaded resources.
        let userInfo = ["name": "My Offline Pack"]
        let context = NSKeyedArchiver.archivedData(withRootObject: userInfo)
        
        // Create and register an offline pack with the shared offline storage object.
        
        MGLOfflineStorage.shared().addPack(for: region, withContext: context) { (pack, error) in
            guard error == nil else {
                // The pack couldn’t be created for some reason.
                print("Error: \(error?.localizedDescription ?? "unknown error")")
                return
            }
            
            // Start downloading.
            pack!.resume()
        }
        
    }
    
    // MARK: - MGLOfflinePack notification handlers
    
    @objc func offlinePackProgressDidChange(notification: NSNotification) {
        // Get the offline pack this notification is regarding,
        // and the associated user info for the pack; in this case, `name = My Offline Pack`
        if let pack = notification.object as? MGLOfflinePack,
            let userInfo = NSKeyedUnarchiver.unarchiveObject(with: pack.context) as? [String: String] {
            let progress = pack.progress
            // or notification.userInfo![MGLOfflinePackProgressUserInfoKey]!.MGLOfflinePackProgressValue
            let completedResources = progress.countOfResourcesCompleted
            let expectedResources = progress.countOfResourcesExpected
            
            // Calculate current progress percentage.
            let progressPercentage = Float(completedResources) / Float(expectedResources)
            
            // Setup the progress bar.
            if progressView == nil {
                progressView = UIProgressView(progressViewStyle: .default)
                let frame = view.bounds.size
                progressView!.frame = CGRect(x: 15, y: 145, width: frame.width - 30, height: 10)
                view.addSubview(progressView!)
            }
            progressView!.isHidden = false
            progressView!.progress = progressPercentage
            
            // If this pack has finished, print its size and resource count.
            if completedResources == expectedResources {
                let byteCount = ByteCountFormatter.string(fromByteCount: Int64(pack.progress.countOfBytesCompleted), countStyle: ByteCountFormatter.CountStyle.memory)
                print("Offline pack “\(userInfo["name"] ?? "unknown")” completed: \(byteCount), \(completedResources) resources")
                progressView?.isHidden = true
            } else {
                // Otherwise, print download/verification progress.
                print("Offline pack “\(userInfo["name"] ?? "unknown")” has \(completedResources) of \(expectedResources) resources — \(progressPercentage * 100)%.")
            }
        }
    }
    
    @objc func offlinePackDidReceiveError(notification: NSNotification) {
        if let pack = notification.object as? MGLOfflinePack,
            let userInfo = NSKeyedUnarchiver.unarchiveObject(with: pack.context) as? [String: String],
            let error = notification.userInfo?[MGLOfflinePackUserInfoKey.error] as? NSError {
            print("Offline pack “\(userInfo["name"] ?? "unknown")” received error: \(error.localizedFailureReason ?? "unknown error")")
        }
    }
    
    @objc func offlinePackDidReceiveMaximumAllowedMapboxTiles(notification: NSNotification) {
        if let pack = notification.object as? MGLOfflinePack,
            let userInfo = NSKeyedUnarchiver.unarchiveObject(with: pack.context) as? [String: String],
            let maximumCount = (notification.userInfo?[MGLOfflinePackUserInfoKey.maximumCount] as AnyObject).uint64Value {
            print("Offline pack “\(userInfo["name"] ?? "unknown")” reached limit of \(maximumCount) tiles.")
        }
    }
    
    //**************************** Helper Functions ******************************************//
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension HKWMapViewController: MapSearch {
    //Display Search Result
    public func showSearchResult(location: Location) {
        closePopup(zoomBack: true)
        guard let map = myMapView else {
            return
        }
        
        if let annos = map.annotations {
            map.removeAnnotations(annos)
        }
        
        map.addAnnotations([location])
        popupWindow?.setValuesForLocation(location: location)
        popupWindow?.isHidden = false
        let lat = location.coordinate.latitude + 0.0019
        map.setCenter(CLLocationCoordinate2D(latitude: lat, longitude: location.coordinate.longitude), zoomLevel: 15, animated: false)
    }
}

extension HKWMapViewController {
    public func showSelectedLocation(location:Location){
        guard let map = myMapView else {return}
        
        if let annos = map.annotations {
            map.removeAnnotations(annos)
        }
        
        map.addAnnotations([location])
        popupWindow?.setValuesForLocation(location: location)
        popupWindow?.isHidden = false
        let lat = location.coordinate.latitude + 0.0023
        map.setCenter(CLLocationCoordinate2D(latitude: lat, longitude: location.coordinate.longitude), zoomLevel: 14, animated: false)
    }
    
    // Zoom to the annotation when it is selected
    func mapView(_ mapView: MGLMapView, didSelect annotation: MGLAnnotation) {
        let lat = annotation.coordinate.latitude + 0.0023
        mapView.setCenter(CLLocationCoordinate2DMake(lat, annotation.coordinate.longitude), zoomLevel: 14, animated: false)
    }

}
