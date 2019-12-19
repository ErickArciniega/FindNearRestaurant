//
//  InitialViewController.swift
//  FindRestaurant
//
//  Created by Erick Arciniega on 18/12/19.
//  Copyright © 2019 Erick Arciniega. All rights reserved.
//

import UIKit
import GoogleMaps

class InitialViewController: UIViewController, GMSMapViewDelegate {
    
    var locationManager = CLLocationManager()
    private let dataProvider = DataProvider()
    private let searchRadius: Double = 1500
    let customMarkerWidth: Int = 50
    let customMarkerHeight: Int = 70
    var searchedTypes = ["bakery", "bar", "cafe", "grocery_or_supermarket", "restaurant"]
    
    @IBOutlet weak var mapView: GMSMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        mapView.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
    }
    
    private func fetchNearbyPlaces(coordinate: CLLocationCoordinate2D) {
        mapView.clear()
        dataProvider.getCoordinatesNearPlaces(coordinate, radius:searchRadius, types: searchedTypes) { places in
        places.forEach {
            let marker = PlaceMarker(place: $0)
            marker.map = self.mapView
            
        }
      }
    }
    
    func mapView(_ mapView: GMSMapView, markerInfoContents marker: GMSMarker) -> UIView? {
      guard let placeMarker = marker as? PlaceMarker else {
        return nil
      }
        //photo view
        let image = placeMarker.place.photo
        let infoView = UIView(frame: CGRect(x: 0, y: 0, width: 250, height: 150))
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: 25, y: 50, width: 200, height: 100)
        infoView.addSubview(imageView)
        
        //labelView
        let nameLabel: UILabel = {
            let lbl=UILabel()
            lbl.text = placeMarker.place.name
            lbl.sizeToFit()
            lbl.textColor=UIColor.black
            lbl.textAlignment = .center
            lbl.clipsToBounds=true
            lbl.translatesAutoresizingMaskIntoConstraints=false
            return lbl
        }()
        infoView.addSubview(nameLabel)
        nameLabel.centerXAnchor.constraint(equalTo: infoView.centerXAnchor).isActive=true
        nameLabel.centerYAnchor.constraint(equalTo: infoView.topAnchor, constant: 20).isActive=true
        
        return infoView
    }

}




extension InitialViewController: CLLocationManagerDelegate, protocolAlert {
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    
    if CLLocationManager.locationServicesEnabled() {
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            locationManager.requestAlwaysAuthorization()
        case .authorizedAlways, .authorizedWhenInUse:
            print("Access")
            locationManager.startUpdatingLocation()
            mapView.isMyLocationEnabled = true
            mapView.settings.myLocationButton = true 
        case .restricted, .denied:
            print("go to settings")
            goToSettings(title: "GPS Signal Fail", message: "The use of the location is disabled please check the permissions in the configurations", buttonTittle: "OK")
        @unknown default:
        break
    }
    } else {
        print("Location services are not enabled")
    }
  }
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let location = locations.first else {
      return
    }
    mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
    locationManager.stopUpdatingLocation()
    fetchNearbyPlaces(coordinate: location.coordinate)
  }
}
