//
//  ForecastTableViewCell.swift
//  ForecastAppByJiho
//
//  Created by 김지호 on 2021/07/13.
//

import UIKit

class ForecastTableViewCell: UITableViewCell {

    static let indentifier = "ForecastTableViewCell"
    
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var weatherImageView: UIImageView!
    
    
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var temperaturelabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        backgroundColor = .clear
        
        statusLabel.textColor = .white
        dateLabel.textColor = statusLabel.textColor
        timeLabel.textColor = statusLabel.textColor
        temperaturelabel.textColor = statusLabel.textColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
