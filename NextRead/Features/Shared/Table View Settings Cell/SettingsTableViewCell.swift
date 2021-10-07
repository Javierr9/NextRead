//
//  SettingsTableViewCell.swift
//  NextRead
//
//  Created by Javier Fransiscus on 07/10/21.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {

    @IBOutlet weak var sortButton: UIButton!
    static var identifier = "SettingsTableViewCell"
    
    private let sortByTitle = { (action: UIAction) in
        
    }
    
    private let sortByRecent = { (action: UIAction) in
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupButton()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension SettingsTableViewCell{
    
    static func getNib() -> UINib{
        
        return UINib(nibName: identifier, bundle: nil)
    }
    
}

fileprivate extension SettingsTableViewCell{
    
    func setupButton(){
        sortButton.menu = UIMenu(children: [
            UIAction(title: "Recent", handler: sortByRecent),
            UIAction(title: "Title ", handler: sortByTitle),
        ])
        
        sortButton.changesSelectionAsPrimaryAction = true
        sortButton.showsMenuAsPrimaryAction = true
    }
}
