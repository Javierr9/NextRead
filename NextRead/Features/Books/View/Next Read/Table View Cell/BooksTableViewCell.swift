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
    
    var bookModel: BookDataModel?{
        didSet{
            setCellData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
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
    
    
    func setCellData(){
        guard let book = bookModel else {return}
        if let imageURL = URL(string: book.volumeInfo?.imageLinks?.smallThumbnail ?? ""){
            bookImageView.sd_setImage(with: imageURL, placeholderImage: #imageLiteral(resourceName: "BookCover"), options: []) { image, error, cacheType, url in
                self.handle(image: image, error: error, cacheType: cacheType, url: url)

            }
        }
        bookTitleLabel.text = book.volumeInfo?.title
        bookAuthorLabel.text = book.volumeInfo?.authors.first ?? "None"

        
    }
    
    func handle(image: UIImage?, error: Error?, cacheType: SDImageCacheType, url: URL?){
        
        if let error = error{
            print("This is the error \(error.localizedDescription)")
            return
        }
        
        guard let image = image, let url = url else {return}
        
        let message = """
        Image Size
        \(image.size)
        
        Cache:
        \(cacheType.rawValue)
        
        URL:
        \(url)

        """
        
        print(message)
    }
    
    
}
