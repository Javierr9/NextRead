//
//  BooksTableViewCell.swift
//  NextRead
//
//  Created by Javier Fransiscus on 13/09/21.
//

import UIKit
import SDWebImage

enum BookType{
    case bookModel
    case book
}

class BooksTableViewCell: UITableViewCell {

    @IBOutlet weak var bookImageView: UIImageView!
    @IBOutlet weak var bookTitleLabel: UILabel!
    @IBOutlet weak var bookAuthorLabel: UILabel!
    
    
    private var bookType:BookType?
    static let identifier = "BooksTableViewCell"
    
    var bookModel: BookDataModel?{
        didSet{
            bookType = .bookModel
            setCellData()
        }
    }
    
    var book: Book?{
        didSet{
            bookType = .book
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
    
    

    

    
    
}

fileprivate extension BooksTableViewCell{
    
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

//       print(message)
   }
    func setCellData(){
        var title = "", author = "", thumbnail = ""
        
        switch bookType{
        case .bookModel :
           guard let book = bookModel else {return}
            thumbnail = book.volumeInfo?.imageLinks?.thumbnail ?? ""
            title = book.volumeInfo?.title ?? "Title is unavailable"
            author = book.volumeInfo?.authors?.first ?? "None"
        default :
            guard let book = self.book else {return}
            thumbnail = book.thumbnail ?? ""
            title = book.title ?? "Title is unavailable"
            author = book.author ?? "None"
        }
        
        if let imageURL = URL(string: thumbnail ){
            bookImageView.sd_setImage(with: imageURL, placeholderImage: #imageLiteral(resourceName: "BookCover"), options: []) { image, error, cacheType, url in
                self.handle(image: image, error: error, cacheType: cacheType, url: url)

            }
        }
        
        bookTitleLabel.text = title
        bookAuthorLabel.text = author
        title = ""
        author = ""
        thumbnail = ""
    }
}
