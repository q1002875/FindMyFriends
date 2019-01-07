//
//  MotionTrackViewController.swift
//  FindMyFriends
//
//  Created by 徐志豪 on 2019/1/7.
//  Copyright © 2019 orange. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
class MotionTrackViewController: UIViewController,MKMapViewDelegate{
    let locationManager = CLLocationManager()
    var lat: CLLocationDegrees?
    var lon: CLLocationDegrees?
    var endLat: CLLocationDegrees?
    var endLon: CLLocationDegrees?
    
    
    @IBOutlet weak var mapview: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
       
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.activityType = .automotiveNavigation
        locationManager.startUpdatingLocation()
        
        //取得背景多工持續取的位置
        locationManager.allowsBackgroundLocationUpdates = true
        
        lat = locationManager.location?.coordinate.latitude
        lon = locationManager.location?.coordinate.longitude
       
        print("start\(lat),\(lon)")
        
        
     print("end\(self.endLat),\(self.endLon)")
        
        DispatchQueue.main.async {
               print("end\(self.endLat),\(self.endLon)")
            
            Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { (Timer) in
                self.MoveDestination()
            }
           
        }
        
        
        
        locationManager.delegate = self
    }
    
    func MoveDestination(){
     
            let sourceLocation = CLLocationCoordinate2D(latitude:self.lat! , longitude: self.lon!)
            
            //結束的點
            let destinationLocation = CLLocationCoordinate2D(latitude:self.endLat! , longitude: self.endLon!)
            
//            let startPin = customPin(pinTitle: "起點", pinSubTitle: "", location: sourceLocation)
//            let endPin = customPin(pinTitle: "", pinSubTitle: "", location: destinationLocation)
//
//                self.mapview.addAnnotation(startPin)
//                self.mapview.addAnnotation(endPin)
      
            let sourcePlaceMark = MKPlacemark(coordinate: sourceLocation)
            let destinationPlaceMark = MKPlacemark(coordinate: destinationLocation)
            
            let directionRequest = MKDirections.Request()
            directionRequest.source = MKMapItem(placemark: sourcePlaceMark)
            directionRequest.destination = MKMapItem(placemark: destinationPlaceMark)
            directionRequest.transportType = .automobile
            
            let directions = MKDirections(request: directionRequest)
            directions.calculate { (response, error) in
                guard let directionResonse = response else {
                    if let error = error {
                        print("we have error getting directions==\(error.localizedDescription)")
                    }
                    return
                }
              
                    let route = directionResonse.routes[0]
                    self.mapview.addOverlay(route.polyline, level: .aboveRoads)
                    
                    let rect = route.polyline.boundingMapRect
                    self.mapview.setRegion(MKCoordinateRegion(rect), animated: true)
                

             
                
           
        }
        //起點
      
        
        //增加兩個點
      
        
        
            
        
        
        self.mapview.delegate = self
    }
    
    
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.green
        renderer.lineWidth = 5.0
        return renderer
    }
    
  
    
}
extension MotionTrackViewController: CLLocationManagerDelegate{
    
    //mark:cllocationmanagerdelegate methods
  
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let coordinate = locations.last?.coordinate else {
            assertionFailure("Invalid location or coordinate")
            return
        }
        
     endLat = locations.last?.coordinate.latitude
     endLon =  locations.last?.coordinate.longitude
        
        print("Current location:\(coordinate.latitude),\(coordinate.longitude)")
    }
    
}
