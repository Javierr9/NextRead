//
//  BookLibraryViewController.swift
//  NextRead
//
//  Created by Javier Fransiscus on 12/09/21.
//

import UIKit

class BookLibraryViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationTitle()
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

fileprivate extension BookLibraryViewController{
    
    func setupNavigationTitle(){
        title = "Book Library"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.isHidden = false
    }
    
}
