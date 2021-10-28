//
//  BookLibraryViewController.swift
//  NextRead
//
//  Created by Javier Fransiscus on 12/09/21.
//

import UIKit
//TODO: Change action title Default and Title why the action doesnt want to change?

class BookLibraryViewController: UIViewController {
    
    @IBOutlet weak var booksTableView: UITableView!
    
    private let bookLibraryViewModel = BookLibraryViewModel()
    private var thumbnailDatas:[ThumbnailDataModel] = []
    private let spacing: CGFloat = 18.0
    
    private let sortByTitle = { (action: UIAction) in
        
    }
    
    private let sortByRecent = { (action: UIAction) in
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        bookLibraryViewModel.getFavoritedBooks()
    }
    
    
}

fileprivate extension BookLibraryViewController{
    
    func setupView(){
        subscribeViewModel()
        setupNavigation()
        setupTableView()
    }
    
    func setupTableView(){
        booksTableView.register(BooksTableViewCell.getNib(), forCellReuseIdentifier: BooksTableViewCell.identifier)
        booksTableView.register(SettingsTableViewCell.getNib(), forCellReuseIdentifier: SettingsTableViewCell.identifier)

        booksTableView.dataSource = self
        booksTableView.delegate = self
    }
    func setupNavigation(){
        title = "Library"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
//        navigationController?.navigationBar.largeTitleTextAttributes = [.font:  UIFont(descriptor: UIFontDescriptor.preferredFontDescriptor(withTextStyle: .largeTitle).withDesign(.serif)!.withSymbolicTraits(.traitBold)!, size: 34)]
//        navigationController?.navigationBar.titleTextAttributes = [.font:  UIFont(descriptor: UIFontDescriptor.preferredFontDescriptor(withTextStyle: .largeTitle).withDesign(.serif)!.withSymbolicTraits(.traitBold)!, size: 17)]

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
        return thumbnailDatas.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: SettingsTableViewCell.identifier, for: indexPath) as! SettingsTableViewCell
            cell.updateBookListRecent = {
                self.bookLibraryViewModel.getFavoritedBooks(sortBy: .date)
            }
            cell.delegate = self
            
            
            return cell
          
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: BooksTableViewCell.identifier, for: indexPath) as! BooksTableViewCell
            cell.thumbnailData = thumbnailDatas[indexPath.row - 1]
            return cell
        }
        
      
        
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if indexPath.row != 0 {
            let action = UIContextualAction(style: .destructive, title: "Delete") { contextualAction, view, completionHandler in
                guard let id = self.thumbnailDatas[indexPath.row - 1].id else {return}
                self.bookLibraryViewModel.deleteBookFromFavorite(byId: id)
            }
            return UISwipeActionsConfiguration(actions: [action])
        }else{
            return UISwipeActionsConfiguration()
        }
     
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row != 0 {
            let viewController = BookDetailViewController()
            viewController.bookId = thumbnailDatas[indexPath.row - 1].id
            self.navigationController?.pushViewController(viewController, animated: true)
        }

        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0{
            return 44
        }else{
            return 108
        }
    }
}


extension BookLibraryViewController: SettingsTableViewDelegate{
    func sortBookByRecentProtocolFunction() {
        print("protocol function working")
        bookLibraryViewModel.getFavoritedBooks(sortBy: .alphabet)
    }
    
    
}

