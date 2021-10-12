//
//  CoreDataManager.swift
//  NextRead
//
//  Created by Javier Fransiscus on 21/09/21.
//

import Foundation
import CoreData

class CoreDataManager{
    
    static let shared = CoreDataManager()
    private init(){}
    
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "NextRead")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        return self.persistentContainer.viewContext
    }()
    
}

extension CoreDataManager{
    
    func fetchFavoriteIds() -> [String]?{
        var ids:[String] = []
        do{
            let request = Book.fetchRequest() as NSFetchRequest<Book>
            let predicate = NSPredicate(format: "isFavorite = %d", true)
            request.predicate = predicate
            let books = try managedObjectContext.fetch(request)
            for book in books{
                if let id = book.id{
                    ids.append(id)
                }
                
            }
            return ids
        }catch{
            print("\(error.localizedDescription)")
            fatalError()
        }
        
        
    }
    
    func fetchFavorite() -> [Book]?{
        do{
            let request = Book.fetchRequest() as NSFetchRequest<Book>
            let predicate = NSPredicate(format: "isFavorite = %d", true)
            request.predicate = predicate
            let books = try managedObjectContext.fetch(request)
            return books
        }catch{
            print("\(error.localizedDescription)")
            fatalError()
        }
        
        
    }
    
    func fetchFavoriteSortedAlphabetically() -> [Book]?{
        do{
            let request = Book.fetchRequest() as NSFetchRequest<Book>
            let predicate = NSPredicate(format: "isFavorite = %d", true)
            let bookTitleSort = NSSortDescriptor(key: "title", ascending: true)
            request.predicate = predicate
            request.sortDescriptors = [bookTitleSort]
            let books = try managedObjectContext.fetch(request)
            return books
        }catch{
            print("\(error.localizedDescription)")
            fatalError()
        }
    }
    
    func fetchFavoriteSortedRecetly() -> [Book]?{
        do{
            let request = Book.fetchRequest() as NSFetchRequest<Book>
            let predicate = NSPredicate(format: "isFavorite = %d", true)
            request.predicate = predicate
            let books = try managedObjectContext.fetch(request)
            return books
        }catch{
            print("\(error.localizedDescription)")
            fatalError()
        }
    }
    func addFavorite(using model: BookDataModel){
        //Filter if book dont have then add
        guard let id = model.id else {return}
        if !checkBookExist(bookID: id){
            let book = Book(context: managedObjectContext)
            book.id = model.id
            book.title = model.volumeInfo?.title
            book.authors = model.volumeInfo?.authors
            book.isFavorite = true
            book.smallThumbnail = model.volumeInfo?.imageLinks?.smallThumbnail
            book.thumbnail = model.volumeInfo?.imageLinks?.thumbnail
            //book.isRecent = true sih harusnya
            do{
                try managedObjectContext.save()
            }catch{
                print("\(error.localizedDescription)")
                fatalError()
            }
            
        }
        
        
        
    }
    
    func addFavorite(using book: Book){
        //Filter if book dont have then add
        guard let id = book.id else {return}
        if !checkBookExist(bookID: id){
            let bookToBeSaved = Book(context: managedObjectContext)
            bookToBeSaved.id = book.id
            bookToBeSaved.title = book.title
            bookToBeSaved.isFavorite = true
            bookToBeSaved.smallThumbnail = book.smallThumbnail
            bookToBeSaved.thumbnail = book.thumbnail
            //book.isRecent = true sih harusnya
            do{
                try managedObjectContext.save()
            }catch{
                print("\(error.localizedDescription)")
                fatalError()
            }
            
        }
        
        
        
    }
    
    func checkBookExist(bookID: String) -> Bool{
        var book:[Book]? = []
        do{
            let request = Book.fetchRequest() as NSFetchRequest<Book>
            book = try managedObjectContext.fetch(request)
            
            
        }catch{
            print("\(error.localizedDescription)")
            fatalError()
        }
        if book?.count == 0 {
            return false
        }else{
            
            book = fetchBookById(bookID: bookID)
            if book?.count == 0{
                return false
            }else{
                return true
            }
            
            
            
            
        }
        
    }
    
    func deleteFavorite(byBook bookObject: Book){
        
        let bookToBeDeleted = bookObject
        
        managedObjectContext.delete(bookToBeDeleted)
        
        do{
            try managedObjectContext.save()
        }catch{
            print("\(error.localizedDescription)")
            fatalError()
        }
        
        
    }
    
    func deleteFavorite(byBookID id: String){
        guard let bookToBeDeleted = fetchBookById(bookID: id)?.first else {return}
        
        managedObjectContext.delete(bookToBeDeleted)
        
        do{
            try managedObjectContext.save()
        }catch{
            print("\(error.localizedDescription)")
            fatalError()
        }
    }
    
    func fetchRecentSearches() -> [Book]? {
        
        do{
            
            let request = Book.fetchRequest() as NSFetchRequest<Book>
            let predicate = NSPredicate(format: "isRecent = %d", true)
            request.predicate = predicate
            let books = try managedObjectContext.fetch(request)
            
            return books
        }catch{
            print("\(error.localizedDescription)")
            fatalError()
        }
        
        
    }
    
    
    func fetchBookById(bookID : String) -> [Book]?{
        do{
            let request = Book.fetchRequest() as NSFetchRequest<Book>
            let predicate = NSPredicate(format: "id = %@", bookID)
            request.predicate = predicate
            request.fetchLimit = 1
            let books = try managedObjectContext.fetch(request)
            return books
            
        }catch{
            print("\(error.localizedDescription)")
            fatalError()
        }
        
    }
    
    func addRecentSearches(){
        //TODO: Validate if the books is not already in here
    }
    
    func deleteRecentResearches(){
        
        //TODO: Get all recent searches
    }
    
    func deleteAllRecentSearhes(){
        //TODO: Validate all delete recent by doing get all books then delete if exist delete the set
    }
    
}
