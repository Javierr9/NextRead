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

class BookDetailViewController: UIViewController {
    
    @IBOutlet weak var bookImageView: UIImageView!
    @IBOutlet weak var bookTitleLabel: UILabel!
    @IBOutlet weak var bookAuthorLabel: UILabel!
    @IBOutlet weak var bookDescription: UITextView!
    
    private var addButton: UIBarButtonItem?
    private var bookDetailViewModel: BookDetailViewModel?
    private var entryPoint: BookDetailViewControllerEntryPoint?
    
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
        setupNavigation()
        presentController()
    }
    
    
}


fileprivate extension BookDetailViewController{
    
    func presentController(){
        switch entryPoint{
        case .bookLibrary  :
            guard let bookData = book else {return}
            setupNavigation()
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
            setupNavigation()
            //TODO: Check book exist if book already exist in that than change the navigation menu button to something else
              
              setupNavigation()
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
        //TODO: change the add to love and unlove aja gimana caranya ntar
        navigationItem.largeTitleDisplayMode = .never
        let infoButton = UIBarButtonItem(image: UIImage(systemName: "info.circle"), style: .plain, target: self, action: #selector(apiDetail))
        
        addButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addTapped))
        navigationItem.rightBarButtonItems = [addButton!, infoButton]
        
        
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
    
    @objc
    func addTapped(){
        // TODO: Bikin love sama unlove terus bikin case add or delete tergantung 1 variable also change it to fit the entrypoint
        guard let book = bookDetail else {return}
        
        var title = "Book Is Added"
        
        var message = """
       
        Book has been added to book library

"""
        
        bookDetailViewModel?.addToFavorites(bookModel: book){
            
            title = "Book Exists"
            
            message = """
            Book is already exist in book library.
       
       """
        }
        
        
        
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let dismiss = UIAlertAction(title: "Dismiss", style: .cancel) { alertAction in
            
        }
        alert.addAction(dismiss)
        self.present(alert, animated: true) {
            
        }
    }
    
    
}

fileprivate extension BookDetailViewController{
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
