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
    @IBOutlet weak var booksCollectionView: UICollectionView!
    @IBOutlet weak var changeLayoutButton: UIButton!
    @IBOutlet weak var sortButton: UIButton!
    
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
    
    @IBAction func toggleTableViewPressed(_ sender: UIButton) {
        if sender.isSelected{
            booksTableView.isHidden = true
            booksCollectionView.isHidden = false
        }else{
            booksTableView.isHidden = false
            booksCollectionView.isHidden = true
        }
    }
    
    @IBAction func sortMenuOpened(_ sender: Any) {
        presentSortModal()
    }
    
}

fileprivate extension BookLibraryViewController{
    
    func setupView(){
        subscribeViewModel()
        setupNavigation()
        setupTableView()
        setupCollectionView()
        setupButton()
    }
    
    
    func setupButton(){
        changeLayoutButton.setTitle("", for: .normal)
        changeLayoutButton.changesSelectionAsPrimaryAction = true
        
        sortButton.menu = UIMenu(children: [
            UIAction(title: "Recent", handler: sortByRecent),
            UIAction(title: "Title", handler: sortByTitle),
            UIAction(title: "Other Action ", handler: sortByTitle),
        ])
        
        sortButton.changesSelectionAsPrimaryAction = true
        sortButton.showsMenuAsPrimaryAction = true
    }
    
    
    
    func setupCollectionView(){
        booksCollectionView.register(BooksCollectionViewCell.getNib(), forCellWithReuseIdentifier: BooksCollectionViewCell.identifier)
        booksCollectionView.dataSource = self
        booksCollectionView.delegate = self
      
        
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
            self.booksCollectionView.reloadData()
        }
    }
    
    func presentSortModal(){
        
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
            return 106
        }
    }
}

extension BookLibraryViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return thumbnailDatas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BooksCollectionViewCell.identifier, for: indexPath) as! BooksCollectionViewCell
        
        cell.thumbnailData = thumbnailDatas[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let viewController = BookDetailViewController()
        viewController.bookId = thumbnailDatas[indexPath.row].id
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let yourWidth = (collectionView.bounds.width/2.0) - 15
        let yourHeight = yourWidth * 1.46
        
        return CGSize(width: yourWidth, height: yourHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 30
    }
    
}


extension BookLibraryViewController: SettingsTableViewDelegate{
    func sortBookByRecentProtocolFunction() {
        print("protocol function working")
        bookLibraryViewModel.getFavoritedBooks(sortBy: .alphabet)
    }
    
    
}

