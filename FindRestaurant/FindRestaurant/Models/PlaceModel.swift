//
//  PlaceModel.swift
//  FindRestaurant
//
//  Created by Erick Arciniega on 18/12/19.
//  Copyright © 2019 Erick Arciniega. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import SwiftyJSON

class PlaceModel{
    let name: String
    let address: String
    let coordinate: CLLocationCoordinate2D
    let placeType: String
    var photoReference: String?
    var photo: UIImage?
    
    init(dictionary: [String:Any], acceptedTypes: [String]) {
        
        let json = JSON(dictionary)
        name = json["name"].stringValue
        address = json["vicinity"].stringValue
        photoReference = json["photos"][0]["photo_reference"].string
        
        let lat = json["geometry"]["location"]["lat"].doubleValue as CLLocationDegrees
        let lng = json["geometry"]["location"]["lng"].doubleValue as CLLocationDegrees
        coordinate = CLLocationCoordinate2DMake(lat, lng)
        
        var foundType = "restaurant"
        let possibleTypes = acceptedTypes.count > 0 ? acceptedTypes : ["bakery", "bar", "cafe", "grocery_or_supermarket", "restaurant", "food"]
        if let types = json["types"].arrayObject as? [String] {
            for type in types {
                if possibleTypes.contains(type) {
                    foundType = type
              break
            }
          }
        }
        placeType = foundType
    }
}
