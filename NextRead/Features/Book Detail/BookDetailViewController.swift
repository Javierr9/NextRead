//
//  BookDetailViewController.swift
//  NextRead
//
//  Created by Javier Fransiscus on 21/09/21.
//

import UIKit
import SDWebImage
import MapKit
import SVProgressHUD

enum AddButtonStatus{
    case like
    case unlike
}

//TODO: Scroll view on scroll close the bar, remake the font
//TODO: Add more information near the view
//TODO: Clean the code this needs to be done within this week.
//TODO: Make the view only shown when the data is fully loaded mvvm
class BookDetailViewController: UIViewController {
    @IBOutlet weak var bookImageView: UIImageView!
    @IBOutlet weak var bookTitleLabel: UILabel!
    @IBOutlet weak var bookAuthorLabel: UILabel!
    @IBOutlet weak var bookRecommendationTableView: UITableView!
    @IBOutlet weak var bookDetailScrollView: UIScrollView!
    @IBOutlet weak var bookDescriptionLabel: ExpandableLabel!
    @IBOutlet var bookDetailView: UIView!
    
    private var bookDetailViewModel = BookDetailViewModel()
    private var addButtonStatus: AddButtonStatus?
    
    
    var bookId: String?
    var bookDetail:BookDataModel?
    var bookRecommendationThumbnails: [ThumbnailDataModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        setupNavigation()
        SVProgressHUD.show()
        getBook()
        bookRecommendationTableView.reloadData()
    }
    
    
}

fileprivate extension BookDetailViewController{
    
    func setupView(){
        setupNavigation()
        subscribeViewModel()
        setupTableView()
        setupImageView()
        setupScrollView()
    }
     
    func setupScrollView(){
        bookDetailScrollView.delegate = self
    }
    
    func setupImageView(){
        bookImageView.layer.cornerRadius = 4
        bookImageView.clipsToBounds = true
    }
    

    
    func setupTableView(){
        bookRecommendationTableView.register(BooksTableViewCell.getNib(), forCellReuseIdentifier: BooksTableViewCell.identifier)
        bookRecommendationTableView.dataSource = self
        bookRecommendationTableView.delegate = self
    }
    
    func getBook(){
        guard let id = bookId else {return}
        bookDetailViewModel.fetchBookFromApi(byId: id)
        
    }
    
    func loadDetailsData(){
        
        bookDetail = bookDetailViewModel.bookDetail
        
        setupBarButtonItem()
        DispatchQueue.main.async {
            self.setupDetailView()
        }
    }
    
    func subscribeViewModel(){
        bookDetailViewModel.bindBookDetailViewModelToController = {
            self.loadDetailsData()
        }
        bookDetailViewModel.recommendationThumbnailDidLoad = {
            self.loadBookRecommendationsThumbnailDatas()
        }
    }
    
    func loadBookRecommendationsThumbnailDatas(){
        bookRecommendationThumbnails = bookDetailViewModel.recommendationThumbnailDatas
        
        DispatchQueue.main.async {
            self.bookRecommendationTableView.reloadData()
        }
    }
    
  
    
    func setupDetailView(){
        guard let bookDetail = bookDetail else {return}
        if let imageURL = URL(string: bookDetail.volumeInfo?.imageLinks?.thumbnail ?? ""){
            bookImageView.sd_setImage(with: imageURL, placeholderImage: #imageLiteral(resourceName: "BookCover"), options: [], completed: nil)
        }
        bookTitleLabel.text = bookDetail.volumeInfo?.title
        guard let authorsName = bookDetail.volumeInfo?.authors else {return}
        let authorsNameText = authorsName.joined(separator: ",")

        bookAuthorLabel.text = authorsNameText != "" ? authorsNameText : "No authors"
        bookDescriptionLabel.text = bookDetail.volumeInfo?.description?.htmlToString
    }
    
    
    func setupNavigation(){
        title = "Detail"
        navigationItem.largeTitleDisplayMode = .never
        
        setupBarButtonItem()
    }
    
    func setupBarButtonItem(){
        let infoButton = UIBarButtonItem(image: UIImage(systemName: "info.circle"), style: .plain, target: self, action: #selector(bookDetailTapped))
        let likeButton = UIBarButtonItem(image: UIImage(systemName: "bookmark"), style: .plain, target: self, action: #selector(addTapped))
        let unlikeButton = UIBarButtonItem(image: UIImage(systemName: "bookmark.fill"), style: .plain, target: self, action: #selector(addTapped))
        
        guard let id = bookId else {return}
        let bookExist = bookDetailViewModel.checkBookExist(bookId: id)
        if bookExist{
            addButtonStatus = .unlike
        }else{
            addButtonStatus = .like
        }
        
        DispatchQueue.main.async {
            switch self.addButtonStatus{
            case .like:
                self.navigationItem.rightBarButtonItems = [likeButton, infoButton]
            default:
                self.navigationItem.rightBarButtonItems = [unlikeButton, infoButton]
            }
        }   
        
    }
    
    @objc
    func addTapped(){
        switch addButtonStatus{
        case .like:
            bookDetailViewModel.addToFavorites()
            setupBarButtonItem()
            
        default:
            guard let id = bookId else {return}
            bookDetailViewModel.deleteBookFromFavorites(usingId: id)
            setupBarButtonItem()
            
        }
    }
    
    @objc
    func bookDetailTapped(){
        bookDetailViewModel.fetchBookRecommendations(usingId: bookId ?? "")
    }
    
    
}

extension BookDetailViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return bookRecommendationThumbnails.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BooksTableViewCell.identifier, for: indexPath) as! BooksTableViewCell
        cell.thumbnailData = bookRecommendationThumbnails[indexPath.row]
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = BookDetailViewController()
        viewController.bookId = bookRecommendationThumbnails[indexPath.row].id
        self.navigationController?.pushViewController(viewController, animated: true)
            
    }
    
    
}


