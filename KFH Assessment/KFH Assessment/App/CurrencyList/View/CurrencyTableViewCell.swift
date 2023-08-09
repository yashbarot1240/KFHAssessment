//
//  CurrencyTableViewCell.swift
//  KFH Assessment
//
//  Created by Yash Barot on 09/08/23.
//

import UIKit

class CurrencyTableViewCell: UITableViewCell {

    
    @IBOutlet weak var labelCurrecyCode: UILabel!
    @IBOutlet weak var labelCountryName: UILabel!
    
    @IBOutlet weak var labelRate: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
