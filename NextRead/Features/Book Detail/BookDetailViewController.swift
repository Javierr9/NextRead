//
//  BookDetailViewController.swift
//  NextRead
//
//  Created by Javier Fransiscus on 21/09/21.
//

import MapKit
import SDWebImage
import SVProgressHUD
import UIKit

enum AddButtonStatus {
    case like
    case unlike
}

class BookDetailViewController: UIViewController {
    @IBOutlet var bookImageView: UIImageView!
    @IBOutlet var bookTitleLabel: UILabel!
    @IBOutlet var bookAuthorLabel: UILabel!
    @IBOutlet var bookRecommendationTableView: UITableView!
    @IBOutlet var bookDetailScrollView: UIScrollView!
    @IBOutlet var bookPageNumberLabel: UILabel!
    @IBOutlet var descriptionTitleLabel: UILabel!
    @IBOutlet var similarBooksTitle: UILabel!
    @IBOutlet var bookPublishedDateLabel: UILabel!
    @IBOutlet var bookDescriptionLabel: ExpandableLabel!

    private var bookDetailViewModel = BookDetailViewModel()
    private var addButtonStatus: AddButtonStatus?

    var bookId: String?
    var bookDetail: BookDataModel?
    var bookRecommendationThumbnails: [ThumbnailDataModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

//    override func viewWillAppear(_: Bool) {
//        SVProgressHUD.show()
//        setupNavigation()
//        getBook()
//        bookRecommendationTableView.reloadData()
//    }
    override func viewWillAppear(_: Bool) {
        setupNavigation()
    }
}

private extension BookDetailViewController {
    func setupView() {
        SVProgressHUD.show()
        getBook()
        setupNavigation()
        subscribeViewModel()
        setupTableView()
        setupImageView()
        setupScrollView()
        getRecommendations()
    }

    func setupTitleText() {
        descriptionTitleLabel.text = "Description"
        similarBooksTitle.text = "Books Similar to This"
    }

    func setupScrollView() {
        bookDetailScrollView.delegate = self
    }

    func setupImageView() {
        bookImageView.layer.cornerRadius = 10
        bookImageView.clipsToBounds = true
    }

    func setupTableView() {
        bookRecommendationTableView.register(BooksTableViewCell.getNib(), forCellReuseIdentifier: BooksTableViewCell.identifier)
        bookRecommendationTableView.dataSource = self
        bookRecommendationTableView.delegate = self
    }

    func getBook() {
        guard let id = bookId else { return }
        bookDetailViewModel.fetchBookFromApi(byId: id)
    }

    func loadDetailsData() {
        bookDetail = bookDetailViewModel.bookDetail

        setupBarButtonItem()
        DispatchQueue.main.async {
            self.setupDetailView()
        }
    }

    func subscribeViewModel() {
        bookDetailViewModel.bindBookDetailViewModelToController = {
            self.loadDetailsData()
        }
        bookDetailViewModel.recommendationThumbnailDidLoad = {
            self.loadBookRecommendationsThumbnailDatas()
        }
    }

    func loadBookRecommendationsThumbnailDatas() {
        bookRecommendationThumbnails = bookDetailViewModel.recommendationThumbnailDatas

        DispatchQueue.main.async {
            self.bookRecommendationTableView.reloadData()
        }
    }

    func setupDetailView() {
        guard let bookDetail = bookDetail else { return }
        guard let volumeInfo = bookDetail.volumeInfo else { return }
        if let thumbnailData = volumeInfo.imageLinks?.thumbnail {
            if let imageURL = URL(string: thumbnailData) {
                bookImageView.sd_setImage(with: imageURL, placeholderImage: #imageLiteral(resourceName: "BookCover"), options: [], completed: nil)
            }
        } else {
            bookImageView.image = #imageLiteral(resourceName: "BookCover")
        }

        bookTitleLabel.text = volumeInfo.title

        if let authorsName = volumeInfo.authors {
            let authorsNameText = authorsName.joined(separator: ", ")
            bookAuthorLabel.text = authorsNameText != "" ? authorsNameText : "No author"
        }

        let bookDescription = volumeInfo.description ?? "No description available"
        bookDescriptionLabel.text = bookDescription.htmlToString

        if let pageCount = volumeInfo.pageCount {
            bookPageNumberLabel.text = "\(pageCount) pages"
        } else {
            bookPageNumberLabel.text = "- Pages"
        }

        if let yearPublished = volumeInfo.publishedDate {
            bookPublishedDateLabel.text = "\(yearPublished.prefix(4))"
        }
        setupTitleText()
    }

    func setupNavigation() {
        title = "Detail"
        navigationItem.largeTitleDisplayMode = .never

        setupBarButtonItem()
    }

    func setupBarButtonItem() {
//        let infoButton = UIBarButtonItem(image: UIImage(systemName: "info.circle"), style: .plain, target: self, action: #selector(getRecommendations))
        let likeButton = UIBarButtonItem(image: UIImage(systemName: "bookmark"), style: .plain, target: self, action: #selector(addTapped))
        let unlikeButton = UIBarButtonItem(image: UIImage(systemName: "bookmark.fill"), style: .plain, target: self, action: #selector(addTapped))

        guard let id = bookId else { return }
        let bookExist = bookDetailViewModel.checkBookExist(bookId: id)
        if bookExist {
            addButtonStatus = .unlike
        } else {
            addButtonStatus = .like
        }

        DispatchQueue.main.async {
            switch self.addButtonStatus {
            case .like:
//                self.navigationItem.rightBarButtonItems = [likeButton, infoButton]
                self.navigationItem.rightBarButtonItems = [likeButton]
            default:
                self.navigationItem.rightBarButtonItems = [unlikeButton]
            }
        }
    }

    @objc
    func addTapped() {
        switch addButtonStatus {
        case .like:
            bookDetailViewModel.addToFavorites()
            setupBarButtonItem()

        default:
            guard let id = bookId else { return }
            bookDetailViewModel.deleteBookFromFavorites(usingId: id)
            setupBarButtonItem()
        }
    }

    @objc
    func getRecommendations() {
        bookDetailViewModel.fetchBookRecommendations(usingId: bookId ?? "")
    }
}

extension BookDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return bookRecommendationThumbnails.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BooksTableViewCell.identifier, for: indexPath) as! BooksTableViewCell
        cell.thumbnailData = bookRecommendationThumbnails[indexPath.row]
        return cell
    }

    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = BookDetailViewController()
        viewController.bookId = bookRecommendationThumbnails[indexPath.row].id
        navigationController?.pushViewController(viewController, animated: true)
    }
}
