//
//  HistoryTableViewCell.swift
//  Mr-Ride-iOS
//
//  Created by josee on 6/24/16.
//  Copyright © 2016 com.josee. All rights reserved.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lableTimes: UILabel!
    @IBOutlet weak var lableDistance: UILabel!
    @IBOutlet weak var rideTimes: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        rideTimes.textColor = UIColor.whiteColor()
        rideTimes.backgroundColor = UIColor.clearColor()
        rideTimes.textAlignment = .Center
        rideTimes.font = UIFont(name: "RobotoMono-Light", size: 20)
        lableDistance.textColor = UIColor.whiteColor()
        lableDistance.font = UIFont(name: "RobotoMono-Light", size: 20)
        lableDistance.backgroundColor = UIColor.clearColor()
        lableTimes.backgroundColor = UIColor.clearColor()
        lableTimes.textColor = UIColor.whiteColor()
        
        lableTimes.font = UIFont(name: "RobotoMono-Light", size: 20)
        
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
