//
//  PlaceMarker.swift
//  FindRestaurant
//
//  Created by Erick Arciniega on 18/12/19.
//  Copyright © 2019 Erick Arciniega. All rights reserved.
//

import UIKit
import GoogleMaps


class PlaceMarker: GMSMarker {
    let place: PlaceModel
    init(place: PlaceModel) {
      self.place = place
      super.init()
      position = place.coordinate
      icon = UIImage(named: place.placeType+"_pin")
      groundAnchor = CGPoint(x: 0.5, y: 1)
      appearAnimation = .pop
    }
}
