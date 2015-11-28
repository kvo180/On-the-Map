//
//  StudentLocationTableViewCell.swift
//  On the Map
//
//  Created by Khoa Vo on 11/27/15.
//  Copyright © 2015 AppSynth. All rights reserved.
//

import UIKit

class StudentLocationTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    @IBOutlet weak var labelContainerView: UIView!
    @IBOutlet weak var initialsLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var urlLabel: UILabel!
    @IBOutlet weak var updatedAtLabel: UILabel!
    
    
    // MARK: Init
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
