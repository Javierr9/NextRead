//
//  BookDetailViewModel.swift
//  NextRead
//
//  Created by Javier Fransiscus on 23/09/21.
//

import Foundation
import CoreData

class BookDetailViewModel: NSObject{
    // This class will handle network service when the book is retrieved and also core data to send the books to favorite as well as to the recent searches
    
    private var coreDataManager: CoreDataManager!
    private var service: NetworkRequest!
    
    private(set) var dataFromAPI: BookModel?{
        didSet{
            self.bindBookDetailViewModelToController()
        }
    }
    
    private var setOfBooks: [Book]?{
        didSet{
            self.bindBookDetailViewModelToController()
        }
    }
    
    var bindBookDetailViewModelToController: (()->()) = {}
    
    override init(){
        super.init()
        service = NetworkRequest()
        coreDataManager = CoreDataManager.shared
    }
    
    
    // TODO: Add to recent searches
    func addBookToRecentSearches(){
        
    }
    
    
    //MARK: Get Favorited Books
    
    func getFavoritedBooks(){
        setOfBooks = coreDataManager.fetchFavorite()
    }
    
    // MARK: Add to favorites
    func addToFavorites(bookModel: BookDataModel){
        coreDataManager?.addFavorite(using: bookModel)
        getFavoritedBooks()
        
    }
    
    func addToFavorites(book: Book){
        coreDataManager.addFavorite(using: book)
    }
    
    func checkBookExist(bookID: String) -> Bool {
        return coreDataManager.checkBookExist(bookID: bookID)
    }
    // MARK: Delete from favorites
    func removeBookFromFavorites(usingId id: String){
        coreDataManager.deleteFavorite(byBookID: id)
        getFavoritedBooks()
    }

}
