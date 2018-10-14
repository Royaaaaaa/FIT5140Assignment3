//
//  HomeViewController.swift
//  FIT5140Assignment3
//
//  Created by 隋晓婷 on 2018/10/14.
//  Copyright © 2018 Maya. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation

class HomeViewController: UIViewController, CLLocationManagerDelegate {
    
    // MARK: Showing user location
    @IBOutlet weak var roadLabel: UILabel!
    @IBOutlet weak var suburbLabel: UILabel!
    @IBOutlet weak var stateLabel: UILabel!
    
    @IBOutlet weak var direction1Label: UILabel!
    @IBOutlet weak var direction2Label: UILabel!
    @IBOutlet weak var distance1Label: UILabel!
    
    @IBOutlet weak var speed1Label: UILabel!
    @IBOutlet weak var distance2Label: UILabel!
    @IBOutlet weak var speed2Label: UILabel!
    @IBOutlet weak var safeImageView: UIImageView!
    
    // MARK: Firebase login & signup
    var storageRef = Storage.storage()
    let rootRef = Database.database().reference()
    let user = Auth.auth().currentUser!.uid
    var userRefHandle: DatabaseHandle?

    // MARK: Getting user location
    let manager = CLLocationManager()
    //let geocoder = CLGeocoder()
    var locality = ""
    var administrativeArea = ""
    var country = ""
    //var location = CLLocation().self
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // for getting user location
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestAlwaysAuthorization()
        manager.startUpdatingLocation()
    }
    @IBAction func logoutButton(_ sender: Any) {
        do {
            try Auth.auth().signOut()
        }
        catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let initial = storyboard.instantiateInitialViewController()
        UIApplication.shared.keyWindow?.rootViewController = initial
    }
   
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("Did get the latest location")
        guard let currentLocation = locations.first else { return }
        var latitude = currentLocation.coordinate.latitude
        var longitude = currentLocation.coordinate.longitude
        print("lat: \(latitude), long: \(longitude)")
        //manager.stopUpdatingLocation()
        //self.location = currentLocation
        convertLatLongToAddress(latitude: latitude, longitude: longitude)
    }
    
    func convertLatLongToAddress(latitude: Double, longitude: Double) {
        let location = CLLocation(latitude: latitude, longitude: longitude)
        //let geocoder = CLGeocoder()
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error) -> Void in
            if (error != nil) {
                print("Error in reverseGeocode")
            }
            
            //let placemark = placemarks! as [CLPlacemark]
            if ((placemarks?.count)!) > 0 {
                let pm = placemarks![0] as CLPlacemark
                if let locationName = pm.location {
                    print(locationName)
                }
                // Street address
                if let street = pm.thoroughfare {
                    print(street)
                    self.roadLabel.text = street
                }
                // City
                if let city = pm.locality {
                    print(city)
                    self.suburbLabel.text = city
                }
                
                // State
                if let state = pm.administrativeArea {
                    print(state)
                    self.stateLabel.text = state
                }
            }
//                let placemark = placemarks![0]
//                self.locality = placemark.locality!
//                self.administrativeArea = placemark.administrativeArea!
//                self.country = placemark.country!
            
        })

    }
    func lookUpCurrentLocation(completionHandler: @escaping (CLPlacemark?)
        -> Void ) {
        // Use the last reported location.
        if let lastLocation = self.manager.location {
            let geocoder = CLGeocoder()
            
            // Look up the location and pass it to the completion handler
            geocoder.reverseGeocodeLocation(lastLocation,
                                            completionHandler: { (placemarks, error) in
                                                if error == nil {
                                                    let firstLocation = placemarks?[0]
                                                    completionHandler(firstLocation)
                                                }
                                                else {
                                                    // An error occurred during geocoding.
                                                    completionHandler(nil)
                                                }
            })
        }
        else {
            // No location was available.
            completionHandler(nil)
        }
    }
    
    func userLocationString() -> String {
        let userLocationString = "\(locality), \(administrativeArea), \(country)"
        print("\(userLocationString)")
        return userLocationString
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
