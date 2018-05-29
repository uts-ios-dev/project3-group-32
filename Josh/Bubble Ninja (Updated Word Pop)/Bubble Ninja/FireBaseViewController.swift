//
//  ViewControllerTableViewCell.swift
//  Mustage
//
//  Created by josh parker on 31/1/18.
//  Copyright © 2018 Bossly. All rights reserved.
//

import UIKit

class ViewControllerTableViewCell: UITableViewCell {
    
    
    //labels connected
    @IBOutlet weak var FirstWord: UILabel!  // name is the category of prefilled bet
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
        UniversalTitle = FirstWord.text

    }
    
}
