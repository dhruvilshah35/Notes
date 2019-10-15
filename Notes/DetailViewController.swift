//
//  DetailViewController.swift
//  Notes
//
//  Created by Dhruvil on 10/14/19.
//  Copyright © 2019 Dhruvil. All rights reserved.
//

import UIKit
import CoreData

let appDelegate = UIApplication.shared.delegate as? AppDelegate

class DetailViewController: UIViewController {

    @IBOutlet weak var message: UITextView!
    var selectedCell: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
    }
    
    func fetchData()
    {
            guard let managedContext = appDelegate?.persistentContainer.viewContext else {return}
            let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
            fetch.predicate = NSPredicate(format: "title == %@", selectedCell)
            do
            {
                let test = try managedContext.fetch(fetch)
                for data in test as! [NSManagedObject]
                {
                    message.text = "\(data.value(forKey: "message") as? String ?? "")"
                }
            } catch
            {
                print("Error at fetch")
            }
    }  
}
