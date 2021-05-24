//
//  ContactoTableViewCell.swift
//  ContactosCoreDataPM2
//
//  Created by Ramiro y Jennifer on 17/05/21.
//

import UIKit

class ContactoTableViewCell: UITableViewCell {

    @IBOutlet weak var nombreLabel: UILabel!
    @IBOutlet weak var telefonoLabel: UILabel!
    @IBOutlet weak var fotoImageView: UIImageView!
    
    @IBOutlet weak var backView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        backView.layer.masksToBounds = false
        backView.layer.cornerRadius = 9
        backView.layer.shadowColor = UIColor.black.cgColor
        backView.layer.shadowOpacity = 0.5
        backView.layer.shadowOffset = .zero
        backView.layer.shadowRadius = 5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
