//
//  BooksTableViewCell.swift
//  NextRead
//
//  Created by Javier Fransiscus on 13/09/21.
//

import UIKit
import SDWebImage

class BooksTableViewCell: UITableViewCell {
    
    @IBOutlet weak var bookImageView: UIImageView!
    @IBOutlet weak var bookTitleLabel: UILabel!
    @IBOutlet weak var bookAuthorLabel: UILabel!
    
    static let identifier = "BooksTableViewCell"
    
    var thumbnailData: ThumbnailDataModel?{
        didSet{
            setCellData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupView()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    
    
}

extension BooksTableViewCell{
    
    static func getNib()-> UINib{
        return UINib(nibName: identifier, bundle: nil)
    }
    
}

fileprivate extension BooksTableViewCell{
    
    func setupView(){
        setupImageView()
    }
    
    func setupImageView(){
        bookImageView.layer.cornerRadius = 2
        bookImageView.clipsToBounds = true
    }
    func setCellData(){
        guard let data = thumbnailData else {return}
        guard let thumbnailImage = data.smallThumbnail else {return}
        if let imageURL = URL(string: thumbnailImage){
            bookImageView.sd_setImage(with: imageURL, placeholderImage: #imageLiteral(resourceName: "BookCover"), options: [], completed: nil)
            
        }
        
        bookTitleLabel.text = data.title
        guard let authorsName = data.authors else {return}
        let authorsNameText = authorsName.joined(separator: ",")
        bookAuthorLabel.text = authorsNameText
    }
}
