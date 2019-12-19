//
//  RestaurantListViewController.swift
//  FindRestaurant
//
//  Created by Erick Arciniega on 19/12/19.
//  Copyright © 2019 Erick Arciniega. All rights reserved.
//

import UIKit
import GoogleMaps

class RestaurantListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    private let dataProvider = DataProvider()
    var locationManager = CLLocationManager()
    var placesArray: [PlaceModel] = []
    
    private let searchRadius: Double = 1500
    var searchedTypes = ["bakery", "bar", "cafe", "grocery_or_supermarket", "restaurant"]
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
 
        // Do any additional setup after loading the view.
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
      guard let location = locations.first else {
        return
      }
      locationManager.stopUpdatingLocation()
      fetchNearbyPlaces(coordinate: location.coordinate)
    }
    
    private func fetchNearbyPlaces(coordinate: CLLocationCoordinate2D) {
        dataProvider.getCoordinatesNearPlaces(coordinate, radius:searchRadius, types: searchedTypes) { places in
        places.forEach {
            let marker = PlaceMarker(place: $0)
            self.placesArray.append(marker.place)
        }
            self.tableView.reloadData()
      }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return placesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RestaurantsModelCell") as! RestaurantsModelCell
        
        print("arr\(placesArray.count)")
        cell.addressLabel.text = placesArray[indexPath.row].address
        cell.nameLabel.text = placesArray[indexPath.row].name
        cell.restaurantImage.image = placesArray[indexPath.row].photo
        
        return cell
    }
    

    

}
