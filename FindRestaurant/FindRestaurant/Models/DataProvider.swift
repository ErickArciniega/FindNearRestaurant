//
//  DataProvider.swift
//  FindRestaurant
//
//  Created by Erick Arciniega on 18/12/19.
//  Copyright © 2019 Erick Arciniega. All rights reserved.
//

import Foundation
import CoreLocation
import SwiftyJSON

typealias PlacesCompletion = ([PlaceModel]) -> Void
typealias PhotoCompletion = (UIImage?) -> Void

class DataProvider {
    private var placesTask: URLSessionDataTask?
    private var session: URLSession {
        return URLSession.shared
    }
    private var photoCache: [String: UIImage] = [:]
    
    func getCoordinatesNearPlaces(_ coordinate: CLLocationCoordinate2D, radius: Double, types:[String], completion: @escaping PlacesCompletion) -> Void{
        
        var urlString = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(coordinate.latitude),\(coordinate.longitude)&radius=\(radius)&rankby=prominence&sensor=true&type=food|restaurant|cafe|bar|grocery_or_supermarket&key=\(Keys.GoogleApiKey)"
        
        urlString = urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? urlString
           
        guard let url = URL(string: urlString) else {
            completion([])
            return
        }
           
           if let task = placesTask, task.taskIdentifier > 0 && task.state == .running {
             task.cancel()
           }
           
           DispatchQueue.main.async {
             UIApplication.shared.isNetworkActivityIndicatorVisible = true
           }
           
           placesTask = session.dataTask(with: url) { data, response, error in
             var placesArray: [PlaceModel] = []
             defer {
               DispatchQueue.main.async {
                 UIApplication.shared.isNetworkActivityIndicatorVisible = false
                 completion(placesArray)
               }
             }
             guard let data = data,
               let json = try? JSON(data: data, options: .mutableContainers),
               let results = json["results"].arrayObject as? [[String: Any]] else {
                 return
             }
             results.forEach {
               let place = PlaceModel(dictionary: $0, acceptedTypes: types)
               placesArray.append(place)
               if let reference = place.photoReference {
                 self.fetchPhotoFromReference(reference) { image in
                   place.photo = image
                 }
               }
             }
            
           }
           placesTask?.resume()
    }
    
    func fetchPhotoFromReference(_ reference: String, completion: @escaping PhotoCompletion) -> Void {
      if let photo = photoCache[reference] {
        completion(photo)
      } else {
        let urlString = Apis.PhotoReference + "maxwidth=200&photoreference=" + reference + "&key=" + Keys.GoogleApiKey
        guard let url = URL(string: urlString) else {
          completion(nil)
          return
        }
        
        DispatchQueue.main.async {
          UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
        
        session.downloadTask(with: url) { url, response, error in
          var downloadedPhoto: UIImage? = nil
          defer {
            DispatchQueue.main.async {
              UIApplication.shared.isNetworkActivityIndicatorVisible = false
              completion(downloadedPhoto)
            }
          }
          guard let url = url else {
            return
          }
          guard let imageData = try? Data(contentsOf: url) else {
            return
          }
          downloadedPhoto = UIImage(data: imageData)
          self.photoCache[reference] = downloadedPhoto
        }
          .resume()
      }
    }
}
