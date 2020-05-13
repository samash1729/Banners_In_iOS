//
//  CollectionViewBannerCell.swift
//  BannerInTableView
//
//  Created by Ashish Samanta on 20/04/20.
//  Copyright © 2020 Nuclei. All rights reserved.
//

import UIKit

class CollectionViewBannerCell: UICollectionViewCell {
    @IBOutlet weak var colourView: UIView!
    let colorArray:[UIColor] = [.red,.blue,.gray,.green,.yellow,.purple,.brown,.cyan,.magenta,.systemIndigo]
    
    @IBOutlet weak var bannerImage: UIImageView!
    let bannerArray: [String] = ["BUS","Donations","Donations2","Flights","Flights2","Gold2","Recharge"]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    func setColour(_ item : Int) -> UIColor{
        return colorArray[item]
    }

    func setImage(_ item: Int) -> String{
        return bannerArray[item]
    }
}
