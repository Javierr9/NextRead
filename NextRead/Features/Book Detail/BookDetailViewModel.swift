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
    
    
    // TODO: Copy the function its using from the book view library model
    
    func getFavoritedBooks(){
        
        setOfBooks = coreDataManager.fetchFavorite()
    }
    
    // MARK: Add to favorites
    func addToFavorites(bookModel: BookDataModel, changeMessage: ()-> Void){
        coreDataManager?.addFavorite(using: bookModel){
            changeMessage()
        }
        getFavoritedBooks()
        
    }

}

fileprivate extension BookDetailViewModel{
    
}
