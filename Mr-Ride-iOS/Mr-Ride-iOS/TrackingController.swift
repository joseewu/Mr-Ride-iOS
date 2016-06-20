//
//  TrackingController.swift
//  Mr-Ride-iOS
//
//  Created by josee on 6/12/16.
//  Copyright © 2016 com.josee. All rights reserved.
//


import UIKit
import QuartzCore
import GoogleMaps
import CoreLocation
import HealthKit
import CoreData
import SWRevealViewController


class TrackingController:UIViewController,CLLocationManagerDelegate,GMSMapViewDelegate{
    
    
    @IBOutlet weak var finishBut: UIButton!
    @IBOutlet weak var cancelBut: UIButton!
    
    @IBOutlet weak var startPaulseBut: UIButton!
    
    @IBOutlet weak var timerOutpu: UITextField!
    
    
    @IBOutlet weak var mapView: GMSMapView!
    
    @IBOutlet weak var distanceDefault: UILabel!
    @IBOutlet weak var speedDefault: UILabel!
    @IBOutlet weak var caloriesDefault: UILabel!
    
    @IBOutlet weak var showDistance: UILabel!
    @IBOutlet weak var showSpeed: UILabel!
    @IBOutlet weak var showCalories: UILabel!
    
    
    private let gradientLayer1 = CAGradientLayer()
    private let gradientLayer2 = CAGradientLayer()
    private var counting = false
    private var timer = NSTimer()
    private var seconds = 0
    private var distance = 0.0
    private var speed = 0.0
    private var cal = 0.0
    private var date = NSDate()
    private var currentLocation = CLLocation()
    private let path = GMSMutablePath()
    private var locationsInRiding = [CLLocation]()
    private var locationsInCoreData = [CLLocation]()
    private var count:Int = 0
    private var long = [[Double]]()
    private var longTempArray = [Double]()
    private var latTempArray = [Double]()
    private var lat = [[Double]]()
    private var locationManager = CLLocationManager()
    //private let managedContext = AppDelegate().managedObjectContext
    private let managedContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.activityType = .Fitness
        self.locationManager.distanceFilter = 10.0
        setUpNavigationBar()
        setUpGardientLayer()
        setupButtons()
        setUpLabels()
        setUp()
        showMap()
        cleanUpCoreData()
        
        
        
        
        
    }
    
    
    override func viewDidAppear(animated: Bool) {
        
    }
    
    
    func setUpDate(date:NSDate)->(year:String,Month:String, day:String){
        
        var Today = date.description as NSString
        var year = Today.substringWithRange(NSRange(location: 0, length: 4))
        var month = Today.substringWithRange(NSRange(location: 5, length: 2))
        var day = Today.substringWithRange(NSRange(location: 8, length: 2))
        return (year,month,day)
        
    }
    func setUp(){
        timerOutpu.backgroundColor = UIColor.clearColor()
        timerOutpu.textColor = UIColor.whiteColor()
    }
    func setUpLabels(){
        
        
        
        distanceDefault.text = "Distance"
        speedDefault.text = "Average Speed"
        caloriesDefault.text = "Calories"
        distanceDefault.textColor = UIColor.whiteColor()
        speedDefault.textColor = UIColor.whiteColor()
        caloriesDefault.textColor = UIColor.whiteColor()
        distanceDefault.font = UIFont.mrTextStyle20Font()
        speedDefault.font = UIFont.mrTextStyle20Font()
        caloriesDefault.font = UIFont.mrTextStyle20Font()
        
        
        
        
        
        showDistance.textColor = UIColor.whiteColor()
        showDistance.text = "0"
        showSpeed.textColor = UIColor.whiteColor()
        showSpeed.text = "0"
        showCalories.textColor = UIColor.whiteColor()
        showCalories.text = "0"
        showCalories.font = UIFont.mrTextStyle15Font()
        showSpeed.font = UIFont.mrTextStyle15Font()
        showDistance.font = UIFont.mrTextStyle15Font()
    }
    
    func showMap(){
        
        
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        if CLLocationManager.locationServicesEnabled()
            && CLLocationManager.authorizationStatus() == CLAuthorizationStatus.AuthorizedWhenInUse {
                mapView.delegate = self
                mapView.myLocationEnabled = true
                mapView.settings.myLocationButton = true
                locationManager.startUpdatingLocation()
                
                
                
        }
        
        
        
        
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.AuthorizedWhenInUse {
            
        }
    }
    
    
    func setupButtons(){
        
        cancelBut.setTitle("Cancel", forState: .Normal)
        finishBut.setTitle("Finish", forState: .Normal)
        cancelBut.titleLabel?.font = UIFont.mrTextStyle18Font()
        finishBut.titleLabel?.font = UIFont.mrTextStyle17Font()
        cancelBut.tintColor = UIColor.whiteColor()
        finishBut.tintColor = UIColor.whiteColor()
        startPaulseBut.layer.backgroundColor = UIColor.redColor().CGColor
        
        
    }
    
    func setUpGardientLayer(){
        
        gradientLayer1.frame = view.bounds
        gradientLayer2.frame = view.bounds
        gradientLayer1.colors = [UIColor.mrLightblueColor().CGColor, UIColor.mrLightblueColor().CGColor]
        gradientLayer2.colors = [UIColor.mrBlack60Color().CGColor, UIColor.mrBlack40Color().CGColor]
        
        view.layer.insertSublayer(gradientLayer1, atIndex: 0)
        view.layer.insertSublayer(gradientLayer2, atIndex: 1)
        
    }
    
    func setUpNavigationBar(){
        
        var today = setUpDate(date)
        self.navigationController?.navigationBar.barTintColor = UIColor.mrLightblueColor()
        self.navigationController?.navigationBar.topItem?.title = today.year + " / " + today.Month + " / " + today.day
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName:UIFont.mrTextStyle17Font(),NSForegroundColorAttributeName:UIColor.whiteColor()]
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarPosition: .Any, barMetrics: .Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
    }
    
    func showTime(){
        
        seconds += 1
        
        //please implement the method to show the format of time
        timerOutpu.text = "\(seconds)"
        self.speed = (distance / Double(seconds)) * 3.6;
        cal = calculateCal(self.speed)
        
    }
    func calculateCal(Cv:Double)->Double{
        
        
        var constance = Cv * 0.497
        var calEstimated = (((3.509)*constance + (0.2581) * pow(constance,3)) / (69.78)) / (0.25)
        return calEstimated
    }
    func startCountingTime(){
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("showTime"), userInfo: nil, repeats: true)
    }
    func stopCountingTime(){
        timer.invalidate()
    }
    
    @IBAction func dimissCurrentView(sender: UIButton) {
        
        var presentingViewController: UIViewController! = self.presentingViewController
        self.dismissViewControllerAnimated(false) {
            // go back to MainMenuView
            presentingViewController.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location  = locations.first{
            
            
            if location.horizontalAccuracy < 20{
                
                mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
                
                self.currentLocation = location
                
                if counting == false {
                    
                    self.locationsInRiding.append(self.currentLocation)
                    distance += location.distanceFromLocation(self.currentLocation)
                    
                }else{
                    
                    self.locationsInCoreData.append(self.currentLocation)
                    self.longTempArray.append(self.currentLocation.coordinate.longitude)
                    
                    self.latTempArray.append(self.currentLocation.coordinate.latitude)
                    distance += location.distanceFromLocation(self.locationsInRiding.last!)
                    
                    self.locationsInRiding.append(self.currentLocation)
                    
                    drawRoute()
                    
                    
                }
                
                
                
            }
            
            // print("current: \(self.currentLocation)")
            //print("keepTracking: \(self.locationsInRiding)")
            
        }
        updatingRidingInfo()
    }
    
    
    
    func saveWhenFinish(){
        
        let records = NSEntityDescription.insertNewObjectForEntityForName("RunRecords", inManagedObjectContext: managedContext) as! RunRecords
        let saveDate = self.navigationController?.navigationBar.topItem?.title
        records.setValue("\(saveDate!)", forKey: "date")
        records.setValue(seconds, forKey: "time")
        records.setValue(distance, forKey: "distance")
        records.setValue(self.lat, forKey: "lat")
        records.setValue(self.long, forKey: "long")
        records.setValue(self.cal, forKey: "cal")
        
        do {
            try self.managedContext.save()
        }catch{
            
            fatalError("Failure to save context: \(error)")
        }
        
        
        
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
    
    func drawRoute(){
        
        let lastLocationCord = CLLocationCoordinate2DMake(self.currentLocation.coordinate.latitude, self.currentLocation.coordinate.longitude)
        let firstLocation = self.locationsInRiding.last!
        let firstLocationCord = CLLocationCoordinate2DMake(firstLocation.coordinate.latitude, firstLocation.coordinate.longitude)
        path.addCoordinate(firstLocationCord)
        path.addCoordinate(lastLocationCord)
        let polyline = GMSPolyline(path: path)
        polyline.strokeColor = UIColor.mrBubblegumColor()
        polyline.strokeWidth = 9.0
        polyline.map = mapView
    }
    
    func updatingRidingInfo(){
        
        showDistance.text = "\(Int(distance))" + " m"
        showSpeed.text = String(format: "%.2f", self.speed) + " km / h"
        showCalories.text = String(format: "%.02f", self.cal) + " kcal"
        
    }
    @IBAction func didPressBut(sender: UIButton){
        
        
        if counting == false{
            
            
            locationManager.startUpdatingLocation()
            startCountingTime()
            UIView.animateWithDuration(0.6 ,
                animations: {
                    
                    self.startPaulseBut.transform = CGAffineTransformMakeScale(2, 2)
                    
                    //                    self.startPaulseBut.layer.cornerRadius = self.startPaulseBut.frame.size.width/2;
                    self.startPaulseBut.layer.masksToBounds = true;
                    self.startPaulseBut.clipsToBounds = true;
                    //                    let animation = CABasicAnimation(keyPath: "cornerRadius")
                    //
                    //                    animation.fromValue = 4
                    //                    animation.toValue = 30;
                    //                    animation.duration = 0.6
                    //                    self.startPaulseBut.layer.addAnimation(animation, forKey: "cornerRadius")
                    
                    
                },
                completion: { finish in
                    UIView.animateWithDuration(0.6){
                        
                    }
            })
            counting = true
            
        }else{
            
            //locationManager.requestAlwaysAuthorization()
            //locationManager.stopUpdatingLocation()
            
            stopCountingTime()
            self.long.append(self.longTempArray)
            self.lat.append(self.latTempArray)
            self.longTempArray.removeAll()
            self.latTempArray.removeAll()
            
            UIView.animateWithDuration(0.6 ,
                animations: {
                    self.startPaulseBut.transform = CGAffineTransformIdentity
                    
                },
                completion: { finish in
                    UIView.animateWithDuration(0.6){
                        
                    }
            })
            
            counting = false
        }
        
    }
    @IBAction func transferToFinish(sender: UIButton) {
        
        
        saveWhenFinish()
        
        //var vc = self.storyboard?.instantiateViewControllerWithIdentifier("FinishedController") as! FinishedController
        
        //self.navigationController?.pushViewController(vc, animated: true)
        //        self.navigationController?.presentViewController(vc, animated: true, completion: nil)
        let navigationController = self.storyboard?.instantiateViewControllerWithIdentifier("FinishNavi")
        self.presentViewController(navigationController!, animated: true, completion: nil)
        //        let navigationController = self.storyboard?.instantiateViewControllerWithIdentifier("FinishNavi") as! UINavigationController
        //        let  segueToFinished = SWRevealViewControllerSeguePushController.init(identifier: SWSegueRightIdentifier, source: self, destination: navigationController)
        //        segueToFinished.perform()
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillDisappear(animated: Bool) {
        
        
    }
    override func viewDidDisappear(animated: Bool) {
        stopCountingTime()
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
