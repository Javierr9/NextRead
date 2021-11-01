//
//  BookLibraryViewModel.swift
//  NextRead
//
//  Created by Javier Fransiscus on 21/09/21.
//

import Foundation

enum SortBy {
    case alphabet
    case date
}

class BookLibraryViewModel: NSObject {
    private var coreDataManager: CoreDataManager!

    private var setOfBooks: [Book]?

    var thumbnailDatas: [ThumbnailDataModel]? {
        didSet {
            bindBookLibraryViewModelToController()
        }
    }

    var bindBookLibraryViewModelToController: (() -> Void) = {}

    override init() {
        super.init()
        coreDataManager = CoreDataManager.shared
    }

    func getFavoritedBooks() {
        setOfBooks = coreDataManager.fetchFavorite()
        setupThumbnailDatas()
    }

    func deleteBookFromFavorite(byId id: String) {
        coreDataManager.deleteFavorite(byBookID: id)
        getFavoritedBooks()
    }

    func getFavoritedBooks(sortBy: SortBy) {
        switch sortBy {
        case .alphabet:
            print("sortByAlphabets")
            setOfBooks = coreDataManager.fetchFavoriteSortedAlphabetically()
            setupThumbnailDatas()
        default:
            getFavoritedBooks()
            setOfBooks = coreDataManager.fetchFavorite()
            setupThumbnailDatas()
        }
    }
}

private extension BookLibraryViewModel {
    func setupThumbnailDatas() {
        thumbnailDatas = []
        guard let books = setOfBooks else { return }
        for book in books {
            thumbnailDatas?.append(ThumbnailDataModel(id: book.id, title: book.title, authors: book.authors, smallThumbnail: book.smallThumbnail, thumbnail: book.thumbnail))
        }
    }
}
