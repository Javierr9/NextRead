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
    
    private(set) var recommendationThumbnailDatas: [ThumbnailDataModel] = []{
        didSet{
            self.recommendationThumbnailDidLoad()
        }
    }
    
    private(set) var recommendedBookIds: [BookRecommendationDataModel]?
    
    var bindBookDetailViewModelToController: (()->()) = {}
    var recommendationThumbnailDidLoad: (()->()) = {}
    
    override init(){
        super.init()
        service = NetworkRequest()
        coreDataManager = CoreDataManager.shared
    }
    
    func fetchBookFromApi(byId id: String){
        service.requestBookFromApiWith(bookId: id) { object in
            self.bookDetail = object
        }
    }
    
    // MARK: Add to favorites
    func addToFavorites(){
        guard let book = bookDetail else {return}
        coreDataManager?.addFavorite(using: book)
        
    }
    
    func checkBookExist(bookId: String) -> Bool {
        return coreDataManager.checkBookExist(bookID: bookId)
    }
    
    // MARK: Delete from favorites
    func deleteBookFromFavorites(usingId id: String){
        coreDataManager.deleteFavorite(byBookID: id)
    }
    
    func fetchBookRecommendations(usingId id:String){
        service.requestSimilarBookFromApiWith(bookId: id) { bookRecommendation in
            self.recommendedBookIds = bookRecommendation
            self.fetchThumbnailDatasFromIdArray()
        }
    }

}

fileprivate extension BookDetailViewModel{
    func fetchThumbnailDatasFromIdArray(){
        var temporaryData: [ThumbnailDataModel]  = []
        guard let bookIds = recommendedBookIds else {return}
        for bookId in bookIds{
            guard let recommendedBookId = bookId.id else {return}
            service.requestBookFromApiWith(bookId: recommendedBookId) { bookDataModel in
                temporaryData.append(ThumbnailDataModel(id: bookDataModel.id, title: bookDataModel.volumeInfo?.title, authors: bookDataModel.volumeInfo?.authors, smallThumbnail: bookDataModel.volumeInfo?.imageLinks?.smallThumbnail, thumbnail: bookDataModel.volumeInfo?.imageLinks?.thumbnail))
                self.recommendationThumbnailDatas = temporaryData
            }
        }
        
    }
}
