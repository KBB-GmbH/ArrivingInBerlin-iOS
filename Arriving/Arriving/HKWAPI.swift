//
//  HKWAPI.swift
//  Arriving
//
//  Created by anouk on 04/09/17.
//  Copyright © 2017 anouk. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import PromiseKit

enum LanguageKey: String {
    case English = "en"
    case French = "fr"
    case German = "de"
    case Arabic = "ar"
    case Farsi = "fa"
    case Sorani = "ckb"
}

class HKWAPI: NSObject {
    public class func baseUrl() -> String {
        return "http://umap.openstreetmap.fr/en/datalayer/"
    }

    public class func urlForEndpoint(point: String) -> String {
        return "http://umap.openstreetmap.fr/en/datalayer/" + point
    }
    
    public class func endpointsForLanguage(language: LanguageKey) -> Array<String> {
        switch language {
        case .English:
            return ["103125", "119513", "103122", "103130", "119468", "115921", "93689", "93512", "93515","119511", "119437", "115892", "259820", "320118"]
        case .French:
            return ["159184", "159185", "159186", "159187", "159188", "159189", "159191", "159192", "159193", "159194", "159195", "159196", "159197", "159198", "325432"]
        case .German:
            return ["226926","226927", "226928", "226929", "226930", "226931", "226933", "226934", "226935", "226936", "226937", "226938", "226939", "226940","325444"]
        case .Arabic:
            return ["128884", "128885", "128886", "128887", "128888", "128889", "128891", "128892", "128893", "128894", "128895", "128896", "128897", "128898", "325451"]
        case .Farsi:
            return ["128475", "128476", "128477", "128478", "128479", "128480", "128482", "128483", "128484", "128485", "128486", "128487", "128488", "128489", "325455"]
        case .Sorani:
            return ["193257", "193258", "193259", "193260", "193261", "193262", "193263", "193264", "193265", "193266", "193267", "193268", "193269", "193270", "325457"]
        }
    }
    
    public class func urlForLanguage(language: LanguageKey) -> String {
        switch language {
        case .English:
            return "https://raw.githubusercontent.com/KBB-GmbH/ArrivingInBerlin-aggregator/master/arriving_in_berlin_data_english.geojson"
        case .French:
            return "https://raw.githubusercontent.com/KBB-GmbH/ArrivingInBerlin-aggregator/master/arriving_in_berlin_data_french.geojson"
        case .German:
            return "https://raw.githubusercontent.com/KBB-GmbH/ArrivingInBerlin-aggregator/master/arriving_in_berlin_data_german.geojson"
        case .Arabic:
            return "https://raw.githubusercontent.com/KBB-GmbH/ArrivingInBerlin-aggregator/master/arriving_in_berlin_data_arabic.geojson"
        case .Farsi:
            return "https://raw.githubusercontent.com/KBB-GmbH/ArrivingInBerlin-aggregator/master/arriving_in_berlin_data_farsi.geojson"
        case .Sorani:
            return "https://raw.githubusercontent.com/KBB-GmbH/ArrivingInBerlin-aggregator/master/arriving_in_berlin_data_kurdish.geojson"
        }
    }
    
    public class func getMyLocations(language: LanguageKey) -> Promise<JSON>{
        let promises = [getLocation(url: urlForLanguage(language: language))]
        return Promise {fullfill, reject in
            when(fulfilled: promises).then { results -> Void in
                fullfill(results[0])
                }.catch { error in
                    reject(error)
            }
        }
    }
    


    public class func getLocation(url: String) -> Promise<JSON> {
        return Promise { fulfill, reject in
            Alamofire.request(url)
                .validate()
                .responseJSON { response in
                    switch response.result {
                    case .success(let value):
                        fulfill(JSON(value))
                    case .failure(let error):
                        reject(error)
                    }
            }
        }
    }

    func checkForUpdates(completion:@escaping ([Bool]) -> Void) {
        
    }
    
    public class func getLocations(completion: @escaping ([String]) -> Void) {
        
    }
}
