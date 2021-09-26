//
//  BookLibraryViewModel.swift
//  NextRead
//
//  Created by Javier Fransiscus on 21/09/21.
//

import Foundation

class BookLibraryViewModel: NSObject{
    
    private var coreDataManager:CoreDataManager!
    
    
    var setOfBooks: [Book]? {
        didSet {
            self.bindBookLibraryViewModelToController()
        }
    }
    
    var bindBookLibraryViewModelToController: (() -> ()) = {}
    
    override init(){
        super.init()
        coreDataManager = CoreDataManager.shared
    }
    
    func getFavoritedBooks(){
        
        setOfBooks = coreDataManager.fetchFavorite()
    }
    
    func deleteBookFromFavorite(book: Book){
        coreDataManager?.deleteFavorite(using: book)
        getFavoritedBooks()
    }
}
