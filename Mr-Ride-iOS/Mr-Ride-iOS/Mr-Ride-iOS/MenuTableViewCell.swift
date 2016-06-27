//
//  MenuTableViewCell.swift
//  Mr-Ride-iOS
//
//  Created by josee on 6/12/16.
//  Copyright © 2016 com.josee. All rights reserved.
//

import UIKit

class MenuTableViewCell: UITableViewCell {
    
    @IBOutlet weak var menuButton: UIButton!
    
    @IBOutlet weak var decaration: UIView!
    
    //weak var delegate: menuCellDidTouched?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //menuButton.addTarget(self, action: Selector("CallTabel:"), forControlEvents:UIControlEvents.TouchUpInside)
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        
    }
}
