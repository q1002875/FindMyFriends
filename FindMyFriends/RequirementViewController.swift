//
//  RequirementViewController.swift
//  FindMyFriends
//
//  Created by 徐志豪 on 2019/1/3.
//  Copyright © 2019 orange. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
class RequirementViewController: UIViewController{
//    @IBOutlet weak var groupName: UITextField!
    @IBOutlet weak var userName: UITextField!
 
     let locationManager = CLLocationManager()
    var lat: CLLocationDegrees?
    var lon: CLLocationDegrees?
    let defaults = UserDefaults.standard
    
    var guorp :String?
    
    var switechButtonChange = false
    override func viewDidLoad() {
        super.viewDidLoad()
  
        
        guard CLLocationManager.locationServicesEnabled() else{
            //沒有的話給些提示
            return
        }
        
        
        
        //取得user授權
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        
        //期待的精確度 越精確躍耗電
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.activityType = .automotiveNavigation
       locationManager.startUpdatingLocation()
        
        //取得背景多工持續取的位置
       locationManager.allowsBackgroundLocationUpdates = true
      
        lat = locationManager.location?.coordinate.latitude
        lon = locationManager.location?.coordinate.longitude
        
          print("lat\(lat),lon\(lon)")
        
//        guorp = groupName.text!
//        userName.text = "Allen"
        
    }
   
    @IBAction func keepreport(_ sender: UISwitch) {
        if sender.isOn{
            if userName.text == "" {
                let alert = UIAlertController(title: "請輸入userNamer", message: "", preferredStyle: .alert)
                let sure = UIAlertAction(title: "OK", style: .default) { (UIAlertAction) in
                    sender.isOn = false
                }
                alert.addAction(sure)
                
                present(alert, animated: true, completion: nil)
               
            }else{
//                self.defaults.setValue(self.groupName.text, forKeyPath: "Group")
                self.timer(booln: true)
                 switechButtonChange = true
            }


        }else{
            time?.invalidate()
             switechButtonChange = false
        }
        
        
    }
    @IBAction func reportLocation(_ sender: UIButton) {
        if switechButtonChange == true{
            let lightRed = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "lightRed")
          
            self.navigationController?.pushViewController(lightRed, animated: true)
        }else{
             let alert = UIAlertController(title: "請打開即時更新位置開關", message: "", preferredStyle: .alert)
         let sure = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(sure)
            present(alert, animated: true, completion: nil)
        }
    }
 
    func switchWhilereport(){
        
        let appURL = URL(string: "http://class.softarts.cc/FindMyFriends/updateUserLocation.php?GroupName=zz999&UserName=\(self.userName.text ?? "")&Lat=\(lat!)&Lon=\(lon!)")
        
        if let url = appURL{
            
            let session = URLSession.shared
            let request = URLRequest(url:url)
            let task = session.dataTask(with: request) { (data, response, error) in
                
            }
            task.resume()
        }
    }
    
    var  time:Timer? = nil
    func timer(booln:Bool) ->Void{
         self.time = Timer.scheduledTimer(withTimeInterval: 5, repeats: booln) { (Timer) in
            self.switchWhilereport()
        }
        
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
extension RequirementViewController: CLLocationManagerDelegate{
    
    //mark:cllocationmanagerdelegate methods
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let coordinate = locations.last?.coordinate else {
            assertionFailure("Invalid location or coordinate")
            return
        }
        print("Current location:\(coordinate.latitude),\(coordinate.longitude)")
    }
    
}
