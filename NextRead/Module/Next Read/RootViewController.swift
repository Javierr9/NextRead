//
//  RootViewController.swift
//  NextRead
//
//  Created by Javier Fransiscus on 11/09/21.
//

import UIKit

class RootViewController: UIViewController {
    
    @IBOutlet weak var searchResultTableView: UITableView!
    
    var books:[Book] = [Book(id: "1", title: "The Intelligent Investor", authors: "Benjamin Graham", desc: "This is the description just for example", imageUrl: "http://books.google.com/books/content?id=TFJfCc8Q9GUC&printsec=frontcover&img=1&zoom=5&edge=curl&source=gbs_api", url: "")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationTitle()
        setupTableView()
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
    
}

extension RootViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        books.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BooksTableViewCell.identifier, for: indexPath) as! BooksTableViewCell
        
        cell.setCellData(book: books[indexPath.row])
        return cell
    }
    
    
}
