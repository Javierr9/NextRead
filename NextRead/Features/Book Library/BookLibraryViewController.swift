//
//  BookLibraryViewController.swift
//  NextRead
//
//  Created by Javier Fransiscus on 12/09/21.
//

import UIKit

class BookLibraryViewController: UIViewController {

    @IBOutlet weak var bookCollectionView: UICollectionView!
    @IBOutlet weak var booksTableView: UITableView!
    
    private let bookLibraryViewModel = BookLibraryViewModel()
    private var arrayOfBooks:[Book] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subscribeViewModel()
        setupNavigationTitle()
//        setupCollectionView()
        setupTableView()
        print("setup is donr")
        // Do any additional setup after loading the view.
    }
    

    override func viewWillAppear(_ animated: Bool) {
        bookLibraryViewModel.getFavoritedBooks()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}

 extension BookLibraryViewController{
     
     func setupTableView(){
         booksTableView.register(BooksTableViewCell.getNib(), forCellReuseIdentifier: BooksTableViewCell.identifier)
         booksTableView.dataSource = self
         booksTableView.delegate = self
     }
    func setupNavigationTitle(){
        title = "Book Library"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.isHidden = false
    }
    
     func subscribeViewModel(){
         bookLibraryViewModel.bindBookLibraryViewModelToController = {
             self.bindData()
         }
     }
    
    func bindData(){
        print("this function is never called now is finally called")
        arrayOfBooks = bookLibraryViewModel.setOfBooks ?? []
        DispatchQueue.main.async {
            self.bookCollectionView.reloadData()
            self.booksTableView.reloadData()
        }
    }
    
//    func setupCollectionView(){
//        bookCollectionView.register(BooksCollectionViewCell.getNib(), forCellWithReuseIdentifier: BooksCollectionViewCell.identifier)
//        bookCollectionView.delegate = self
//        bookCollectionView.delegate = self
//    }
    
}

//extension BookLibraryViewController: UICollectionViewDataSource, UICollectionViewDelegate{
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return arrayOfBooks.count
//    }
//
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return 1
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = bookCollectionView.dequeueReusableCell(withReuseIdentifier: BooksCollectionViewCell.identifier, for: indexPath) as! BooksCollectionViewCell
//        cell.book = arrayOfBooks[indexPath.row]
//
//        return cell
//    }
//
//
//}

extension BookLibraryViewController: UITableViewDelegate, UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfBooks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BooksTableViewCell.identifier, for: indexPath) as! BooksTableViewCell
        
        cell.book = arrayOfBooks[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let action = UIContextualAction(style: .destructive, title: "Delete") { contextualAction, view, completionHandler in
            let bookToRemove = self.arrayOfBooks[indexPath.row]
            self.bookLibraryViewModel.deleteBookFromFavorite(book: bookToRemove)
        }
        return UISwipeActionsConfiguration(actions: [action])
    }
    
}
