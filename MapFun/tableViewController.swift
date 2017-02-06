//
//  tableView.swift
//  GoApp
//
//  Created by X on 12/9/16.
//  Copyright © 2016 Brenda Kaing. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class tableViewController: UITableViewController {
    
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var myEvents: [Event] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //    ****************** MARK: Core Data
    func fetchData() {
        let eventRequest = NSFetchRequest<Event>(entityName: "Event")
        do {
            let results = try managedObjectContext.fetch(eventRequest as! NSFetchRequest<NSFetchRequestResult>)
            myEvents = results as! [Event]
        } catch {
            print("\(error)")
        }
    }
    
    //    ****************** MARK: Table
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myEvents.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell")
        cell?.textLabel?.text = myEvents[indexPath.row].title! + " - " + dateFormat(date: myEvents[indexPath.row].date! as Date)
        cell?.textLabel?.textColor = UIColor.white
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    
    //******************** MARK: - Seque
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showEvent" {
            let navigationController = segue.destination as! UINavigationController
            let controller = navigationController.topViewController as! EventDetailsViewController
            if let IndexPath = tableView.indexPath(for: sender as! UITableViewCell) {
                controller.eventToShow = myEvents[IndexPath.row]
            }
        }
    }
    
    @IBAction func mapButtonPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //*************** MARK: - swipeToDelete
    weak var delegate: DeleteFromMyListDelegate?
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            managedObjectContext.delete(myEvents[indexPath.row])
            if managedObjectContext.hasChanges {
                do {
                    try managedObjectContext.save()
                    print("Success")
                    tableView.reloadData()
                    viewDidLoad()
                } catch {
                    print("\(error)")
                }
            }
            tableView.reloadData()
            delegate?.deletedAnEvent(controller: self)
        }
    }
    
}
