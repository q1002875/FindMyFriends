//
//  FindMyFriendViewController.swift
//  FindMyFriends
//
//  Created by 徐志豪 on 2019/1/3.
//  Copyright © 2019 orange. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
struct name:Decodable {
  
    
    let result:Bool
    let friends:[findfriends]
  
}
struct findfriends:Decodable {
   let id:String
   let friendName:String
   let lat:String
   let lon:String
   let lastUpdateDateTime:String
    
}

class FindMyFriendViewController: UIViewController {
   
    @IBOutlet weak var mapview: MKMapView!
    let defaults = UserDefaults.standard
    struct currentfriends {
        var id:[String] = []
        var friendName:[String] = []
        var lat:[String] = []
        var lon:[String] = []
        var lastUpdateDateTime:[String] = []
    }
    var group :String!
    var cuurentfind = currentfriends()
    override func viewDidLoad() {
        super.viewDidLoad()
        guard defaults.string(forKey: "Group") != nil else{return}
   group = defaults.string(forKey: "Group")!
       
        timer(booln: true)
        
       print(self.group)
    }
    var currentpoint :String = ""
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let annotation = view.annotation as? myAnnotation {
            currentpoint = annotation.title!
        }
    }
    var  time:Timer? = nil
    func timer(booln:Bool) ->Void{
        self.time = Timer.scheduledTimer(withTimeInterval: 5, repeats: booln) { (Timer) in
            self.findFriends()
        }
        
    }
    var coordinate: [CLLocationCoordinate2D]?
    func findFriends(){
        let url = "http://class.softarts.cc/FindMyFriends/queryFriendLocations.php?GroupName=zz999"
        
        if let url = URL(string: url){
            
            let session = URLSession.shared
            let request = URLRequest(url:url)
            let task = session.dataTask(with: request) { (data, response, error) in
                do{
                let address = try JSONDecoder().decode(name.self, from: data!)
                    for coun in address.friends{
                       self.cuurentfind.id.append(coun.id)
                         self.cuurentfind.friendName.append(coun.friendName)
                         self.cuurentfind.lat.append(coun.lat)
                         self.cuurentfind.lon.append(coun.lon)
                         self.cuurentfind.lastUpdateDateTime.append(coun.lastUpdateDateTime)
                       
                    }
                    var cllcoordtype:CLLocationCoordinate2D?
                    for coord in address.friends{
                        cllcoordtype = CLLocationCoordinate2DMake(Double(coord.lat)!, Double(coord.lon)!)
                        print(cllcoordtype!)
                        let anno = myAnnotation()
                        anno.coordinate = cllcoordtype!
                        anno.title = coord.friendName
                        DispatchQueue.main.async {
                            self.mapview.addAnnotation(anno)
                        }
                        
        
                    }

                    }catch{
                        
                        
                    }
                
                
            }
            task.resume()
        }
        
        
        
    }

}
extension FindMyFriendViewController: MKMapViewDelegate{
    class myAnnotation: MKPointAnnotation {
       
        var address: String = ""
        var latitude: String = ""
        var longitude: String = ""

}
}
