//
//  RestaurantsModelCell.swift
//  FindRestaurant
//
//  Created by Erick Arciniega on 19/12/19.
//  Copyright © 2019 Erick Arciniega. All rights reserved.
//

import UIKit

class RestaurantsModelCell: UITableViewCell {

    @IBOutlet weak var restaurantImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
