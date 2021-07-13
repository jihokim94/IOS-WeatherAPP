//
//  SummaryTableViewCell.swift
//  ForecastAppByJiho
//
//  Created by 김지호 on 2021/07/13.
//

import UIKit

class SummaryTableViewCell: UITableViewCell {

    //type Property
    static let indentifier = "SummaryTableViewCell"
    
    @IBOutlet weak var weatherImageView: UIImageView!
    
    
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var minMaxLabel: UILabel!
    
    @IBOutlet weak var currentTemperatureLabel: UILabel!
    
    
    
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
