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

//TODO: Scroll view on scroll close the bar, remake the font
//TODO: Add more information near the view
//TODO: Fix the scroll view
//TODO: Clean the code this needs to be done within this week. 
class BookDetailViewController: UIViewController {
    @IBOutlet weak var bookImageView: UIImageView!
    @IBOutlet weak var bookTitleLabel: UILabel!
    @IBOutlet weak var bookAuthorLabel: UILabel!
    @IBOutlet weak var bookRecommendationTableView: UITableView!
//    @IBOutlet weak var readDescriptionButton: UIButton!
    @IBOutlet weak var bookDetailScrollView: UIScrollView!
    @IBOutlet weak var bookDescriptionLabel: ExpandableLabel!
    
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

extension BookDetailViewController: UIScrollViewDelegate{
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if bookDescriptionLabel.isExpanded {
//            let contentRect: CGRect = scrollView.subviews.reduce(into: .zero) { rect, view in
//                rect = rect.union(view.frame)
//            }
//            scrollView.contentSize = contentRect.size
        }
    }
}

fileprivate extension BookDetailViewController{
    
    func setupView(){
        getBook()
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
    
    func openBookDescription(){
        let vc = BookDescriptionViewController()
        
        guard let description = bookDetail?.volumeInfo?.description else {return}
        vc.bookDescription = description

//        let navigation = UINavigationController(rootViewController: vc)
//        self.navigationController?.present(navigation, animated: true, completion: nil)
        
        if let sheet = vc.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
//            sheet.detents = [.medium()]
            sheet.largestUndimmedDetentIdentifier = .none
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.prefersEdgeAttachedInCompactHeight = true
            sheet.widthFollowsPreferredContentSizeWhenEdgeAttached = true
        }
        
        present(vc, animated:  true, completion: nil)
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


