//
//  BooksTableViewCell.swift
//  NextRead
//
//  Created by Javier Fransiscus on 13/09/21.
//

import SDWebImage
import UIKit

class BooksTableViewCell: UITableViewCell {
    @IBOutlet var bookImageView: UIImageView!
    @IBOutlet var bookTitleLabel: UILabel!
    @IBOutlet var bookAuthorLabel: UILabel!

    static let identifier = "BooksTableViewCell"

    var thumbnailData: ThumbnailDataModel? {
        didSet {
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

extension BooksTableViewCell {
    static func getNib() -> UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
}

private extension BooksTableViewCell {
    func setupView() {
        setupImageView()
    }

    func setupImageView() {
        bookImageView.layer.cornerRadius = 2
        bookImageView.clipsToBounds = true
    }

    func setCellData() {
        guard let data = thumbnailData else { return }
        if let thumbnailImage = data.smallThumbnail {
            if let imageURL = URL(string: thumbnailImage) {
                bookImageView.sd_setImage(with: imageURL, placeholderImage: #imageLiteral(resourceName: "BookCover"), options: [], completed: nil)
            }
        } else {
            bookImageView.image = #imageLiteral(resourceName: "BookCover")
        }

        bookTitleLabel.text = data.title
        guard let authorsName = data.authors else { return }
        let authorsNameText = authorsName.joined(separator: ", ")
        bookAuthorLabel.text = authorsNameText
    }
}
