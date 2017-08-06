//
//  MapViewController.swift
//  NativeIconSpeaker
//
//  Created by Nguyễn Minh Trí on 5/11/17.
//  Copyright © 2017 RAD-INF. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import Alamofire
import SwiftyJSON

class MapViewController: UIViewController, SearchResultsControllerDelegate {

    @IBOutlet weak var mapView: GMSMapView!
    
    var locationManager = CLLocationManager()
    var didFindMyLocation = false
    var searchResultController: SearchResultsController!
    var resultsArray = [String]()
    var gmsFetcher: GMSAutocompleteFetcher!
    
    var gmsVC : GMSAutocompleteViewController?
    var strlocationStart:CLLocation?
    var strlocationEnd:CLLocation?
    
    //polyLine
    var polyline:GMSPolyline?
    var marker:GMSMarker?
    var test_destination:String?
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.mapType = kGMSTypeNormal
        locationManager.delegate = self
        
        locationManager.requestWhenInUseAuthorization()
        mapView.addObserver(self, forKeyPath: "myLocation", options: NSKeyValueObservingOptions.new, context: nil)
        testMylocation()
        polyline = GMSPolyline()
    }
    
    func testMylocation(){
        searchResultController = SearchResultsController()
        searchResultController.delegate = self
        gmsFetcher = GMSAutocompleteFetcher()
        gmsFetcher.delegate = self
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if !didFindMyLocation {
            let myLocation: CLLocation = change![.newKey] as! CLLocation
            mapView.camera = GMSCameraPosition.camera(withTarget: myLocation.coordinate, zoom: 15.0)
            mapView.settings.myLocationButton = true
        
            didFindMyLocation = true
        }
    }
    
    deinit {
        mapView.removeObserver(self, forKeyPath: "myLocation")
    }
    
    @IBAction func handleSearch(_ sender: Any) {
        removePolylineAndMarker()
        //delete previous polyline	
        let searchController = UISearchController(searchResultsController: searchResultController)
        searchController.searchBar.delegate = self
        self.present(searchController, animated:true, completion: nil)
    }
    
    @IBAction func handleClose(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func locateWithLongitude(_ lon: Double, andLatitude lat: Double, andTitle title: String) {
        DispatchQueue.main.async { () -> Void in
            
            let position = CLLocationCoordinate2DMake(lat, lon)
            self.marker = GMSMarker(position: position)
            
            let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: lon, zoom: 10)
            self.mapView.camera = camera
            self.marker?.map = self.mapView
            self.strlocationEnd = CLLocation(latitude: lat, longitude: lon)
            self.test_drawPath(startLocation:self.strlocationStart! , endLocation: self.strlocationEnd!, lat: lat, lon: lon)
        }
    }
    
    func test_drawPath(startLocation: CLLocation, endLocation: CLLocation, lat:Double, lon: Double)
    {
        let origin = "\(startLocation.coordinate.latitude),\(startLocation.coordinate.longitude)"
        let destination = "\(endLocation.coordinate.latitude),\(endLocation.coordinate.longitude)"
        
        let url_test = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&key=AIzaSyB-EMRu7GvmVEXXMziZbFxp6P8rqJSIKd4"
        
        mapView.camera = GMSCameraPosition.camera(withTarget: endLocation.coordinate, zoom: 15.0)
        
        Alamofire.request(url_test).responseJSON { response in
            
            print(response.request as Any)  // original URL request
            print(response.response as Any) // HTTP URL response
            print(response.data as Any)     // server data
            print(response.result as Any)   // result of response serialization
            
            let json = JSON(data: response.data!)
            let routes = json["routes"].arrayValue
            
            // print route using Polyline
            for route in routes
            {
                let legs = route["legs"].arrayValue
                for test in legs {
                    let a = test["distance"].dictionary
                    if let test_des = a?["text"]?.stringValue {
                        self.marker?.title = test_des
                    }
                    break
                }
                let routeOverviewPolyline = route["overview_polyline"].dictionary
                let points = routeOverviewPolyline?["points"]?.stringValue
                let path = GMSPath.init(fromEncodedPath: points!)
                //self.polyline = GMSPolyline()
                self.polyline?.path = path
                self.polyline?.strokeWidth = 4
                self.polyline?.strokeColor = UIColor.red
                self.polyline?.map = self.mapView
                
            }
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

extension MapViewController:CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.authorizedWhenInUse {
            mapView.isMyLocationEnabled = true
            let test_lat = manager.location?.coordinate.latitude
            let test_long = manager.location?.coordinate.longitude
            strlocationStart = CLLocation(latitude: test_lat!, longitude: test_long!)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        
        if locations.count > 0
        {
            mapView.camera = GMSCameraPosition.camera(withTarget: (locations.last?.coordinate)!, zoom: 13.0)
            mapView.settings.myLocationButton = true
            let latLocation = locations.last?.coordinate.latitude
            let longLocation = locations.last?.coordinate.longitude
            strlocationStart = CLLocation(latitude: latLocation!, longitude: longLocation!)
        }
    }
}

//extension MapViewController:GMSMapViewDelegate {
//}

extension MapViewController:UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.resultsArray.removeAll()
        
        gmsFetcher?.sourceTextHasChanged(searchText)
    }
}

extension MapViewController:GMSAutocompleteFetcherDelegate {
    public func didFailAutocompleteWithError(_ error: Error) {
    }
    
    public func didAutocomplete(with predictions: [GMSAutocompletePrediction]) {
        for prediction in predictions {
            
            if let prediction = prediction as GMSAutocompletePrediction!{
                self.resultsArray.append(prediction.attributedFullText.string)
            }
        }
        self.searchResultController.reloadDataWithArray(self.resultsArray)
        print(resultsArray)
    }
}

extension MapViewController:GMSAutocompleteViewControllerDelegate {
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error \(error)")
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        let camera = GMSCameraPosition.camera(withLatitude: place.coordinate.latitude, longitude: place.coordinate.longitude, zoom: 16.0
        )
    }

    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}
