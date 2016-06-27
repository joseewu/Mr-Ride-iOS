//
//  HistoryController.swift
//  Mr-Ride-iOS
//
//  Created by josee on 6/12/16.
//  Copyright © 2016 com.josee. All rights reserved.
//


import UIKit
import CoreData
import Charts

class HistoryController: UIViewController, UITableViewDelegate, UITableViewDataSource ,NSFetchedResultsControllerDelegate{
    
    
    @IBOutlet weak var naviLeftBut: UIButton!
    @IBOutlet weak var historyTable: UITableView!
    
    @IBOutlet weak var lineChartView: LineChartView!
    // var managedObjectContext: NSManagedObjectContext!
    private let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    private var imageView:UIImageView!
    private let gradientLayer1 = CAGradientLayer()
    private var days:[String]=[""]
    private var distance:[Double] = [0]
    var count = 0
    private var fetchOrNot = true
    lazy var fetchedResultController:NSFetchedResultsController = {
        
        
        let fetchRequest = NSFetchRequest(entityName: "RunRecords")
        let sortDescriptor = NSSortDescriptor(key: "sortingDate", ascending: false)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        
        fetchedResultsController.delegate = self
        
        
        
        return fetchedResultsController
    }()
    
    private var turnType : Dictionary <String,String> = [
        
        "01":"Jan",
        "02":"Feb",
        "03":"Mar",
        "04":"Apr",
        "05":"May",
        "06":"Jun",
        "07":"Jul",
        "08":"Aug",
        "09":"Sep",
        "10":"Oct",
        "11":"Nov",
        "12":"Dec"
        
        
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //print(self.fetchedResultController)
        
        do {
            
            
            try self.fetchedResultController.performFetch()
        } catch {
            let fetchError = error as NSError
            print("\(fetchError), \(fetchError.userInfo)")
        }
        self.fetchOrNot = (fetchedResultController.fetchedObjects?.count) != 0
        
        
        historyTable.delegate = self
        historyTable.dataSource = self
        
        // Do any additional setup after loading the view.
        setUpLefButtom()
        setUp()
        setUpTableView()
        setupRevealViewController()
        setUpGradient()
        
        //        var totaltimes = fetchedResultController.sections?.count
        //        for time in 0..<totaltimes! {
        //
        //            for timesinday in 0..<(fetchedResultController.sections?[time].numberOfObjects)! {
        //                let ttt = fetchedResultController.sections?[time].objects![timesinday] as! RunRecords
        //
        //                days.append(ttt.sortingDate!)
        //                distance.append(ttt.distance as! Double)
        //            }
        //
        //        }
        //
        //        setChart(self.days, values: self.distance)
        
    }
    
    func setChart(dataPoints:[String], values:[Double]){
        
        
        var dataEntries:[ChartDataEntry] = []
        for i in 0..<dataPoints.count {
            let dataEntry  = ChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        let lineChartDataSet = LineChartDataSet(yVals: dataEntries, label: "days")
        
        let gradColors = [UIColor.mrSeafoamBlueColor(), UIColor.mrLightblueColor()]
        let colorLocate:[CGFloat] = [0.0, 1.0]
        if let gradient = CGGradientCreateWithColors(CGColorSpaceCreateDeviceRGB(), gradColors, colorLocate){
            print("here")
            
            //ChartFill.fillWithLinearGradient(gradient, angle: 90.0)
            
            
        }
        
        lineChartDataSet.fillColor = UIColor.mrDarkSlateBlueColor()
        lineChartDataSet.drawCirclesEnabled = false
        lineChartDataSet.drawFilledEnabled = true
        lineChartDataSet.drawValuesEnabled = false
        lineChartDataSet.drawCubicEnabled = true
        lineChartDataSet.lineWidth = 0.0
        
        
        let lineChartData = LineChartData(xVals: dataPoints, dataSet: lineChartDataSet)
        
        
        lineChartView.data = lineChartData
        
        lineChartView.backgroundColor = UIColor.mrLightblueColor()
        lineChartView.gridBackgroundColor = UIColor.mrWaterBlueColor()
        lineChartView.drawGridBackgroundEnabled = false
        lineChartView.descriptionTextColor = UIColor.clearColor()
        //lineChartView.xAxis.enabled = false
        //lineChartView.leftAxis.enabled = false
        lineChartView.rightAxis.enabled = false
        //lineChartView.legend.enabled = false
        //lineChartView.reloadInputViews()
        
        
    }
    func testScroll(){
        
    }
    
    func setUpGradient(){
        
        gradientLayer1.frame = self.imageView.frame
        gradientLayer1.colors = [UIColor.mrLightblueColor().CGColor, UIColor.mrPineGreen50Color().colorWithAlphaComponent(0.8).CGColor]
        
        
        
        view.layer.insertSublayer(gradientLayer1, atIndex: 1)
    }
    
    func setUpTableView(){
        self.historyTable.backgroundColor = UIColor.clearColor()
        self.historyTable.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
        self.historyTable.separatorColor = UIColor.clearColor()
        
        
        
    }
    func setupRevealViewController() {
        
        naviLeftBut.addTarget(self.revealViewController(), action: Selector("revealToggle:"), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
    }
    func setUpLefButtom(){
        
        let image = UIImage(named: "icon-menu")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        
        naviLeftBut.setImage(image, forState: .Normal)
        let barItem = UIBarButtonItem(customView: naviLeftBut)
        self.navigationItem.leftBarButtonItem = barItem
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func setUp(){
        
        self.historyTable.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        let image = UIImage(named: "Bike_image")
        imageView = UIImageView(frame: CGRectMake(0, 0,self.view.frame.width, self.view.frame.height))
        imageView.contentMode = UIViewContentMode.ScaleAspectFill
        imageView.clipsToBounds = true
        //imageView.contentScaleFactor = 1.6
        imageView.image = image
        
        imageView.center = view.center
        self.view.addSubview(imageView)
        self.view.sendSubviewToBack(imageView)
        
        self.view.backgroundColor = UIColor.mrLightblueColor()
        
        
        self.navigationController?.navigationBar.barTintColor = UIColor.mrLightblueColor()
        self.navigationController?.navigationBar.topItem?.title = "History"
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName:UIFont.mrTextStyle17Font(),NSForegroundColorAttributeName:UIColor.whiteColor()]
        
        //cover the black line
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarPosition: .Any, barMetrics: .Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    // MARK:  UITableViewDelegate Methods
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 59
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        let numberOfSections = fetchedResultController.sections?.count
        
        if numberOfSections != 0{
            return numberOfSections!
        }else{
            
            return 1
        }
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let numberOfRows = fetchedResultController.sections?[section].numberOfObjects
        if numberOfRows != 0{
            return numberOfRows!
        }else{
            return 1
        }
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        self.days = [""]
        self.distance = [0.0]
        
        let cell = tableView.dequeueReusableCellWithIdentifier("HistoryTableViewCell", forIndexPath: indexPath) as! HistoryTableViewCell
        cell.backgroundColor = UIColor.pineGreen85Color()
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        if fetchOrNot {
            
            let runRecord = fetchedResultController.objectAtIndexPath(indexPath) as! RunRecords
            
            
            
            cell.lableDistance.text  = String(format: "%.2f", runRecord.distance!.floatValue) + "km"
            cell.lableTimes.text = runRecord.timeString!
            let nst  = (runRecord.sortingDate! as NSString)
            self.days.append(runRecord.sortingDate!)
            self.distance.append(runRecord.distance as! Double)
            
            if let type = nst.substringFromIndex(4) as? String {
                cell.rideTimes.text =  type + "th"
            }
            
        }else{
            
            cell.rideTimes.text =   " 0 th"
            cell.lableDistance.text = "0.0 km"
            cell.lableTimes.text = "00:00:00"
            self.days = ["Today"]
            self.distance = [0.0]
            
            
            
            
        }
        setChart(self.days, values: self.distance)
        return cell
        
        
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        //
        //        let row = indexPath.row
        
    }
    
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView(frame: CGRectMake(0, 0,tableView.bounds.size.width, 34))
        let headerView2 = UIView(frame: CGRectMake(0, 0,tableView.bounds.size.width, 24))
        let labelForHeader = UILabel(frame: CGRectMake(20,5,57,14))
        headerView.backgroundColor = UIColor.clearColor()
        labelForHeader.backgroundColor = UIColor.whiteColor()
        labelForHeader.font = UIFont.mrtextStyle25Font()
        
        if fetchOrNot{
            
            let sectionNum = fetchedResultController.objectAtIndexPath(NSIndexPath(forItem: 0, inSection: section)) as! RunRecords
            
            
            let nst = (sectionNum.sortingDate! as NSString)
            if let type = turnType[nst.substringToIndex(2)]{
                labelForHeader.text = type + ",2016"
                
                
            }
        }else{
            labelForHeader.text = "Start your ride!"
            
        }
        
        headerView2.backgroundColor = UIColor.whiteColor()
        headerView2.addSubview(labelForHeader)
        headerView.addSubview(headerView2)
        
        return headerView
    }
    
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 34
    }
    //    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    //        return "yo~"
    //    }
    func configureCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath){
        
        //        let record = fetchedResultController.objectAtIndexPath(indexPath)
        //
        //        if let name = record.valueForKey("") as? String{
        //
        //        }
        
    }
    
    
    //////
    ///ptotocol
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        //historyTable.beginUpdates()
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        //historyTable.endUpdates()
    }
    //    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
    //
    //        switch type {
    //        case .Insert:
    //                if let indexPath = newIndexPath {
    //                    historyTable.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    //                }
    //                break;
    //        case .Delete:
    //            if let indexPath = indexPath {
    //                historyTable.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    //            }
    //            break;
    //        case .Move :
    //            if let indexPath = indexPath {
    //
    //                historyTable.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    //            }
    //            if let indexPath = newIndexPath {
    //                historyTable.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    //            }
    //            break;
    //        case .Update:
    //            if let indexPath = indexPath {
    //                //let cell = historyTable.cellForRowAtIndexPath(indexPath)
    //
    //
    //            }
    //        }
    //
    //
    //
    //
    //    }
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}