//
//  DataStore.swift
//  Arriving
//
//  Created by anouk on 04/09/17.
//  Copyright © 2017 anouk. All rights reserved.
//

import UIKit
import SwiftyJSON
import CoreLocation
import Mapbox
import PromiseKit
import Localize_Swift

enum Category: Int {
    case Sports = 13
    case Wifi = 14
    case Shopping = 12
    case Counseling = 1
    case DoctorGPAR = 2
    case DoctorGPFA = 3
    case DoctorGynAR = 4
    case DoctorGynFA = 5
    case German = 6
    case Lawyers = 7
    case Police = 8
    case Authority = 9
    case Library = 10
    case Transport = 11
}

enum StorageKeys: String {
    case cat_id = "key_ID"
    case title = "key_title"
    case lat = "key_lat"
    case lng = "key_lng"
    case medium = "key_medium"
    case address = "key_address"
    case telefon = "key_phone"
    case text = "key_text"
    case transport = "key_transport"
    case link = "key_link"
}

class Location: NSObject, MGLAnnotation, NSCoding {
    var category: Category
    var categoryID: Int
    var title: String?
    var coordinate: CLLocationCoordinate2D
    var medium: String?
    var address: String?
    var telefon: String?
    var text: String?
    var transport: String?
    var link: String?
    
    init(category: Category, categoryID: Int, title: String, coordinate: CLLocationCoordinate2D, medium: String?, address: String?, telefon: String?, text: String?, transport: String?, link: String?) {
        self.category = category
        self.categoryID = categoryID
        self.coordinate = coordinate
        self.title = title
        self.medium = medium
        self.address = address
        self.telefon = telefon
        self.text = text
        self.transport = transport
        self.link = link
        super.init()
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        if let cat = aDecoder.decodeObject(forKey: StorageKeys.cat_id.rawValue) as? Int, let lat = aDecoder.decodeObject(forKey: StorageKeys.lat.rawValue) as? Double, let lon = aDecoder.decodeObject(forKey: StorageKeys.lng.rawValue) as? Double, let category = Category(rawValue: cat), let title = aDecoder.decodeObject(forKey: StorageKeys.title.rawValue) as? String {
            
            self.init(category: category,
                      categoryID: cat,
                      title: title,
                      coordinate: CLLocationCoordinate2D.init(latitude: lat, longitude: lon),
                      medium: aDecoder.decodeObject(forKey: StorageKeys.medium.rawValue) as? String,
                      address: aDecoder.decodeObject(forKey: StorageKeys.address.rawValue) as? String,
                      telefon: aDecoder.decodeObject(forKey: StorageKeys.telefon.rawValue) as? String,
                      text: aDecoder.decodeObject(forKey: StorageKeys.text.rawValue) as? String,
                      transport: aDecoder.decodeObject(forKey: StorageKeys.transport.rawValue) as? String,
                      link:  aDecoder.decodeObject(forKey: StorageKeys.link.rawValue) as? String)
        } else {
            return nil
        }
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.categoryID, forKey: StorageKeys.cat_id.rawValue)
        aCoder.encode(self.title, forKey: StorageKeys.title.rawValue)
        aCoder.encode(self.coordinate.latitude, forKey: StorageKeys.lat.rawValue)
        aCoder.encode(self.coordinate.longitude, forKey: StorageKeys.lng.rawValue)
        aCoder.encode(self.medium, forKey: StorageKeys.medium.rawValue)
        aCoder.encode(self.address, forKey: StorageKeys.address.rawValue)
        aCoder.encode(self.telefon, forKey: StorageKeys.telefon.rawValue)
        aCoder.encode(self.text, forKey: StorageKeys.text.rawValue)
        aCoder.encode(self.transport, forKey: StorageKeys.transport.rawValue)
        aCoder.encode(self.link, forKey: StorageKeys.link.rawValue)
    }
}

class DataStore: NSObject {
    
    static let sharedInstance = DataStore()
    private var locations: Array<Location> = []
    
    func storeData(data: Array<Location>, languageKey: LanguageKey) -> Bool {
        return NSKeyedArchiver.archiveRootObject(data, toFile: languageKey.rawValue)
    }
    
    func getData(language: LanguageKey) -> Array<Location> {
        return NSKeyedUnarchiver.unarchiveObject(withFile: language.rawValue) as? [Location] ?? []
    }
    
    public func refreshLocations(key: LanguageKey) -> Promise<Array<Location>> {
        locations = []
        return Promise { fulfill, reject in
            if getData(language: key).count > 0 {
                self.locations = getData(language: key)
                fulfill(locations)
            } else {
                firstly {
                    HKWAPI.getMyLocations(language: key)
                    }.then { result -> Void in
                        print(result)
                        let features = self.getFeaturesFromJSON(json: result)
                        let locs = features.map({self.getLocationsFromJSON(features: $0)})
                        self.locations = locs.flatMap({$0})
                        let _ = self.storeData(data: self.locations, languageKey: key)
                        //store locations
                        fulfill(self.locations)
                    }.always {
                }
            }
        }
    }
    
    public func updateLocations(language: LanguageKey) -> Promise<Bool> {
        return Promise { fulfill, reject in
            firstly {
                HKWAPI.getMyLocations(language: language)
                }.then { result -> Void in
                    let features = self.getFeaturesFromJSON(json: result)
                    let locsJson = features.map({self.getLocationsFromJSON(features: $0)})
                    let locs = locsJson.flatMap({$0})
                    fulfill(self.storeData(data: locs, languageKey: language))
                }.always {
            }
        }
    }
    
    public func getLocations(key: LanguageKey) -> Promise<Array<Location>>{
        return Promise { fulfill, reject in
            if locations.count > 0 {
                fulfill(locations)
            } else if getData(language: key).count > 0 {
                self.locations = getData(language: key)
                fulfill(locations)
            } else {
                firstly {
                    HKWAPI.getMyLocations(language: key)
                    }.then { result -> Void in
                        let features = self.getFeaturesFromJSON(json: result)
                        let locs = features.map({self.getLocationsFromJSON(features: $0)})
                        self.locations = locs.flatMap({$0})
                        let _ = self.storeData(data: self.locations, languageKey: key)
                        //store locations
                        fulfill(self.locations)
                    }.always {
                }
            }
        }
    }
    
    public func getFeaturesFromJSON(json: JSON) -> [[JSON]] {
        var features: [[JSON]] = []
        if let feat = json["features"].array {
            features.append(feat)
        }
        return features
    }
    
    public func getLocationsFromJSON(features: [JSON]) -> Array<Location> {
        var locations: Array<Location> = []

        for item in features{
            
            guard let props = item["properties"].dictionary, let coordinates = item["geometry"]["coordinates"].array, let title = props["name"]?.stringValue, let categoryID =  props["category_id"]?.stringValue, let catID = Int(categoryID), let category = Category(rawValue: catID),let lat = coordinates[1].double, let lon = coordinates[0].double
                else {
                    print("PROBLEM")
                    break
            }
            
            let location = Location.init(category: category, categoryID: catID, title: title, coordinate: CLLocationCoordinate2D.init(latitude: lat, longitude: lon), medium: props["medium"]?.stringValue, address: props["adresse"]?.stringValue, telefon: props["telefon"]?.stringValue, text: props["beschreibung"]?.stringValue, transport: props["transport"]?.stringValue, link: props["link"]?.stringValue)
            
            locations.append(location)
        }
    
        return locations
    }
}

extension DataStore {
    public func categoryTitleForID(catID: Int) -> String {
        var name: String = "";
        switch (catID) {
        case 1:
            name = "counseling".localized()
            break
        case 2:
            name = "doctor_gp_ar".localized()
            
            break
        case 3:
            name = "doctor_gp_fa".localized()
            break
        case 4:
            name = "doctor_gyn_ar".localized()
            break
        case 5:
            name = "doctor_gyn_fa".localized()
            break
        case 6:
            name = "german_classes".localized()
            break
        case 7:
            name = "lawyers".localized()
            break
        case 8:
            name = "police".localized()
            break
        case 9:
            name = "public_auth".localized()
            break;
        case 10:
            name = "public_libraries".localized()
            break;
        case 11:
            name = "public_transport".localized()
            break;
        case 12:
            name = "shopping_and_food".localized()
            break;
        case 13:
            name = "sports".localized()
            break;
        case 14:
            name = "wifi".localized()
            break;
        default:
            name = "wifi".localized()
        }
        
        return name
    }
    
    public func getImageForCategory(category: Category) -> UIImage{
        switch category {
        case Category.Counseling:
            return #imageLiteral(resourceName: "counseling_services_for_refugees")
        case Category.DoctorGPAR:
            return #imageLiteral(resourceName: "doctors_general_practitioner_arabic")
        case Category.DoctorGPFA:
            return #imageLiteral(resourceName: "doctors_general_practitioner_farsi")
        case Category.DoctorGynAR:
            return #imageLiteral(resourceName: "doctors_gynaecologist_arabic")
        case Category.DoctorGynFA:
            return #imageLiteral(resourceName: "doctors_gynaecologist_farsi")
        case Category.German:
            return #imageLiteral(resourceName: "german_language_classes")
        case Category.Lawyers:
            return #imageLiteral(resourceName: "lawyers_residence_and_asylum_law")
        case Category.Police:
            return #imageLiteral(resourceName: "police")
        case Category.Authority:
            return #imageLiteral(resourceName: "public_authorities")
        case Category.Library:
            return #imageLiteral(resourceName: "public_libraries")
        case Category.Transport:
            return #imageLiteral(resourceName: "public_transport")
        case Category.Shopping:
            return #imageLiteral(resourceName: "shopping_and_food")
        case Category.Sports:
            return #imageLiteral(resourceName: "sports_and_freetime")
        case Category.Wifi:
            return #imageLiteral(resourceName: "wifi")
        }
    }
}
