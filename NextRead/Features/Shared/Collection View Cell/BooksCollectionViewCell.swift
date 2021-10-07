//
//  BooksCollectionViewCell.swift
//  NextRead
//
//  Created by Javier Fransiscus on 03/10/21.
//

import UIKit

class BooksCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var bookImageView: UIImageView!
    
    var thumbnailData: ThumbnailDataModel?{
        didSet{
            setCellData()
        }
    }
    
    static let identifier = "BooksCollectionViewCell"
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
        // Initialization code
    }
    
}
extension BooksCollectionViewCell{
    static func getNib()-> UINib{
        return UINib(nibName: identifier, bundle: nil)
    }
    
}

fileprivate extension BooksCollectionViewCell{
    
    func setupView(){
        setupImageView()
    }
    
    func setupImageView(){
        self.layer.cornerRadius = 4
        self.clipsToBounds = true
    }
    func setCellData(){
        guard let data = thumbnailData else {return}

        guard let thumbnailImage = data.thumbnail else {return}
        if let imageURL = URL(string: thumbnailImage){
            bookImageView.sd_setImage(with: imageURL, placeholderImage: #imageLiteral(resourceName: "BookCover"), options: [], completed: nil)
            
        }
        
    }
    
}
