//
//  BookDescriptionViewController.swift
//  NextRead
//
//  Created by Javier Fransiscus on 29/09/21.
//

import UIKit

class BookDescriptionViewController: UIViewController {

    @IBOutlet weak var bookDescriptionTextView: UITextView!
    
    var bookDescription: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigation()
        setBookDescription()
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

fileprivate extension BookDescriptionViewController{
    
    func setNavigation(){
        navigationController?.isNavigationBarHidden = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissController))
    }
    
    @objc
    func dismissController(){
        self.dismiss(animated: true, completion: nil)
    }
    
    func setBookDescription(){
        guard let description = bookDescription else {return}
        bookDescriptionTextView.text = description
    }
}
