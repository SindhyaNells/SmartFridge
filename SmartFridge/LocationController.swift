//
//  LocationController.swift
//  SmartFridge
//
//  Created by sindhya on 12/1/17.
//  Copyright © 2017 SJSU. All rights reserved.
//

import UIKit
import MapKit

class LocationController: UIViewController,MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    var groceryPlaces = Array<GroceryPlaces>()
    
    fileprivate var isCurrentLocation: Bool = false
    
    var locationManager = CLLocationManager()
    fileprivate var annotation: MKAnnotation!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.delegate = self
        mapView.mapType = .standard
        
        if (CLLocationManager.locationServicesEnabled()) {
            //if locationManager == nil {
               locationManager = CLLocationManager()
            //}
            locationManager.requestAlwaysAuthorization()
            locationManager.delegate = self as? CLLocationManagerDelegate
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
            isCurrentLocation = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getNearbyGroceryPlaces();
    
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if !isCurrentLocation {
            return
        }
        
        isCurrentLocation = false
        
        let location = locations.last
        
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        self.mapView.setRegion(region, animated: true)
        
        if self.mapView.annotations.count != 0 {
            annotation = self.mapView.annotations[0]
            self.mapView.removeAnnotation(annotation)
        }
        
        let pointAnnotation = MKPointAnnotation()
        pointAnnotation.coordinate = location!.coordinate
        pointAnnotation.title = ""
        mapView.addAnnotation(pointAnnotation)
    }
    
    func getNearbyGroceryPlaces(){
        let placesURL = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=37.3352,-121.8811&radius=2000&type=grocery_or_supermarket&key=AIzaSyCQ7nzuqrkbFNf15vueqVljJixWo56jzRw"
        
        
        var request = URLRequest(url: URL(string: placesURL)!)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in print( response ?? "Error connecting to Rest API - GET Google places")
            if error != nil
            {
                print("Failed to connect to Google places API")
                print(error!)
            }
            else
            {
                print("Data Obtained")
                self.parseJSON(data!)
                
            }
            
            if let httpResponse = response as? HTTPURLResponse
            {
                if httpResponse.statusCode == 200
                {
                    print("Retrived grocery list")
                    
                }
                else
                {
                    print(httpResponse.statusCode)
                    print("Failed to retrive grocery list")
                }
            }
            
        })
        
        task.resume()
    }
    
    func parseJSON(_ data:Data){
        groceryPlaces = Array<GroceryPlaces>()
        
        //let groceryPlacesItem = GroceryPlaces()
        
        do {
            //if let data = data,
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                let results = json["results"] as? [[String: Any]] {
                for res in results {
                    let googleGeo = res["geometry"] as! NSDictionary
                    let placeName = res["name"] as! String
                    let googleLoc = googleGeo["location"] as! NSDictionary
                    let latitude = googleLoc["lat"] as! Float
                    let longitude = googleLoc["lng"] as! Float
                    //let geo = res["geometry"]as? [[String: Any]]
                    //let loc = geo["location"] as? [[String: Any]]
                    //if let lat = loc["latitude"] as? String {
                        //names.append(name)
                    print(placeName)
                        print(latitude)
                    print(longitude)
                    //}
                }
            }
        } catch {
            print("Error deserializing JSON: \(error)")
        }
        
        
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
