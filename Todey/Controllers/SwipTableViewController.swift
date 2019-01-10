//
//  SwipTableViewController.swift
//  Todey
//
//  Created by newuser on 2019-01-09.
//  Copyright © 2019 Ferdin. All rights reserved.
//

import UIKit
import SwipeCellKit
import RealmSwift

class SwipTableViewController: UITableViewController , SwipeTableViewCellDelegate{
  
    override func viewDidLoad() {
        super.viewDidLoad()

    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in

                self.updateMode(at: indexPath)
//            if let categoryForDeletion = self.categories?[indexPath.row]{
//                do{
//                    try self.realm.write {
//                        self.realm.delete(categoryForDeletion)
//                    }
//                }
//                catch{
//                    print("Unable to perform deletion")
//                }
//                
//            }
        }
        
        // customize the action appearance
        deleteAction.image = UIImage(named: "delete-icon")
        
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        return options
    }
    
    func updateMode(at indexPath : IndexPath){
        print("Deleted from superclass")
    }
    

}

