//
//  LogInViewController.swift
//  Mr-Ride-iOS
//
//  Created by josee on 6/24/16.
//  Copyright © 2016 com.josee. All rights reserved.
//
import UIKit
import FBSDKLoginKit
import FBSDKCoreKit

class LogInViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var nameTitle: UILabel!
    private let gradientLayer1 = CAGradientLayer()
    private var imageView:UIImageView!
    
    @IBOutlet weak var heightTitle: UILabel!
    
    @IBOutlet weak var weightTitle: UILabel!
    
    @IBOutlet weak var LogInBut: UIButton!
    @IBOutlet weak var kgLabel: UILabel!
    @IBOutlet weak var cmLabel: UILabel!
    
    @IBOutlet weak var hightInput: UITextField!
    
    @IBOutlet weak var weightInput: UITextField!
    private var userwieght = NSUserDefaults.standardUserDefaults()
    private let alert = UIAlertController(title: "Warning!", message: "please enter your height and weight!", preferredStyle: UIAlertControllerStyle.Alert)
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupLabels()
        setUpGradient()
        setUpTextField()
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        // Do any additional setup after loading the view.
    }
    func setUpTextField(){
        hightInput.text = "Please enter your height!"
        hightInput.textColor = UIColor.grayColor()
        weightInput.text = "Please enter your weight!"
        weightInput.textColor = UIColor.grayColor()
        hightInput.delegate = self
        weightInput.delegate = self
        
        
    }
    func setupLabels(){
        
        heightTitle.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.8)
        weightTitle.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.8)
        heightTitle.font = UIFont.mrtextStyle22Font()
        heightTitle.textColor = UIColor.blackColor()
        weightTitle.font = UIFont.mrtextStyle22Font()
        weightTitle.textColor = UIColor.blackColor()
        cmLabel.backgroundColor = UIColor.whiteColor()
        cmLabel.font = UIFont.mrtextStyle23Font()
        
        kgLabel.backgroundColor = UIColor.whiteColor()
        kgLabel.font = UIFont.mrtextStyle23Font()
    }
    func setup(){
        LogInBut.backgroundColor = UIColor.whiteColor()
        LogInBut.layer.cornerRadius = 30.0
        LogInBut.tintColor = UIColor.mrLightblueColor()
        LogInBut.titleLabel?.font = UIFont.mrTextStyle16Font()
        self.view.backgroundColor = UIColor.mrLightblueColor()
        nameTitle.backgroundColor = UIColor.clearColor()
        nameTitle.text = "Mr. Ride"
        nameTitle.font = UIFont.mrtextStyle21Font()
        nameTitle.textColor = UIColor.whiteColor()
        let image = UIImage(named: "Bike_image")
        imageView = UIImageView(frame: CGRectMake(0, 280, self.view.frame.width, self.view.frame.height - 280))
        imageView.contentMode = UIViewContentMode.ScaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = image
        //imageView.center = view.center
        self.view.addSubview(imageView)
        self.view.sendSubviewToBack(imageView)
        
        
    }
    
    @IBAction func LogInAction(sender: UIButton) {
        if (userwieght.objectForKey("uerHeight") == nil){
            
            
            self.presentViewController(alert, animated: true, completion: nil)
        }else {
            
            let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
            
            fbLoginManager.logInWithReadPermissions(["email"], handler: { (result, error) -> Void in
                if (error == nil) {
                    
                    var fbloginresult : FBSDKLoginManagerLoginResult = result
                    if (fbloginresult.isCancelled){
                        
                    }else{
                        if (fbloginresult.grantedPermissions.contains("email"))
                        {
                            
                            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                            appDelegate.logindidFinished()
                            
                        }
                    }
                    
                }
                
            })
            
        }
        
    }
    
    func setUpGradient(){
        
        gradientLayer1.frame = self.imageView.frame
        gradientLayer1.colors = [UIColor.mrLightblueColor().CGColor, UIColor.mrPineGreen50Color().colorWithAlphaComponent(0.8).CGColor]
        
        
        
        view.layer.insertSublayer(gradientLayer1, atIndex: 1)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    enum inputType {
        
        case String(UITextField)
        
        case Number
    }
    
    // MARK:  textField delegate method
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        if (hightInput.resignFirstResponder()){
            if let hightvalue = Double(hightInput.text!) {
                userwieght.setDouble(hightvalue, forKey: "uerHeight")
                print(hightvalue)
            }else{
                
                
                self.presentViewController(alert, animated: true, completion: nil)
                hightInput.text = nil
            }
            
            
        }
        if(weightInput.resignFirstResponder()){
            if let weightvalue = Double(weightInput.text!) {
                userwieght.setDouble(weightvalue, forKey: "uerWeight")
                print(weightvalue)
                
            }else{
                
                self.presentViewController(alert, animated: true, completion: nil)
                weightInput.text = nil
            }
        }
        
        
        return false
        
    }
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
        if hightInput.textColor == UIColor.grayColor(){
            hightInput.text = nil
            hightInput.textColor = UIColor.blackColor()
        }
        if weightInput.textColor == UIColor.grayColor(){
            weightInput.text = nil
            weightInput.textColor = UIColor.blackColor()
        }
    }
    func textFieldDidEndEditing(textField: UITextField) {
        if (hightInput.text == nil){
            hightInput.text = "Please enter your height!"
        }
        if (weightInput.text == nil){
            weightInput.text = "Please enter your weight!"
        }
    }
}