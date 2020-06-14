//
//  ViewController.swift
//  FindWay_Charmi_C0768448
//
//  Created by user174608 on 6/12/20.
//  Copyright © 2020 charmi. All rights reserved.
//
import UIKit
import MapKit
import CoreLocation
class ViewController: UIViewController ,MKMapViewDelegate,CLLocationManagerDelegate{

    @IBOutlet weak var findmyway: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    var locationManager = CLLocationManager()
    var destination: CLLocationCoordinate2D!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

                mapView.delegate = self
                
        //        this line is equivalent to the user location check box in map view
        //        map.showsUserLocation = true
                
                // we give the delegate of locationManager to this class
                locationManager.delegate = self
                
                // accuracy of the location
                locationManager.desiredAccuracy = kCLLocationAccuracyBest
                
                // request the user for the location access
                locationManager.requestWhenInUseAuthorization()
                
                // start updating the location of the user
                locationManager.startUpdatingLocation()
        
        // define latitude and longitude
        let latitude: CLLocationDegrees = 30.959960
        let longitude: CLLocationDegrees = -81.721930
        
        // define delta latitude and longitude
        let latDelta: CLLocationDegrees = 0.05
        let longDelta: CLLocationDegrees = 0.05
        
        // define span
        let span = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: longDelta)
        
        // define location
        let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        // define the region
        let region = MKCoordinateRegion(center: location, span: span)
        
        // set the region on the map
        mapView.setRegion(region, animated: true)
        
        // adding annotation for the map
        let annotation = MKPointAnnotation()
        annotation.title = "You're here!"
        annotation.coordinate = location
        mapView.addAnnotation(annotation)
        
        // add double tap gesture
       
        let tap = UITapGestureRecognizer(target: self, action: #selector(doubletapped))
        tap.numberOfTapsRequired = 2
        view.addGestureRecognizer(tap)
        
        // add trople tap to remove the pin
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(remove))
        tap2.numberOfTapsRequired = 3
        view.addGestureRecognizer(tap2)
        
        //add pinchto zoom gesture
         let pinch = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch(sender:)))
              view.addGestureRecognizer(pinch)
    }
    
   
   
    @objc func doubletapped(gestureRecognizer: UIGestureRecognizer) {
        let touchPoint = gestureRecognizer.location(in: mapView)
        let coordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)
        
        let annotation = MKPointAnnotation()
        annotation.title = "Destination"
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)
    }
    
   @objc func handlePinch(sender: UIPinchGestureRecognizer) {
          guard sender.view != nil else { return }
          
          if sender.state == .began || sender.state == .changed {
              sender.view?.transform = (sender.view?.transform.scaledBy(x: sender.scale, y: sender.scale))!
              sender.scale = 1.0
          }
    }
   
    @objc func remove(gestureRecognizer: UIGestureRecognizer) {
       for annotation in mapView.annotations {
                    mapView.removeAnnotation(annotation)
                }
            mapView.removeAnnotations(mapView.annotations)
    }
    @IBAction func findmyway(_ sender: UIButton) {
           //onclick find my way
           
           mapView.removeOverlays(mapView.overlays)
                  
                   let sourcePlaceMark = MKPlacemark(coordinate: locationManager.location!.coordinate)
        let destinationPlaceMark = MKPlacemark(coordinate: destination)
                
                   // request a direction
                   let directionRequest = MKDirections.Request()
                   
                   // define source and destination
                   directionRequest.source = MKMapItem(placemark: sourcePlaceMark)
                   directionRequest.destination = MKMapItem(placemark: destinationPlaceMark)
                   
                   // transportation type
                   directionRequest.transportType = .walking
                   
                   // calculate directions
                   let directions = MKDirections(request: directionRequest)
                   directions.calculate { (response, error) in
                       guard let directionResponse = response else {return}
                       // create route
                       let route = directionResponse.routes[0]
                       // draw the polyline
                       self.mapView.addOverlay(route.polyline, level: .aboveRoads)
                       
                       // defining the bounding map rect
                       let rect = route.polyline.boundingMapRect
           //            self.map.setRegion(MKCoordinateRegion(rect), animated: true)
                       self.mapView.setVisibleMapRect(rect, edgePadding: UIEdgeInsets(top: 100, left: 100, bottom: 100, right: 100), animated: true)
           
       }
}
}
