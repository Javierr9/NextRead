//
//  BookDetailViewController.swift
//  NextRead
//
//  Created by Javier Fransiscus on 21/09/21.
//

import UIKit
import SDWebImage

// MARK: - ENUM For Entry Point

enum BookDetailViewControllerEntryPoint {
    case bookLibrary
    case bookSearch
}

enum AddButtonStatus{
    case like
    case unlike
}

class BookDetailViewController: UIViewController {
    
    @IBOutlet weak var bookImageView: UIImageView!
    @IBOutlet weak var bookTitleLabel: UILabel!
    @IBOutlet weak var bookAuthorLabel: UILabel!
    @IBOutlet weak var bookDescription: UITextView!
    
    private var bookDetailViewModel: BookDetailViewModel?
    private var entryPoint: BookDetailViewControllerEntryPoint?
    private var addButtonStatus: AddButtonStatus?
    
    init(entryPoint: BookDetailViewControllerEntryPoint){
        super.init(nibName: "BookDetailViewController", bundle: nil)
        self.entryPoint = entryPoint
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var book:Book?
    var bookDetail:BookDataModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bookDetailViewModel = BookDetailViewModel()
        presentController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupNavigation()
    }
    
    
}


fileprivate extension BookDetailViewController{
    
    func presentController(){
        setupNavigation()
        switch entryPoint{
        case .bookLibrary  :
            guard let bookData = book else {return}
            if let imageURL = URL(string: bookData.thumbnail ?? ""){
                bookImageView.sd_setImage(with: imageURL, placeholderImage: UIImage(systemName: "BookCover"), options: []) { image, error, cacheType, url in
                    self.handle(image: image, error: error, cacheType: cacheType, url: url)
                }
            }
            
            bookTitleLabel.text = bookData.title
            bookAuthorLabel.text = bookData.author ?? "Authors not available"
            bookDescription.text = bookData.desc ?? "No description available"
            
        default :
            guard let bookDetail = bookDetail else {return}
            //TODO: Check book exist if book already exist in that than change the navigation menu button to something else
            if let imageURL = URL(string: bookDetail.volumeInfo?.imageLinks?.thumbnail ?? ""){
                bookImageView.sd_setImage(with: imageURL, placeholderImage: #imageLiteral(resourceName: "BookCover"), options: []) { image, error, cacheType, url in
                    self.handle(image: image, error: error, cacheType: cacheType, url: url)
                    
                }
                
                
            }
            bookTitleLabel.text = bookDetail.volumeInfo?.title
            bookAuthorLabel.text = bookDetail.volumeInfo?.authors?.first ?? "Authors not available"
            bookDescription.text = bookDetail.volumeInfo?.description ?? "No description available"
            
        }
        
    }
    
    
    
    func setupNavigation(){
        title = "Detail"
        navigationItem.largeTitleDisplayMode = .never
        setupBarButtonItem()
    }
    
    func setupBarButtonItem(){
        //TODO: change the add to love and unlove aja gimana caranya ntar
        let infoButton = UIBarButtonItem(image: UIImage(systemName: "info.circle"), style: .plain, target: self, action: #selector(apiDetail))
        let likeButton = UIBarButtonItem(image: UIImage(systemName: "bookmark"), style: .plain, target: self, action: #selector(addTapped))
        let unlikeButton = UIBarButtonItem(image: UIImage(systemName: "bookmark.fill"), style: .plain, target: self, action: #selector(addTapped))
        
        guard let bookExist = bookDetailViewModel?.checkBookExist(bookID: getCurrentBookID()) else {return}
        if bookExist{
            addButtonStatus = .unlike
        }else{
            addButtonStatus = .like
        }
        
        switch addButtonStatus{
        case .like:
            navigationItem.rightBarButtonItems = [likeButton, infoButton]
        default:
            navigationItem.rightBarButtonItems = [unlikeButton, infoButton]
        }
    }
    
    @objc
    func addTapped(){
        let id = getCurrentBookID()
        switch addButtonStatus{
        case .like:
            switch entryPoint{
            case .bookSearch:
                guard let bookModel = bookDetail else {return}
                bookDetailViewModel?.addToFavorites(bookModel: bookModel)
            default:
                guard let book = self.book else {return}
                bookDetailViewModel?.addToFavorites(book: book)
            }
            
            setupBarButtonItem()
            
        default:
            bookDetailViewModel?.removeBookFromFavorites(usingId: id)
            setupBarButtonItem()
            
        }
    }
    
    @objc
    func apiDetail(){
        var message = """
        """
        switch entryPoint{
        case .bookSearch:
            guard let book = bookDetail else {return}
            
            message = """
           
            id = \(book.id)
    
            small thumbnail : \(book.volumeInfo?.imageLinks?.smallThumbnail)
    
            thumbnail : \(book.volumeInfo?.imageLinks?.thumbnail)
    
            authors = \(book.volumeInfo?.authors)
    
            description = \(book.volumeInfo?.description)
            
            url : \(book.selfLink)
    
    """
        default:
            guard let book = book else {return}
            
            message = """
           
            id = \(book.id)
    
            small thumbnail : \(book.smallThumbnail)
    
            thumbnail : \(book.thumbnail)
    
            authors = \(book.author)
    
            description = \(book.desc)
    
    """
            
        }
        print(message)
        
        let alert = UIAlertController(title: "Book Api Info", message: message, preferredStyle: .alert)
        let dismiss = UIAlertAction(title: "Dismiss", style: .cancel) { alertAction in
            
        }
        alert.addAction(dismiss)
        self.present(alert, animated: true) {
            
        }
    }
    
    func getCurrentBookID() -> String{
        switch entryPoint{
        case .bookSearch:
            if let id = bookDetail?.id {
                return id
            }
        default:
            if let id  = book?.id{
                return id
            }
        }
        return ""
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
        
//        print(message)
    }
    
}

