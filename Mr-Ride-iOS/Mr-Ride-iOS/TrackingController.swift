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
import Soundcloud
import AVFoundation


class TrackingController:UIViewController,CLLocationManagerDelegate,GMSMapViewDelegate,AVAudioPlayerDelegate{
    
    
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
    
    @IBOutlet weak var BG1: UIView!
    
    @IBOutlet weak var soundCloudbut: UIButton!
    
    
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
    private var sortingDate:String = ""
    private var startTime: NSDate?
    private var userDefaltkm = NSUserDefaults.standardUserDefaults()
    private var summationDistance:Double?
    private var trackplay:AVAudioPlayer!
    var fromTracking:Bool?
    //private var player:AVAudioPlayer!
    private var user:User?{
        didSet{
            //getUserTracks()
            getUserFavorites()
        }
    }
    
    private var userTracks:[Track]?{
        didSet{
            
            streamPlayBack(userTracks)
        }
    }
    private var imgURL:NSURL?
    var intervalBeforPause: NSTimeInterval = 0
    var store:NSTimeInterval = 0
    
    
    
    
    
    //private let managedContext = AppDelegate().managedObjectContext
    private let managedContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (userDefaltkm.objectForKey("TotalDistance")  == nil){
            summationDistance = 0.0
            self.count = 0
        }else{
            //print("did clear!")
            summationDistance = userDefaltkm.doubleForKey("TotalDistance")
            self.count = userDefaltkm.integerForKey("Times")
            //userDefaltkm.setDouble(0.0, forKey: "TotalDistance")
            //userDefaltkm.setDouble(0.0, forKey: "Times")
            //userDefaltkm.synchronize()
        }
        //print(summationDistance)
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
        //cleanUpCoreData()
        
        
        
        
        
    }
    
    

    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        self.userTracks?.removeFirst()
        self.streamPlayBack(self.userTracks)
        
    }
    func setUpDate(date:NSDate)->(year:String,Month:String, day:String){
        
        let Today = date.description as NSString
        let year = Today.substringWithRange(NSRange(location: 0, length: 4))
        let month = Today.substringWithRange(NSRange(location: 5, length: 2))
        let day = Today.substringWithRange(NSRange(location: 8, length: 2))
        return (year,month,day)
        
    }
    func setUp(){
        timerOutpu.text = "00:00:00:00"
        timerOutpu.backgroundColor = UIColor.clearColor()
        timerOutpu.borderStyle = .None
        timerOutpu.textColor = UIColor.whiteColor()
        timerOutpu.font = UIFont.mrRobot()
        timerOutpu.textAlignment = NSTextAlignment.Center
        
        BG1.backgroundColor = UIColor.clearColor()
        BG1.layer.cornerRadius = BG1.frame.width/2
        BG1.layer.borderWidth = 5
        BG1.layer.borderColor = UIColor.whiteColor().CGColor
        
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
        self.startPaulseBut.layer.cornerRadius = 30;
        soundCloudbut.layer.cornerRadius = 40
        soundCloudbut.backgroundColor = UIColor.mrRobinsEggBlueColor()
        
        soundCloudbut.setImage(UIImage(named: "soundCloudlogo"), forState: .Normal)
        
        
    }
    
    @IBAction func SClogIn(sender: UIButton) {
       
        dispatch_async(dispatch_get_main_queue()) {
            Session.login(self, completion: { [weak self] result -> Void in
                
                if (result.response.isSuccessful){self!.getUser()}
                
                })

            
        }
        
        
    }
    func getUser(){
        
        Soundcloud.session?.me({ [weak self] result  in
            
            self!.user = result.response.result
            if let user = result.response.result {
                print("getting user")
                
                
                let imag = UIImageView(image: UIImage(data: NSData(contentsOfURL: user.avatarURL.cropURL!)!))
                imag.frame = self!.soundCloudbut.frame
                imag.layer.masksToBounds = true
                imag.layer.cornerRadius = self!.soundCloudbut.frame.height / 2
                imag.contentMode = .ScaleAspectFit
                self?.view.addSubview(imag)
                
                
            }
            
            })
        
        
    }
    func getUserTracks(){
        
        dispatch_async(dispatch_get_main_queue(),{
        
        self.user?.tracks({[weak self] respondsTrack in
            
            if respondsTrack.response.isSuccessful{
                self?.userTracks = respondsTrack.response.result
            }
            
            })
        })
        
    }
    
    func getUserFavorites(){
        
          dispatch_async(dispatch_get_main_queue(),{
        
        self.user?.favorites({[weak self] results in
            if results.response.isSuccessful{
                self?.userTracks = results.response.result
            }
        })

        })
    }
    
    func streamPlayBack(tracklists:[Track]?){
        
        //let trackCount = tracklists?.count
        
        let trackUrl = tracklists?.first?.streamURL
        

        trackplay = try? AVAudioPlayer(data: NSData(contentsOfURL: trackUrl!)!)
        trackplay.delegate = self

        trackplay.rate = 1.0
        trackplay.volume = 1.0
        trackplay.prepareToPlay()
        trackplay.play()
 
        
        
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
        
        let today = setUpDate(date)
        self.navigationController?.navigationBar.barTintColor = UIColor.mrLightblueColor()
        self.navigationController?.navigationBar.topItem?.title = today.year + " / " + today.Month + " / " + today.day
        self.sortingDate = today.Month + "/" + today.day
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName:UIFont.mrTextStyle17Font(),NSForegroundColorAttributeName:UIColor.whiteColor()]
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarPosition: .Any, barMetrics: .Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
    }
    
    
    func calculateCal(time:UInt8)->Double{
        
        let carlCal = CalorieCalculator()
        let calEstimated = carlCal.kiloCalorieBurned(.Bike, speed: self.speed, weight: 50.0, time: Double(time)/3600)
        return calEstimated
    }
    
    
    
    
    func updateTime(){
        
        
        
        
        var countingTime:NSTimeInterval = -self.startTime!.timeIntervalSinceNow + self.intervalBeforPause
        store = countingTime
        let hour = UInt8(countingTime / 3600.0)
        countingTime -= (NSTimeInterval(hour) * 3600.0)
        let minutes = UInt8(countingTime / 60.0)
        countingTime -= (NSTimeInterval(minutes) * 60)
        let sec = UInt8(NSTimeInterval(countingTime))
        countingTime -= NSTimeInterval(sec)
        let msecond  = UInt8(countingTime * 100.0)
        let strHour = String(format: "%02d", hour)
        let strMinus = String(format: "%02d", minutes)
        let strSec = String(format: "%02d", sec)
        let strMsec = String(format: "%02d", msecond)
        
        timerOutpu.text = strHour + ":" + strMinus + ":" + strSec + ":" + strMsec
        
        self.speed = (distance / Double(sec)) * 3.6;
        self.cal = calculateCal(sec)
        
        
    }
    func startCountingTime(){
        
        self.startTime = NSDate()
        timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: Selector("updateTime"), userInfo: nil, repeats: true)
        
    }
    func stopCountingTime(){
        self.intervalBeforPause = store
        self.seconds += Int(self.intervalBeforPause)
        store = 0
        timer.invalidate()
    }
    
    @IBAction func dimissCurrentView(sender: UIButton) {
        
        let presentingViewController: UIViewController! = self.presentingViewController
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
            
        }
        updatingRidingInfo()
    }
    
   
    
    func saveWhenFinish(){
        
        
        if (trackplay != nil){
            trackplay.pause()
        }
        
        if (self.long.isEmpty || self.long.isEmpty) {
            self.long.insert([0], atIndex: 0)
            self.lat.insert([0], atIndex: 0)
        }
        
        let records = NSEntityDescription.insertNewObjectForEntityForName("RunRecords", inManagedObjectContext: managedContext) as! RunRecords
        let saveDate = self.navigationController?.navigationBar.topItem?.title
        
        records.setValue("\(saveDate!)", forKey: "date")
        records.setValue(self.seconds, forKey: "time")
        records.setValue(self.distance, forKey: "distance")
        records.setValue(self.lat, forKey: "lat")
        records.setValue(self.long, forKey: "long")
        records.setValue(self.cal, forKey: "cal")
        records.setValue(self.sortingDate, forKey: "sortingDate")
        records.setValue(self.timerOutpu.text, forKey: "timeString")
        do {
            try self.managedContext.save()
        }catch{
            
            fatalError("Failure to save context: \(error)")
        }
        
        self.count += 1
        
        self.summationDistance! += self.distance
        
        userDefaltkm.setDouble(self.summationDistance!, forKey: "TotalDistance")
        userDefaltkm.setInteger(self.count, forKey: "Times")
        userDefaltkm.synchronize()
        
        
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
                    
                    self.startPaulseBut.transform = CGAffineTransformMakeScale(0.5, 0.5)
                    UIView.animateWithDuration(0.1 ,
                        animations: {
                            
                            //                            self.startPaulseBut.layer.cornerRadius = 10;
                            //                            self.startPaulseBut.layer.masksToBounds = true;
                            //                            self.startPaulseBut.clipsToBounds = true;
                            
                        },
                        completion: { finish in
                            UIView.animateWithDuration(0.6){
                                self.startPaulseBut.layer.cornerRadius = 10;
                                self.startPaulseBut.layer.masksToBounds = true;
                                self.startPaulseBut.clipsToBounds = true;
                            }
                    })
                   
                    
                    
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
            
            UIView.animateWithDuration(0.7 ,
                animations: {
                    
                    self.startPaulseBut.transform = CGAffineTransformMakeScale(1, 1)
                    
                    UIView.animateWithDuration(3 ,
                        animations: {
                            self.startPaulseBut.layer.cornerRadius = 30;
                            self.startPaulseBut.layer.masksToBounds = true;
                            self.startPaulseBut.clipsToBounds = true;
                            
                            
                        },
                        completion: { finish in
                            UIView.animateWithDuration(3){
                                
                            }
                    })
                    
                    
                    
                },
                completion: { finish in
                    UIView.animateWithDuration(4){
                        //                        self.startPaulseBut.layer.cornerRadius = 30;
                        //                        self.startPaulseBut.layer.masksToBounds = true;
                        //                        self.startPaulseBut.clipsToBounds = true;
                    }
            })
            
            counting = false
        }
        
    }
    @IBAction func transferToFinish(sender: UIButton) {
        
        
        saveWhenFinish()

        
        let navigationController = self.storyboard?.instantiateViewControllerWithIdentifier("FinishNavi")
        
        let vcs = navigationController?.childViewControllers
        let finishedVC = vcs?.first as? FinishedController
      
        self.presentViewController(navigationController!, animated: true, completion: nil)
         finishedVC?.isFromTracking = true

        
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