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
    private var arrayOfBooks:[BookDataModel] = []
    
    private let searchController = UISearchController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        // Do any additional setup after loading the view.
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

fileprivate extension RootViewController{
    
    func setupNavigationTitle(){
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.isHidden = false
        title = "Next Read"
    
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
        setupNavigationTitle()
        setupTableView()
        subscribeViewModel()
        setupSearchController()
    }
    
    func setupSearchController(){
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
    }
    
    func bindData(){
        arrayOfBooks = bookViewModel.dataFromAPI?.data ?? []
        DispatchQueue.main.async {
            self.searchResultTableView.reloadData()
        }
        
    }
    
}

extension RootViewController: UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating{
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text else {return}
        
        bookViewModel.fetchDataWithQuery(query: query)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfBooks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BooksTableViewCell.identifier, for: indexPath) as! BooksTableViewCell
        
        cell.bookModel = arrayOfBooks[indexPath.row]
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = BookDetailViewController()
        viewController.bookDetail = arrayOfBooks[indexPath.row]
        self.navigationController?.pushViewController(viewController, animated: true)
            
    }
    
}

