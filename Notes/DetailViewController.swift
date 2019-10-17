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
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "Notes", style: .plain, target: self, action: #selector(DetailViewController.back(sender:)))
        self.navigationItem.leftBarButtonItem = newBackButton
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
    func updateData()
    {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else {return}
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
        fetch.predicate = NSPredicate(format: "title == %@", selectedCell)
        do
        {
            let result = try managedContext.fetch(fetch)
            let object = result[0] as! NSManagedObject
            object.setValue(message.text, forKey: "message")
            do
            {
                try managedContext.save()
            } catch
            {
                print("error at save update")
            }
        } catch
        {
            print("error at fetch data in update")
        }
    }
    
    @objc func back(sender: UIBarButtonItem) {
        updateData()
        _ = navigationController?.popViewController(animated: true)
    }
}
