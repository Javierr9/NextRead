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
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        navigationController?.navigationBar.prefersLargeTitles = false
        
    }
    
    @objc
    func addTapped(){
        guard let book = bookDetail else {return}
        bookLibraryViewModel?.addToFavorites(bookModel: book)
        print("book is added")
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
