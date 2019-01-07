//
//  customPin.swift
//  FindMyFriends
//
//  Created by 徐志豪 on 2019/1/7.
//  Copyright © 2019 orange. All rights reserved.
//

import Foundation

import UIKit
import MapKit
class customPin: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    
    init(pinTitle:String, pinSubTitle:String, location:CLLocationCoordinate2D) {
        self.title = pinTitle
        self.subtitle = pinSubTitle
        self.coordinate = location
    }
}
