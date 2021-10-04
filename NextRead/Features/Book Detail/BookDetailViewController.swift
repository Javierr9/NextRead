//
//  BookDetailViewController.swift
//  NextRead
//
//  Created by Javier Fransiscus on 21/09/21.
//

import UIKit
import SDWebImage
import MapKit

enum AddButtonStatus{
    case like
    case unlike
}

class BookDetailViewController: UIViewController {
    //TODO: Fix entry point from every book library and book search
    @IBOutlet weak var bookImageView: UIImageView!
    @IBOutlet weak var bookTitleLabel: UILabel!
    @IBOutlet weak var bookAuthorLabel: UILabel!
    @IBOutlet weak var bookRecommendationTableView: UITableView!
    
    private var bookDetailViewModel = BookDetailViewModel()
    private var addButtonStatus: AddButtonStatus?
    
    var bookId: String?
    var bookDetail:BookDataModel?
    var bookRecommendationThumbnails: [ThumbnailDataModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupNavigation()
        bookRecommendationTableView.reloadData()
    }
    
    @IBAction func openDescription(_ sender: Any) {
        openBookDescription()
    }
    
}


fileprivate extension BookDetailViewController{
    
    func setupView(){
        getBook()
        setupNavigation()
        subscribeViewModel()
        setupTableView()
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
        
        
        //TODO: Check book exist if book already exist in that than change the navigation menu button to something else
        
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
        bookAuthorLabel.text = bookDetail.volumeInfo?.authors?.first ?? "Authors not available"
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
        print("this is tapped")
        bookDetailViewModel.fetchBookRecommendations(usingId: bookId ?? "")
    }
    
    func openBookDescription(){
        let vc = BookDescriptionViewController()

        guard let description = bookDetail?.volumeInfo?.description else {return}
        vc.bookDescription = description

        let navigation = UINavigationController(rootViewController: vc)
        self.navigationController?.present(navigation, animated: true, completion: nil)
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
