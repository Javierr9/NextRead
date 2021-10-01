//
//  BookLibraryViewController.swift
//  NextRead
//
//  Created by Javier Fransiscus on 12/09/21.
//

import UIKit

class BookLibraryViewController: UIViewController {

    @IBOutlet weak var booksTableView: UITableView!
    
    private let bookLibraryViewModel = BookLibraryViewModel()
    private var thumbnailDatas:[ThumbnailDataModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    

    override func viewWillAppear(_ animated: Bool) {
        bookLibraryViewModel.getFavoritedBooks()
    }
}

 extension BookLibraryViewController{
     
     func setupView(){
         subscribeViewModel()
         setupNavigation()
         setupTableView()
     }
     
     func setupTableView(){
         booksTableView.register(BooksTableViewCell.getNib(), forCellReuseIdentifier: BooksTableViewCell.identifier)
         booksTableView.dataSource = self
         booksTableView.delegate = self
     }
    func setupNavigation(){
        title = "Book Library"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
    }
    
     func subscribeViewModel(){
         bookLibraryViewModel.bindBookLibraryViewModelToController = {
             self.bindData()
         }
     }
    
    func bindData(){
        thumbnailDatas = bookLibraryViewModel.thumbnailDatas ?? []
        DispatchQueue.main.async {
            self.booksTableView.reloadData()
        }
    }
    
    
}

extension BookLibraryViewController: UITableViewDelegate, UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return thumbnailDatas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BooksTableViewCell.identifier, for: indexPath) as! BooksTableViewCell
        cell.thumbnailData = thumbnailDatas[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let action = UIContextualAction(style: .destructive, title: "Delete") { contextualAction, view, completionHandler in
            guard let id = self.thumbnailDatas[indexPath.row].id else {return}
            self.bookLibraryViewModel.deleteBookFromFavorite(byId: id)
        }
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = BookDetailViewController()
        viewController.bookId = thumbnailDatas[indexPath.row].id
        self.navigationController?.pushViewController(viewController, animated: true)
        
    }
}
