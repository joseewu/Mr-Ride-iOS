//
//  MrRideModel.swift
//  Mr-Ride-iOS
//
//  Created by josee on 6/12/16.
//  Copyright © 2016 com.josee. All rights reserved.
//



import Foundation
import GoogleMaps
import CoreLocation

struct statisticalModel {
    
    
    var days = [String]()
    var rideDistance = [Double]()
    
    
}


class StatisticalModel {
    
    var _stt = statisticalModel()
    let days = ["1", "2", "3", "4", "5", "6"]
    let rideDistance = [20.0, 4.0, 6.0, 3.0, 12.0, 16.0]
    
    init(){
        
        for i in 0..<days.count {
            _stt.days.append(days[i])
            _stt.rideDistance.append(rideDistance[i])
        }
    }
}