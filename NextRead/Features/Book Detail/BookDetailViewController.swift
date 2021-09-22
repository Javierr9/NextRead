//
//  BookDetailViewController.swift
//  NextRead
//
//  Created by Javier Fransiscus on 21/09/21.
//

import UIKit
import SDWebImage

class BookDetailViewController: UIViewController {
    
    @IBOutlet weak var bookImageView: UIImageView!
    @IBOutlet weak var bookTitleLabel: UILabel!
    @IBOutlet weak var bookAuthorLabel: UILabel!
    @IBOutlet weak var bookDescription: UITextView!
    
    private var bookLibraryViewModel: BookLibraryViewModel?
    
    var bookDetail:BookDataModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bookLibraryViewModel = BookLibraryViewModel()
        presentController()
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


extension BookDetailViewController{
    
    func presentController(){
        guard let book = bookDetail else {return}
        setupNavigationMenu()
        if let imageURL = URL(string: book.volumeInfo?.imageLinks?.smallThumbnail ?? ""){
            bookImageView.sd_setImage(with: imageURL, placeholderImage: #imageLiteral(resourceName: "BookCover"), options: []) { image, error, cacheType, url in
                self.handle(image: image, error: error, cacheType: cacheType, url: url)

            }
        }
        bookTitleLabel.text = book.volumeInfo?.title
        bookAuthorLabel.text = book.volumeInfo?.authors?.first ?? "None"
        bookDescription.text = book.volumeInfo?.description ?? "No description available"
        
    }
    
    func setupNavigationMenu(){
        title = "Detail"
        navigationController?.navigationBar.prefersLargeTitles = false
        let infoButton = UIBarButtonItem(image: UIImage(systemName: "info.circle"), style: .plain, target: self, action: #selector(apiDetail))
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        navigationItem.rightBarButtonItems = [addButton, infoButton]
        
        
    }
    
    @objc
    func apiDetail(){
        
        guard let book = bookDetail else {return}
        
        let message = """
       
        id = \(book.id)

        small thumbnail : \(book.volumeInfo?.imageLinks?.smallThumbnail)

        thumbnail : \(book.volumeInfo?.imageLinks?.thumbnail)

        authors = \(book.volumeInfo?.authors)

        description = \(book.volumeInfo?.description)

"""
        let alert = UIAlertController(title: "Book Api Info", message: message, preferredStyle: .alert)
        let dismiss = UIAlertAction(title: "Dismiss", style: .cancel) { alertAction in
            
        }
        alert.addAction(dismiss)
        self.present(alert, animated: true) {
            
        }
    }
    
    @objc
    func addTapped(){
        
        guard let book = bookDetail else {return}
        
        bookLibraryViewModel?.addToFavorites(bookModel: book)
        
        let message = """
       
      Book has been added to book library

"""
        let alert = UIAlertController(title: "Book is added", message: message, preferredStyle: .alert)
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
