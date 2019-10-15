//
//  NotesViewController.swift
//  Notes
//
//  Created by Dhruvil on 10/13/19.
//  Copyright © 2019 Dhruvil. All rights reserved.
//

import UIKit
import CoreData

class NotesViewController: UIViewController
{
    @IBOutlet weak var tableView: UITableView!
    var titles = [String]()
    var select = IndexPath()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
        fetchData()
    }
    
    @IBAction func addNotes(_ sender: Any)
    {
        let alert = UIAlertController(title: "Notes", message: "Enter title & message", preferredStyle: .alert)
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "Title"
        })

        alert.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Message"
        }
        let addaction = UIAlertAction(title: "Add", style: .default, handler: { action in
            
            if let title = alert.textFields?[0].text, let message = alert.textFields?[1].text {
                guard let managedContext = appDelegate?.persistentContainer.viewContext else {return}
                let addnotes = Note(context: managedContext)
                addnotes.title = title
                addnotes.message = message
                do {
                    try managedContext.save()
                    self.fetchData()
                } catch
                {
                    print("Error at save")
                }
            }
        })
        let cancelaction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(addaction)
        alert.addAction(cancelaction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func fetchData()
    {
        titles = []
        guard let managedContext = appDelegate?.persistentContainer.viewContext else {return}
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
        do
        {
            let result = try managedContext.fetch(fetch)
            for data in result as! [NSManagedObject]
            {
                titles.append(data.value(forKey: "title") as! String)
            }
        } catch
        {
            print("Error at fetch title")
        }
        tableView.reloadData()
    }
}

extension NotesViewController: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tablecell") as! TableViewCell
        cell.title.text = titles[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        select = indexPath
        performSegue(withIdentifier: "addnotes", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let DestVC = segue.destination as! DetailViewController
        DestVC.selectedCell = titles[select.row]
    }

}
