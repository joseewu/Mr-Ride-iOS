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

class MapInfoViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource {
    
    @IBOutlet weak var naviLeftBut: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var popUpPiker: UIButton!
    @IBOutlet weak var lookForLabel: UILabel!
    @IBOutlet weak var pickView: UIPickerView!
    private let locationMannager = CLLocationManager()
    private let dataModel = DataTaipeiModel()
    private let chooseName = ["Ubike Station","Toilet"]
    private var pickerBar = UIView()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pickView.delegate = self
        self.pickView.dataSource = self
        setUp()
        setNavigationBar()
        setLeftBarButton()
        //setUpPickerView()
        setupRevealViewController()
        setUpBut()
        //dataModel.requestToiletsFromURL("")
        //dataModel.requestYouBikesFromURL("")
        pickView.hidden = true
    }
    func setUpBut(){
        self.popUpPiker.backgroundColor = UIColor.whiteColor()
        self.popUpPiker.layer.cornerRadius = 4
        
        self.popUpPiker.tintColor = UIColor.mrDarkSlateBlueColor()
        self.popUpPiker.titleLabel?.font = UIFont.mrtextStyle24Font()
    }
    func setUpPickerView(){
        //pickerBar = UIView(frame: CGRectMake(0, self.view.frame.height - self.pickView.frame.height - 44 , self.pickView.frame.width, 44))
        pickerBar.frame = CGRectMake(0, self.view.frame.height - self.pickView.frame.height - 43 , self.pickView.frame.width, 44)
        
        pickerBar.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.7)
        pickView.backgroundColor = UIColor.whiteColor()
        
        self.pickerBar.hidden = false
        
    }
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        pickView.hidden = true
        self.pickerBar.hidden = true
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
    
    @IBAction func showPicker(sender: AnyObject) {
        
        //self.view.addSubview(pickView)
        self.view.addSubview(pickerBar)
        setUpPickerView()
        pickView.hidden = false
        
        
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
