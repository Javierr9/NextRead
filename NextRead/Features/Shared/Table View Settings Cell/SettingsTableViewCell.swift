//
//  SettingsTableViewCell.swift
//  NextRead
//
//  Created by Javier Fransiscus on 07/10/21.
//

import UIKit

protocol SettingsTableViewDelegate {
    func sortBookByRecentProtocolFunction()
}

class SettingsTableViewCell: UITableViewCell {
    @IBOutlet var sortButton: UIButton!
    static var identifier = "SettingsTableViewCell"

    var updateBookListRecent: (() -> Void)?
    var delegate: SettingsTableViewDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        setupButton()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

extension SettingsTableViewCell {
    static func getNib() -> UINib {
        return UINib(nibName: identifier, bundle: nil)
    }

    private func sortBookByRecent() {}
}

private extension SettingsTableViewCell {
    func setupButton() {
        sortButton.menu = UIMenu(children: [
            UIAction(title: "Default", handler: { _ in
                self.updateBookListRecent?()
            }),
            UIAction(title: "Title ", handler: { _ in
                self.delegate?.sortBookByRecentProtocolFunction()
            }),
        ])

        sortButton.changesSelectionAsPrimaryAction = true
        sortButton.showsMenuAsPrimaryAction = true
    }
}
