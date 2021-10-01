//
//  BookViewModel.swift
//  NextRead
//
//  Created by Javier Fransiscus on 14/09/21.
//

import Foundation

class BookViewModel: NSObject {
    
    private var service:NetworkRequest!
    
    // Viewmodel akan berinteraksi dengan service/server/network request
    private(set) var thumbnailDatas: [ThumbnailDataModel]?{
        didSet{
            self.bindBookViewModelToController()
        }
    }
    
    private(set) var dataFromAPI:BookModel?
    
    
    
    // Create a property in view model named "bindBookViewModelToController"
    //This property needs to be called from the view controller
    
    var bindBookViewModelToController: (()-> ()) = {}
    
    override init(){
        super.init()
        service = NetworkRequest()
    }
    
    func fetchDataWithQuery(query: String){
        let queryChanged = query.replacingOccurrences(of: " ", with: "+")
        service.requestDataFromApiWith(searchQuery: queryChanged) { object in
            self.dataFromAPI = object
            self.setupThumbnailDatas()
        }
      
        
    }
   
}

fileprivate extension BookViewModel{
    
    func setupThumbnailDatas(){
        thumbnailDatas = []
        guard let dataResponse = dataFromAPI?.data else {return}
        for data in dataResponse{
            thumbnailDatas?.append(ThumbnailDataModel(id: data.id, title: data.volumeInfo?.title, authors: data.volumeInfo?.authors, smallThumbnail: data.volumeInfo?.imageLinks?.smallThumbnail))
        }
    }
    
}
