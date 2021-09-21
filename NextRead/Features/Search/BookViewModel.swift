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
    
    private(set) var dataFromAPI:BookModel?{
        didSet{
            self.bindBookViewModelToController()
        }
    }
    
    // Create a property in view model named "bindBookViewModelToController"
    //This property needs to be called from the view controller
    
    var bindBookViewModelToController: (()-> ()) = {}
    
    override init(){
        super.init()
        service = NetworkRequest()
    }
    
    func fetchDataWithQuery(query: String){
        let queryChanged = query.replacingOccurrences(of: " ", with: "+")
        service.requestDataFromAPIWithQuery(query: queryChanged) { object in
            self.dataFromAPI = object
        }
    }
   
}

fileprivate extension BookViewModel{
    
    func fetchData(){
        //Here we fetch the data from the API
        service.requestDataFromAPI { object in
            print(object)
            self.dataFromAPI = object
            
        }
    }
    
}
