//
//  DataTaipei.swift
//  Mr-Ride-iOS
//
//  Created by josee on 6/24/16.
//  Copyright © 2016 com.josee. All rights reserved.
//

import Foundation
import Alamofire
import CoreData
private let managedContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext

private var userDefaltkm = NSUserDefaults.standardUserDefaults()

struct YouBikeModel {
    
    var stationName:String = ""
    var roadName:String = ""
    var remainingBikes:Int = 0
    var lat:Double = 0.0
    var lng:Double  = 0.0
    
    
}

struct ToiletModel {
    
    var toiletName:String = ""
    var address:String = ""
    var types:String = ""
    var lat:Double = 0.0
    var lng:Double  = 0.0
    
}

class DataTaipeiModel {
    
    var youbikeData = [YouBikeModel]()
    var toiletData = [ToiletModel]()
    
    
    
    
    func requestYouBikesFromURL(url:String){
        
        let url2 = "http://data.taipei/youbike"
        Alamofire.request(.GET, url2).validate().responseJSON{ [weak self] response
            in
            if response.result.isSuccess{
                
                if let dataResults = response.result.value as? [String:AnyObject]{
                    self?.parsingYouBikes(dataResults)
                    
                    if let ubikes = NSEntityDescription.insertNewObjectForEntityForName("Ubikes", inManagedObjectContext: managedContext) as? Ubikes{
                        for bike in self!.youbikeData{
                            ubikes.name = bike.stationName
                            ubikes.numbers = bike.remainingBikes
                            ubikes.lat = bike.lat
                            ubikes.long = bike.lng
                            ubikes.roadName = bike.roadName
                            
                        }
                        do{
                            try managedContext.save()
                            userDefaltkm.setBool(true, forKey: "CoreData")
                        }catch{
                            print("Ubikes core Data enconter error!")
                        }
                        
                    }
                }
            }else{
                print("ERROR when getting data \(response.result.error)")
            }
        }
        
    }
    func parsingYouBikes(inputData:[String:AnyObject]){
        
        
        if let retVal = inputData["retVal"] as? [String:AnyObject]{
            for (_,everyStation) in retVal{
                if let eachStation = everyStation as? [String:AnyObject]{
                    
                    var stationName = eachStation["sna"] as? String ?? ""
                    var roadName = eachStation["ar"] as? String ?? ""
                    var lat = eachStation["lat"] as? String ?? "0.0"
                    var lng = eachStation["lng"] as? String ?? "0.0"
                    var remainingBikes = eachStation["sbi"] as? String ?? "0"
                    
                    youbikeData.append(
                        YouBikeModel(
                            stationName: stationName,
                            roadName: roadName,
                            remainingBikes: Int(remainingBikes)!,
                            lat: Double(lat) ?? 0.0,
                            lng: Double(lng) ?? 0.0
                        )
                    )
                    
                }
            }
        }
        
    }
    func requestToiletsFromURL(url:String){
        
        let url2 = "http://data.taipei/opendata/datalist/apiAccess?scope=resourceAquire&rid=008ed7cf-2340-4bc4-89b0-e258a5573be2"
        dispatch_async(dispatch_get_main_queue(),{
            
            
            Alamofire.request(.GET, url2).validate().responseJSON{ [weak self] response in
                if response.result.isSuccess{
                    if let data = response.result.value as? [String:AnyObject]{
                        
                        self?.parcingData(data)
                        
                        if let toilets = NSEntityDescription.insertNewObjectForEntityForName("Toilets", inManagedObjectContext: managedContext) as? Toilets{
                            for toilet in self!.toiletData{
                                
                                toilets.toiletName = toilet.toiletName
                                toilets.lat = toilet.lat
                                toilets.long = toilet.lng
                                toilets.address = toilet.toiletName
                                
                            }
                            do{
                                try managedContext.save()
                                userDefaltkm.setBool(true, forKey: "CoreData")
                            }catch{
                                print("Toilet core Data enconter error!")
                            }
                            
                            
                        }
                        
                    }
                    
                }else{
                    print("ERROR when getting data \(response.result.error)")
                }
                
            }
        })
        
    }
    
    func parcingData(inputData:[String:AnyObject]){
        
        if let partResult = inputData["result"] as? [String:AnyObject]{
            if let results = partResult["results"] as? [[String:AnyObject]]{
                
                let numbersOfToilets = results.count
                for k in 0..<numbersOfToilets {
                    
                    let eachToilet = results[k]
                    var toiletName = eachToilet["單位名稱"] as! String
                    var address = eachToilet["地址"] as! String
                    var types = eachToilet["類別"] as! String
                    var lat = eachToilet["緯度"] as? String ?? "0.0"
                    var lng = eachToilet["經度"] as? String ?? "0.0"
                    self.toiletData.append(
                        
                        ToiletModel(
                            
                            toiletName: toiletName,
                            address: address,
                            types: types,
                            lat: Double(lat)!,
                            lng: Double(lng)!
                        )
                    )
                }
            }
        }
        
    }
    
    func cleanUpToiletsData(){
        
        let request = NSFetchRequest(entityName: "Toilets")
        
        do {
            
            let records:NSArray = try managedContext.executeFetchRequest(request)
            
            for record in records {
                
                managedContext.deleteObject(record as! NSManagedObject)
                
            }
            do{
                try managedContext.save()
                userDefaltkm.setBool(false, forKey: "CoreData")
            }catch{
                
                fatalError("Failure to save context: \(error)")
            }
            
            
        }catch{
            fatalError("Failure to fetch data: \(error)")
        }
        
        
    }
    func cleanUpUbikesData(){
        
        let request = NSFetchRequest(entityName: "Ubikes")
        
        do {
            
            let records:NSArray = try managedContext.executeFetchRequest(request)
            
            
            
            for record in records {
                
                managedContext.deleteObject(record as! NSManagedObject)
                
            }
            do{
                try managedContext.save()
                userDefaltkm.setBool(false, forKey: "CoreData")
                
            }catch{
                
                fatalError("Failure to save context: \(error)")
            }
            
            
        }catch{
            fatalError("Failure to fetch data: \(error)")
        }
        
        
    }
    
}
