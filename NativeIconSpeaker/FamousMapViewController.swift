//
//  FamousMapViewController.swift
//  NativeIconSpeaker
//
//  Created by Nguyễn Minh Trí on 5/26/17.
//  Copyright © 2017 RAD-INF. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import Alamofire
import SwiftyJSON

class FamousMapViewController: UIViewController {
    @IBOutlet weak var mapViewFamous: GMSMapView!
    var locationManager = CLLocationManager()
    var didFindMyLocation = false
    var startLocation:CLLocation?
    //polyLine
    var polyline:GMSPolyline?
    var marker:GMSMarker?
    
    //show map depend on destination
    var famousPlaceDestination:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //let camera: GMSCameraPosition = GMSCameraPosition.camera(withLatitude: 10.756175, longitude: 106.720872, zoom: 20.0)
        //mapViewFamous.camera = camera
        mapViewFamous.mapType = kGMSTypeNormal
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        mapViewFamous.addObserver(self, forKeyPath: "myLocation", options: NSKeyValueObservingOptions.new, context: nil)
        polyline = GMSPolyline()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if !didFindMyLocation {
            let myLocation: CLLocation = change![.newKey] as! CLLocation
            
            mapViewFamous.camera = GMSCameraPosition.camera(withTarget: myLocation.coordinate, zoom: 15.0)
            mapViewFamous.settings.myLocationButton = true
            
            didFindMyLocation = true
        }
    }
    
    deinit {
        
    }
    
    func test_drawPath_a(startLocation: CLLocation)
    {
        let origin = "\(startLocation.coordinate.latitude),\(startLocation.coordinate.longitude)"
        
        
        guard let des_test = famousPlaceDestination
        else {
                return
        }
        let url_test_a = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(des_test)&key=AIzaSyB-EMRu7GvmVEXXMziZbFxp6P8rqJSIKd4"
        Alamofire.request(url_test_a).responseJSON { response in
            
            print(response.request as Any)  // original URL request
            print(response.response as Any) // HTTP URL response
            print(response.data as Any)     // server data
            print(response.result as Any)   // result of response serialization
            
            let json = JSON(data: response.data!)
            let routes = json["routes"].arrayValue
            //let legs = routes["legs"]
            // print route using Polyline
            for route in routes
            {
                let routeOverviewPolyline = route["overview_polyline"].dictionary
                let points = routeOverviewPolyline?["points"]?.stringValue
                let path = GMSPath.init(fromEncodedPath: points!)
                //self.polyline = GMSPolyline()
                self.polyline?.path = path
                self.polyline?.strokeWidth = 4
                self.polyline?.strokeColor = UIColor.blue
                self.polyline?.map = self.mapViewFamous
                
            }
        }
    }
    
    @IBAction func handleClose(_ sender: Any) {
        dismiss(animated: true) { 
            self.mapViewFamous.removeObserver(self, forKeyPath: "myLocation")
            self.removePolylineAndMarker()
        }
    }
    
    func removePolylineAndMarker(){
        if polyline?.map != nil {
            polyline?.map = nil
        }
        if marker?.map != nil {
            marker?.map = nil
        }
    }

}

extension FamousMapViewController:CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.authorizedWhenInUse {
            mapViewFamous.isMyLocationEnabled = true
            let test_lat = manager.location?.coordinate.latitude
            let test_long = manager.location?.coordinate.longitude
            startLocation = CLLocation(latitude: test_lat!, longitude: test_long!)
            test_drawPath_a(startLocation: startLocation!)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        
        if locations.count > 0
        {
            mapViewFamous.camera = GMSCameraPosition.camera(withTarget: (locations.last?.coordinate)!, zoom: 13.0)
            mapViewFamous.settings.myLocationButton = true
            let latLocation = locations.last?.coordinate.latitude
            let longLocation = locations.last?.coordinate.longitude
            startLocation = CLLocation(latitude: latLocation!, longitude: longLocation!)
        }
    }
}


