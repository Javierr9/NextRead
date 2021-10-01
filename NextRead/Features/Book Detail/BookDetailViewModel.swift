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
    
    private(set) var bookDetail: BookDataModel?{
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
    
    func fetchBookFromApi(byId id: String){
        service.requestBookFromAPIWith(bookId: id) { object in
            self.bookDetail = object
        }
    }
    
    //MARK: Get Favorited Books
    
    func getFavoritedBooks(){
//        coreDataManager.fetchFavoriteIds()
    }
    
    // MARK: Add to favorites
    func addToFavorites(){
        guard let book = bookDetail else {return}
        coreDataManager?.addFavorite(using: book)
        getFavoritedBooks()
        
    }
    
    func checkBookExist(bookId: String) -> Bool {
        return coreDataManager.checkBookExist(bookID: bookId)
    }
    // MARK: Delete from favorites
    func deleteBookFromFavorites(usingId id: String){
        coreDataManager.deleteFavorite(byBookID: id)
        getFavoritedBooks()
    }

}
