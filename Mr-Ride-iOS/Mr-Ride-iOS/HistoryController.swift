//
//  HistoryController.swift
//  Mr-Ride-iOS
//
//  Created by josee on 6/12/16.
//  Copyright © 2016 com.josee. All rights reserved.
//


import UIKit

class HistoryController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var naviLeftBut: UIButton!
    
    @IBOutlet weak var historyTable: UITableView!
    private var imageView:UIImageView!
    private let gradientLayer1 = CAGradientLayer()
    //private let gradientLayer2 = CAGradientLayer()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        historyTable.delegate = self
        historyTable.dataSource = self
        
        // Do any additional setup after loading the view.
        setUpLefButtom()
        setUp()
        setUpTableView()
        setupRevealViewController()
        setUpGradient()
    }
    
    func setUpGradient(){
        
        gradientLayer1.frame = self.imageView.frame
        gradientLayer1.colors = [UIColor.mrLightblueColor().CGColor, UIColor.mrPineGreen50Color().colorWithAlphaComponent(0.8).CGColor]
        
        
        
        view.layer.insertSublayer(gradientLayer1, atIndex: 1)
    }
    
    func setUpTableView(){
        self.historyTable.backgroundColor = UIColor.clearColor()
        self.historyTable.separatorStyle = UITableViewCellSeparatorStyle.None
        
        
        
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
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        let cell : UITableViewCell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
        let cellLabel = UILabel(frame: CGRect(x: 0, y: 2, width:cell.frame.width - 2 , height: cell.frame.height - 4))
        //let cellView = UIView(frame: CGRect(x: 0, y: 2, width:cell.frame.width - 2 , height: cell.frame.height - 4))
        
        cell.backgroundColor = UIColor.clearColor()
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cellLabel.backgroundColor = UIColor.pineGreen85Color().colorWithAlphaComponent(0.5)
        cellLabel.text = "hi~"
        cellLabel.textColor = UIColor.whiteColor()
        //cellView.center = cell.center
        cell.addSubview(cellLabel)
        return cell
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        //
        //        let row = indexPath.row
        
    }
    
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRectMake(0, 0,tableView.bounds.size.width, 30))
        let headerView2 = UIView(frame: CGRectMake(0, 0,tableView.bounds.size.width, 24))
        headerView.backgroundColor = UIColor.clearColor()
        headerView2.backgroundColor = UIColor.whiteColor()
        headerView.addSubview(headerView2)
        return headerView
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
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
