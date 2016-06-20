//
//  ViewController.swift
//  Mr-Ride-iOS
//
//  Created by josee on 6/12/16.
//  Copyright © 2016 com.josee. All rights reserved.
//


import UIKit
import QuartzCore
import SWRevealViewController

class ViewController: UIViewController {
    
    @IBOutlet weak var naviLeftBut: UIButton!
    
    

    
    @IBOutlet weak var letsRideBut: UIButton!
    @IBOutlet weak var roundView: UIView!
    @IBOutlet weak var labelFixed1: UILabel!
    
    @IBOutlet weak var totalDistance: UILabel!
    
    @IBOutlet weak var labelFixed2: UILabel!
    
    @IBOutlet weak var totalCount: UILabel!
    
    @IBOutlet weak var labelFixed3: UILabel!
    
    @IBOutlet weak var meanSpeed: UILabel!
    let statisticalData = StatisticalModel()
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        
        print(self)
        let days = statisticalData._stt.days
        let rideDistance = statisticalData._stt.rideDistance
        //        let days = ["1", "2", "3", "4", "5", "6"]
        //        let rideDistance = [20.0, 4.0, 6.0, 3.0, 12.0, 16.0]
        
        
        setUp()
        setUpLebelColor()
        setUpLebelContext()
        serUpContextFont()
        setUpLefButtom()
        setUpTitleView()
        setUpLetsRidebut()
        setupRevealViewController()
        //setChart(days,values: rideDistance)
        
        
    }
    
    
    
    @IBAction func startRunBut(sender: UIButton) {
        
        
        let navigationController = self.storyboard?.instantiateViewControllerWithIdentifier("trackingNavi")
        self.presentViewController(navigationController!, animated: true, completion: nil)
        //self.presentViewController(navigationController, animated: true, completion: nil)
        
        
        //setUpNavigationBar(navigationController)
        
        
    }
    
    func setUpLetsRidebut(){
        
        letsRideBut.setTitle("Let's Ride", forState: .Normal)
        letsRideBut.tintColor = UIColor.mrLightblueColor()
        letsRideBut.titleLabel?.font = UIFont.mrTextStyle16Font()
        letsRideBut.layer.shadowOffset = CGSize(width: 0, height: 0.05)
        
    }
    func setUpLebelColor(){
        
        self.labelFixed1.textColor = UIColor.whiteColor()
        self.labelFixed2.textColor = UIColor.whiteColor()
        self.labelFixed3.textColor = UIColor.whiteColor()
        self.totalCount.textColor = UIColor.whiteColor()
        self.totalDistance.textColor = UIColor.whiteColor()
        self.meanSpeed.textColor = UIColor.whiteColor()
        self.totalDistance.layer.shadowOffset = CGSize(width: 0.1, height: 3)
        self.totalDistance.layer.shadowOpacity = 0.5
        self.totalCount.layer.shadowOffset = CGSize(width: 0.1, height: 1)
        self.totalCount.layer.shadowOpacity = 0.4
        self.meanSpeed.layer.shadowOffset = CGSize(width: 0.1, height: 1)
        self.meanSpeed.layer.shadowOpacity = 0.4
    }
    func serUpContextFont(){
        
        self.labelFixed1.font = UIFont.mrTextStyle12Font()
        self.labelFixed2.font = UIFont.mrTextStyle12Font()
        self.labelFixed3.font = UIFont.mrTextStyle12Font()
        self.meanSpeed.font = UIFont.mrTextStyle9Font()
        self.totalCount.font = UIFont.mrTextStyle9Font()
        self.totalDistance.font = UIFont.mrTextStyle14Font()
    }
    func setUpLebelContext(){
        
        self.labelFixed1.text = "Total Distance"
        self.labelFixed2.text = "Total Counts"
        self.labelFixed3.text = "Average Speed"
        self.totalDistance.text = "12.5 km"
        self.totalCount.text = "14 times"
        self.meanSpeed.text = "8 km/h"
        
        
    }
//    func setChart(dataPoints:[String], values:[Double]){
//        
//        
//        var dataEntries:[ChartDataEntry] = []
//        for i in 0..<dataPoints.count {
//            let dataEntry  = ChartDataEntry(value: values[i], xIndex: i)
//            dataEntries.append(dataEntry)
//        }
//        let lineChartDataSet = LineChartDataSet(yVals: dataEntries, label: "")
//        
//        let gradColors = [UIColor.mrSeafoamBlueColor(), UIColor.mrLightblueColor()]
//        let colorLocate:[CGFloat] = [0.0, 1.0]
//        if let gradient = CGGradientCreateWithColors(CGColorSpaceCreateDeviceRGB(), gradColors, colorLocate){
//            print("here")
//            
//            //ChartFill.fillWithLinearGradient(gradient, angle: 90.0)
//            
//            
//        }
//        
//        lineChartDataSet.fillColor = UIColor.mrDarkSlateBlueColor()
//        lineChartDataSet.drawCirclesEnabled = false
//        lineChartDataSet.drawFilledEnabled = true
//        lineChartDataSet.drawValuesEnabled = false
//        lineChartDataSet.drawCubicEnabled = true
//        lineChartDataSet.lineWidth = 0.0
//        
//        
//        let lineChartData = LineChartData(xVals: dataPoints, dataSet: lineChartDataSet)
//        
//        
//        lineChartView.data = lineChartData
//        
//        lineChartView.backgroundColor = UIColor.mrLightblueColor()
//        lineChartView.gridBackgroundColor = UIColor.mrWaterBlueColor()
//        lineChartView.drawGridBackgroundEnabled = false
//        lineChartView.descriptionTextColor = UIColor.clearColor()
//        lineChartView.xAxis.enabled = false
//        lineChartView.leftAxis.enabled = false
//        lineChartView.rightAxis.enabled = false
//        lineChartView.legend.enabled = false
//        
//        
//        
//    }
    
    func setupRevealViewController() {
        
        naviLeftBut.addTarget(self.revealViewController(), action: Selector("revealToggle:"), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
    }
    
    
    func setUpTitleView(){
        
        let bikeLogo = UIImage(named: "logo-bike")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        let imageView = UIImageView(image: bikeLogo)
        imageView.tintColor = UIColor.whiteColor()
        
        self.navigationItem.titleView = imageView
        
        //this two line remove the navigation bar bottom line
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarPosition: .Any, barMetrics: .Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
    }
    
    func setUpLefButtom(){
        
        let image = UIImage(named: "icon-menu")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        
        naviLeftBut.setImage(image, forState: .Normal)
        let barItem = UIBarButtonItem(customView: naviLeftBut)
        self.navigationItem.leftBarButtonItem = barItem
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
    }
    func setUp(){
        
        view.backgroundColor = UIColor.mrLightblueColor()
        self.navigationController?.navigationBar.barTintColor = UIColor.mrLightblueColor()
        
        roundView.backgroundColor = UIColor.whiteColor()
        roundView.layer.cornerRadius = 30
        roundView.layer.shadowOffset = CGSize(width: 0, height: 2)
        roundView.layer.shadowOpacity = 0.4
        
    }
    override func viewWillAppear(animated: Bool) {
        
    }
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}



