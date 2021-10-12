//
//  RootViewController.swift
//  NextRead
//
//  Created by Javier Fransiscus on 11/09/21.
//

import UIKit

class RootViewController: UIViewController {
    
    @IBOutlet weak var searchResultTableView: UITableView!
    
    private let bookViewModel = BookViewModel()
    private var thumbnailDatas:[ThumbnailDataModel] = []
    
    private let searchController = UISearchController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        // Do any additional setup after loading the view.
    }

}

fileprivate extension RootViewController{
    
    func setupNavigation(){
        title = "Next Read"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.largeTitleTextAttributes = [.font:  UIFont(descriptor: UIFontDescriptor.preferredFontDescriptor(withTextStyle: .largeTitle).withDesign(.serif)!.withSymbolicTraits(.traitBold)!, size: 34)]
        navigationController?.navigationBar.titleTextAttributes = [.font:  UIFont(descriptor: UIFontDescriptor.preferredFontDescriptor(withTextStyle: .largeTitle).withDesign(.serif)!.withSymbolicTraits(.traitBold)!, size: 17)]
    }
    
    func setupTableView(){
        searchResultTableView.register(BooksTableViewCell.getNib(), forCellReuseIdentifier: BooksTableViewCell.identifier)
        searchResultTableView.dataSource = self
        searchResultTableView.delegate = self
    }
    
    func subscribeViewModel(){
        bookViewModel.bindBookViewModelToController = {
            self.bindData()
        }
    }
    
    func setupView(){
        setupNavigation()
        setupTableView()
        subscribeViewModel()
        setupSearchController()
    }
    
    func setupSearchController(){
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Titles"
        
    }
    
    func bindData(){
        thumbnailDatas = bookViewModel.thumbnailDatas ?? []
        DispatchQueue.main.async {
            self.searchResultTableView.reloadData()
        }
        
    }
    
    @objc func reloadBookViewModelSearch(){
                guard let query = searchController.searchBar.text else {return}
        
                bookViewModel.fetchDataWithQuery(query: query)
    }
    
}

extension RootViewController: UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UISearchBarDelegate{
    
    func updateSearchResults(for searchController: UISearchController) {

        
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.reloadBookViewModelSearch), object: nil)
        self.perform(#selector(self.reloadBookViewModelSearch), with: nil, afterDelay: 0.5)
    }
    
// SVProgressHUD
//    NSObject.cancelPreviousPerformRequestsWithTarget(self, selector: "reload", object: nil)
//        self.performSelector("reload", withObject: nil, afterDelay: 0.5)
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return thumbnailDatas.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BooksTableViewCell.identifier, for: indexPath) as! BooksTableViewCell
        cell.thumbnailData = thumbnailDatas[indexPath.row]
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = BookDetailViewController()
        viewController.bookId = thumbnailDatas[indexPath.row].id
        self.navigationController?.pushViewController(viewController, animated: true)
            
    }
    
}

