//
//  BooksCollectionViewCell.swift
//  NextRead
//
//  Created by Javier Fransiscus on 03/10/21.
//

import UIKit

class BooksCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    static let identifier = "BooksCollectionViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
extension BooksCollectionViewCell{
    static func getNib()-> UINib{
        return UINib(nibName: identifier, bundle: nil)
    }
    
}
