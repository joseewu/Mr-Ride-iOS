//
//  MapInfoViewController.swift
//  Mr-Ride-iOS
//
//  Created by josee on 6/24/16.
//  Copyright © 2016 com.josee. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import FBAnnotationClusteringSwift
import CoreData

private let managedContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext

extension MapInfoViewController : FBClusteringManagerDelegate {
    
    public func cellSizeFactorForCoordinator(coordinator:FBClusteringManager) -> CGFloat{
        return 1.0
    }
    
}
class MapInfoViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource,CLLocationManagerDelegate {
    
    let clusteringManager = FBClusteringManager()
    
    @IBOutlet weak var pickerBar: UIView!
    @IBOutlet weak var pickBarDone: UIButton!
    @IBOutlet weak var pickBarTitle: UILabel!
    @IBOutlet weak var pickBarCancel: UIButton!
    
    @IBOutlet weak var naviLeftBut: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var popUpPiker: UIButton!
    @IBOutlet weak var lookForLabel: UILabel!
    @IBOutlet weak var pickView: UIPickerView!
    private let locationMannager = CLLocationManager()
    private let chooseName = ["Ubike Station","Toilet"]
    private let entityName = ["Ubikes","Toilets"]
    var image = UIImage(named: "icon-station.png")
    private var array:[MKAnnotation] = []
    private var userChoose:String?{
        didSet{
            mapView.removeAnnotations(array)
            
            image = UIImage(named: "icon-toilet")
            quering(userChoose!)
            userChoose?.removeAll()
        }
    }
    private var currentLocation:CLLocation?{
        didSet{
            setupMap()
            locationMannager.stopUpdatingLocation()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pickView.delegate = self
        self.pickView.dataSource = self
        self.mapView.delegate = self
        locationMannager.delegate = self
        clusteringManager.delegate = self
        setUp()
        fetchLocation()
        setNavigationBar()
        setLeftBarButton()
        //setUpPickerView()
        setupRevealViewController()
        setUpBut()
        viewDisapear()
        self.array = queringDataUbike(entity: "Ubikes")
        clusteringManager.addAnnotations(array)
        
        
    }
    func fetchLocation(){
        
        locationMannager.startUpdatingLocation()
        locationMannager.desiredAccuracy = kCLLocationAccuracyBest
        locationMannager.requestWhenInUseAuthorization()
        
    }
    func quering(en:String){
        if en == "Toilets"{
            self.array = queringDataToilets(entity: "Toilets")
        }else{
            self.array = queringDataUbike(entity: "Ubikes")
        }
        clusteringManager.addAnnotations(array)

    }
    
    
    func queringDataToilets(entity en: String) -> [FBAnnotation]{
        
        var array:[FBAnnotation] = []
        
        
        var request = NSFetchRequest(entityName: en)
        request.returnsObjectsAsFaults = false
        
        do{
            
            var results:NSArray = try managedContext.executeFetchRequest(request)
            
            if (results.count > 0){
                
                for result in results {
                    
                    if let res = result as? Toilets {
                        
                        let a:FBAnnotation = FBAnnotation()
                        a.coordinate = CLLocationCoordinate2D(latitude: Double(res.lat!), longitude: Double(res.long!) )
                        a.title = res.toiletName
                        a.subtitle = res.address
                        array.append(a)
                    }
                }
            }
        }catch{
            print("No data exist!")
        }
        
        return array
    }
    func queringDataUbike(entity en: String) -> [FBAnnotation]{
        
        var array:[FBAnnotation] = []
        
        
        var request = NSFetchRequest(entityName: en)
        request.returnsObjectsAsFaults = false
        
        do{
            
            var results:NSArray = try managedContext.executeFetchRequest(request)
            
            if (results.count > 0){
                
                for result in results {
                    
                    if let res = result as? Ubikes {
                        
                        let a:FBAnnotation = FBAnnotation()
                        a.coordinate = CLLocationCoordinate2D(latitude: Double(res.lat!), longitude: Double(res.long!) )
                        a.title = res.name
                        a.subtitle = res.roadName
                        array.append(a)
                    }
                }
            }
        }catch{
            print("No data exist!")
        }
        
        return array
    }
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.currentLocation = locations.last!
        //        let center = CLLocationCoordinate2D(latitude: locationValue.coordinate.latitude, longitude: locationValue.coordinate.longitude)
        //        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpanMake(0.018, 0.018))
    }
    func setupMap(){
        
        self.mapView.showsUserLocation = true
        let center = CLLocationCoordinate2D(latitude: self.currentLocation!.coordinate.latitude, longitude: self.currentLocation!.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpanMake(0.018, 0.018))
        self.mapView.setRegion(region, animated: true)
    }
    func setUpBut(){
        self.popUpPiker.backgroundColor = UIColor.whiteColor()
        self.popUpPiker.layer.cornerRadius = 4
        
        self.popUpPiker.tintColor = UIColor.mrDarkSlateBlueColor()
        self.popUpPiker.titleLabel?.font = UIFont.mrtextStyle24Font()
        pickBarCancel.backgroundColor = UIColor.clearColor()
        pickBarDone.backgroundColor = UIColor.clearColor()
        pickBarTitle.backgroundColor = UIColor.clearColor()
        pickBarTitle.font = UIFont.mrtextStyle28Font()
    }
    func setUpPickerView(){
        
        pickerBar.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.5)
        pickView.backgroundColor = UIColor.whiteColor()
        
        
    }
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
       userChoose = entityName[row]

    }
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return chooseName.count
    }
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return chooseName[row]
    }
    //    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
    //        return chooseName[row]
    //    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelInfo(sender: AnyObject) {
        viewDisapear()
        
    }
    func viewDisapear(){
        self.pickView.hidden = true
        self.pickBarTitle.hidden = true
        self.pickerBar.hidden = true
        self.pickBarCancel.hidden = true
        self.pickBarDone.hidden = true
    }
    
    @IBAction func didChooseInfo(sender: AnyObject) {
        
        viewDisapear()
    }
    func setupRevealViewController(){
        
        naviLeftBut.addTarget(self.revealViewController(), action: Selector("revealToggle:"), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
    }
    func setLeftBarButton(){
        
        let image = UIImage(named: "icon-menu")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        
        naviLeftBut.setImage(image, forState: .Normal)
        let barItem = UIBarButtonItem(customView: naviLeftBut)
        self.navigationItem.leftBarButtonItem = barItem
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
    }
    func setNavigationBar(){
        
        self.navigationController?.navigationBar.barTintColor = UIColor.mrLightblueColor()
        self.navigationController?.navigationBar.topItem?.title = "Map"
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName:UIFont.mrTextStyle17Font(),NSForegroundColorAttributeName:UIColor.whiteColor()]
        
        //cover the black line
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarPosition: .Any, barMetrics: .Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    func setUp(){
        self.view.backgroundColor = UIColor.mrLightblueColor()
        self.lookForLabel.text = "Look for"
        self.lookForLabel.backgroundColor = UIColor.whiteColor()
        self.lookForLabel.tintColor = UIColor.mrDarkSlateBlueColor()
        self.lookForLabel.layer.cornerRadius = 4
        self.lookForLabel.font = UIFont.mrtextStyle22Font()
    }
    func showPickerAgain(){
        self.pickView.hidden = false
        self.pickBarTitle.hidden = false
        self.pickerBar.hidden = false
        self.pickBarCancel.hidden = false
        self.pickBarDone.hidden = false
    }
    
    @IBAction func showPicker(sender: AnyObject) {
        
        //self.view.addSubview(pickView)
        setUpPickerView()
        showPickerAgain()
        
        
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

extension MapInfoViewController: MKMapViewDelegate {
    
    func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool){
        
        NSOperationQueue().addOperationWithBlock({
            
            let mapBoundsWidth = Double(self.mapView.bounds.size.width)
            
            let mapRectWidth:Double = self.mapView.visibleMapRect.size.width
            
            let scale:Double = mapBoundsWidth / mapRectWidth
            
            let annotationArray = self.clusteringManager.clusteredAnnotationsWithinMapRect(self.mapView.visibleMapRect, withZoomScale:scale)
            
            self.clusteringManager.displayAnnotations(annotationArray, onMapView:self.mapView)
            
        })
        
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation {
            //return nil so map view draws "blue dot" for standard user location
            return nil
        }
        
        var reuseId = ""
        
        if annotation.isKindOfClass(FBAnnotationCluster) {
            
            reuseId = "Cluster"
            var clusterView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId)
            
            clusterView = FBAnnotationClusterView(annotation: annotation, reuseIdentifier: reuseId, options: nil)
            clusterView?.selected  = true
            clusterView?.setSelected(true, animated: true)
            return clusterView
            
        } else {
            //let countLabel:UIView?
            var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier("pin")
            
            
            //var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId)
            if pinView == nil {
                
                pinView = MKAnnotationView(annotation: annotation, reuseIdentifier: "pin")
  
                pinView!.canShowCallout = true
                pinView?.bounds = CGRectMake(0,0,(image?.size.width)!,(image?.size.height)!)
                
                pinView!.layer.cornerRadius = pinView!.bounds.height / 2

                pinView!.backgroundColor = UIColor.whiteColor()
                
                pinView?.image = image
               
                
                
            }
            else {
                pinView!.annotation = annotation
            }
            
            return pinView
            //            pinView?.image = UIImage(named: "icon-toilet")
            //            pinView?.setSelected(true, animated: true)
            //
            //            return pinView
        }
        
        
    }
    
    
}

