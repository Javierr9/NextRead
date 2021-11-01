//
//  BookViewModel.swift
//  NextRead
//
//  Created by Javier Fransiscus on 14/09/21.
//

import Foundation

class BookViewModel: NSObject {
    private var service: NetworkRequest!

    // Viewmodel akan berinteraksi dengan service/server/network request
    private(set) var thumbnailDatas: [ThumbnailDataModel]? {
        didSet {
            bindBookViewModelToController()
        }
    }

    private(set) var dataFromAPI: BookModel?

    // Create a property in view model named "bindBookViewModelToController"
    // This property needs to be called from the view controller

    var bindBookViewModelToController: (() -> Void) = {}

    override init() {
        super.init()
        service = NetworkRequest()
    }

    func fetchDataWithQuery(query: String) {
        let queryChanged = query.replacingOccurrences(of: " ", with: "+")
        service.requestDataFromApiWith(searchQuery: queryChanged) { object in
            self.dataFromAPI = object
            self.setupThumbnailDatas()
        }
    }
}

private extension BookViewModel {
    func setupThumbnailDatas() {
        var thumbnailTemporaryData: [ThumbnailDataModel] = []
        guard let dataResponse = dataFromAPI?.data else { return }
        for data in dataResponse {
            thumbnailTemporaryData.append(ThumbnailDataModel(id: data.id, title: data.volumeInfo?.title, authors: data.volumeInfo?.authors, smallThumbnail: data.volumeInfo?.imageLinks?.smallThumbnail, thumbnail: data.volumeInfo?.imageLinks?.thumbnail))
        }
        thumbnailDatas = thumbnailTemporaryData
    }
}
