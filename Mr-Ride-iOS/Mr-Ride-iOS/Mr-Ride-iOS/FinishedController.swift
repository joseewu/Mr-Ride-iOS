//
//  FinishedController.swift
//  Mr-Ride-iOS
//
//  Created by josee on 6/12/16.
//  Copyright © 2016 com.josee. All rights reserved.
//

import UIKit
import CoreData
import GoogleMaps
import CoreLocation


class FinishedController: UIViewController,CLLocationManagerDelegate,GMSMapViewDelegate{
    
    
    
    @IBOutlet weak var mapView: GMSMapView!
    let gradientLayer1 = CAGradientLayer()
    let gradientLayer2 = CAGradientLayer()
    private let managedContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    
    private var locationManager = CLLocationManager()
    @IBOutlet weak var BackToHome: UIButton!
    
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label3: UILabel!
    @IBOutlet weak var label4: UILabel!
    @IBOutlet weak var label5: UILabel!
    
    @IBOutlet weak var Distance: UILabel!
    @IBOutlet weak var Speed: UILabel!
    @IBOutlet weak var Calories: UILabel!
    @IBOutlet weak var Time: UILabel!
    
    
    
    private var long = [Double]()
    private var lat = [Double]()
    private var date:String = ""
    private var distance = 0.0
    private var speed = 0.0
    private var seconds = 0
    private var cal = 0.0
    private var location = CLLocation()
    private var longForPath = [[Double]]()
    private var latForPath = [[Double]]()
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.activityType = .Fitness
        self.locationManager.distanceFilter = 10.0
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        
        self.mapView.delegate = self
        
        loadCoreData()
        setUpGardientLayer()
        setUpCloseButton()
        
        setUpLabels()
        
        drawRoute(self.latForPath,locationLong: self.longForPath)
        
        setUpNavigationBar()
        
    }
    
    func setUpLabels(){
        
        
        
        label1.text = "Distance"
        label2.text = "Average Speed"
        label3.text = "Calories"
        label4.text = "Total Time"
        label5.text = "Good Job!"
        label1.textColor = UIColor.whiteColor()
        label2.textColor = UIColor.whiteColor()
        label3.textColor = UIColor.whiteColor()
        label4.textColor = UIColor.whiteColor()
        label5.textColor = UIColor.whiteColor()
        label1.font = UIFont.mrTextStyle20Font()
        label2.font = UIFont.mrTextStyle20Font()
        label3.font = UIFont.mrTextStyle20Font()
        label4.font = UIFont.mrTextStyle20Font()
        label5.font = UIFont.mrTextStyle20Font()
        
        
        
        
        
        Distance.textColor = UIColor.whiteColor()
        
        Distance.text = String(format: "%.02f", self.distance)
        Speed.textColor = UIColor.whiteColor()
        Speed.text = String(format: "%.02f", self.speed)
        Calories.textColor = UIColor.whiteColor()
        Calories.text = String(format: "%.02f", self.cal)
        Calories.font = UIFont.mrTextStyle15Font()
        Speed.font = UIFont.mrTextStyle15Font()
        Distance.font = UIFont.mrTextStyle15Font()
        Time.text = "\(self.seconds)"
        Time.textColor = UIColor.whiteColor()
        Time.font = UIFont.mrTextStyle15Font()
    }
    func showMap(){
        
        //finishCordLat =
        let finishCord = CLLocationCoordinate2DMake(self.lat.last!, self.long.last!)
        mapView.camera = GMSCameraPosition(target: finishCord, zoom: 15, bearing: 0, viewingAngle: 0)
    }
    
    
    
    func drawRoute(locationLat: [[Double]], locationLong: [[Double]]){
        print(locationLat)
        showMap()
        
        var path = GMSMutablePath()
        for i in 0..<locationLat.count {
            
            
            
            let firstLocationCord = CLLocationCoordinate2DMake(locationLat[i].first!, locationLong[i].first!)
            
            let lastLocationCord = CLLocationCoordinate2DMake(locationLat[i].last!, locationLong[i].last!)
            path.addCoordinate(firstLocationCord)
            path.addCoordinate(lastLocationCord)
            let polyline = GMSPolyline(path: path)
            polyline.strokeColor = UIColor.mrBubblegumColor()
            polyline.strokeWidth = 9.0
            polyline.map = mapView
            
            path.removeAllCoordinates()
        }
        
    }
    
    
    
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.AuthorizedWhenInUse {
            
        }
    }
    func setUpCloseButton(){
        BackToHome.titleLabel?.font = UIFont.mrTextStyle18Font()
        BackToHome.tintColor = UIColor.whiteColor()
    }
    func setUpNavigationBar(){
        
        
        self.navigationController?.navigationBar.barTintColor = UIColor.mrLightblueColor()
        self.navigationController?.navigationBar.topItem?.title = self.date
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName:UIFont.mrTextStyle17Font(),NSForegroundColorAttributeName:UIColor.whiteColor()]
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarPosition: .Any, barMetrics: .Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
    }
    
    
    @IBAction func dismissToHome(sender: UIButton) {
        
        
        var presentingViewController: UIViewController! = self.presentingViewController
        
        self.dismissViewControllerAnimated(false) {
            // go back to MainMenuView
            presentingViewController.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    
    func loadCoreData(){
        
        let request = NSFetchRequest(entityName: "RunRecords")
        request.returnsObjectsAsFaults = false
        do {
            
            let records:NSArray = try managedContext.executeFetchRequest(request) as! [RunRecords]
            
            if records.count > 0 {
                
                let record  = records.lastObject
                
                self.date = (record!.valueForKey("date") as! String)
                var lat = (record!.valueForKey("lat") as! [[Double]]).last
                var latarg = record!.valueForKey("lat") as! [[Double]]
                var longarg = record!.valueForKey("long") as! [[Double]]
                var long = (record!.valueForKey("long") as! [[Double]]).last
                self.cal = (record!.valueForKey("cal") as! Double)
                self.distance = (record!.valueForKey("distance") as! Double)
                self.seconds = (record!.valueForKey("time") as! Int)
                
                if self.seconds == 0 {
                    self.speed = 0
                }else{
                    
                    self.speed = (self.distance / Double(self.seconds))*3.6
                    
                    parPolyline(lat: latarg,long: longarg)
                    
                    
                }
                if (lat?.last != nil && long?.last != nil){
                    
                    self.lat = lat!
                    self.long = long!
                    
                    
                }else{
                    locationManager.startUpdatingLocation()
                    
                    
                }
                
            }
            
            
        }catch{
            
            
            
            
        }
    }
    
    func parPolyline(lat arg1: [[Double]],long arg2: [[Double]]){
        
        
        for i in 0..<arg1.count {
            
            if arg1[i].count == 1 {
                
                
                //                self.latForPath[i].append(arg1[i].first!)
                //                self.latForPath[i].append(arg1[i].first!)
                var lat1 = arg1[i].first!
                var long1 = arg2[i].first!
                
                self.latForPath.append([lat1,lat1])
                self.longForPath.append([long1,long1])
                
            }else{
                
                var latRemovingNil = arg1[i].filter { $0 != nil }
                var longRemovingNil = arg2[i].filter { $0 != nil }
                
                var lat1 = latRemovingNil.first!
                var long1 = longRemovingNil.first!
                var lat2 = latRemovingNil.last!
                var long2 = longRemovingNil.last
                self.latForPath.append([lat1,lat2])
                self.longForPath.append([long1,long2!])
                
            }
            
        }
        
        
        
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        
        var currentLongIfIsNil = locations.first?.coordinate.longitude
        var currentLatIfIsNil = locations.first?.coordinate.latitude
        self.lat = [currentLatIfIsNil!]
        self.long = [currentLongIfIsNil!]
        
        locationManager.stopUpdatingLocation()
        showMap()
        
    }
    private func cleanUpCoreData(){
        
        let request = NSFetchRequest(entityName: "RunRecords")
        
        do {
            
            let records:NSArray = try managedContext.executeFetchRequest(request)
            
            
            
            for record in records {
                
                managedContext.deleteObject(record as! NSManagedObject)
                
            }
            do{
                try managedContext.save()
                
            }catch{
                
                fatalError("Failure to save context: \(error)")
            }
            
            
        }catch{
            
            
            fatalError("Failure to fetch data: \(error)")
            
        }
        
        
    }
    
    func setUpGardientLayer(){
        
        gradientLayer1.frame = view.bounds
        gradientLayer2.frame = view.bounds
        gradientLayer1.colors = [UIColor.mrLightblueColor().CGColor, UIColor.mrLightblueColor().CGColor]
        gradientLayer2.colors = [UIColor.mrBlack60Color().CGColor, UIColor.mrBlack40Color().CGColor]
        
        view.layer.insertSublayer(gradientLayer1, atIndex: 0)
        view.layer.insertSublayer(gradientLayer2, atIndex: 1)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
