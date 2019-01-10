//
//  ViewController.swift
//  Todey
//
//  Created by newuser on 2018-12-15.
//  Copyright © 2018 Ferdin. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit
import ChameleonFramework

class TodoListViewController: SwipTableViewController {

    var todoItems: Results<Item>?
    let realm = try! Realm()
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var selectedCategory : Category?{
        didSet{
           loadData()
        }
    }
//    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 80.0
        //print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        tableView.separatorStyle = .none
 
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let colourHex = selectedCategory?.colour else{ fatalError()}
        
        title = selectedCategory?.name
        
        updateNavBar(withHexCode: colourHex)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
       updateNavBar(withHexCode: "1D9BF6")
    }
    
    //MARK: - NavBar SetUp Methods
    
    func updateNavBar(withHexCode colourHexCode : String){
        guard let navBar = navigationController?.navigationBar else {
            fatalError("Navigation Bar doesnot exist")
        }
        
        guard let navBarColour = UIColor(hexString: colourHexCode)else { fatalError()}
        
        navBar.tintColor = ContrastColorOf(navBarColour, returnFlat: true)
        navBar.barTintColor = navBarColour
        searchBar.barTintColor = navBarColour
        navBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor : ContrastColorOf(navBarColour, returnFlat: true)]
        
    }
    
    //MARK: - Tableview Datasource Methods.

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
    
        if let item = todoItems?[indexPath.row]{
        
        cell.textLabel?.text = item.title
        
            if let colour = UIColor(hexString: selectedCategory!.colour)?.darken(byPercentage : CGFloat(indexPath.row) / CGFloat(todoItems!.count)){
                cell.backgroundColor = colour
                cell.textLabel?.textColor = ContrastColorOf(colour, returnFlat: true)
            }
            
        cell.accessoryType = item.done == true ? .checkmark : .none
            
        }
        else{
            cell.textLabel?.text = "No Items Added"
        }
//        Short form of below is above!!!
        
//        if itemArray[indexPath.row].done == true{
//            cell.accessoryType = .checkmark
//        }else{
//            cell.accessoryType = .none
//        }
        
        return cell
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    //MARK: - Tableview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(itemArray[indexPath.row])
        
        if let item = todoItems?[indexPath.row]{
            do{
                try realm.write {
                    item.done = !item.done
                    //realm.delete(item) to delete te items
                }
            }catch{
                print("Error updating the data , \(item)")
            }
        }
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
//        todoItems[indexPath.row].done = !todoItems[indexPath.row].done
//
//        saveData()
//        if itemArray[indexPath.row].done == false{
//            itemArray[indexPath.row].done = true
//        }
//        else{
//            itemArray[indexPath.row].done = false
//        }
        
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Add New Items
    
    @IBAction func addItemPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add a todoey list item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
        
            if let currentCategory = self.selectedCategory{
                do{
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                }catch{
                    print("Error saving new items,\(error)")
                }
            }
            
            self.tableView.reloadData()
//

//            newItem.parentCategory = self.selectedCategory
//            newItem.done = false
//            self.itemArray.append(newItem)
//             //self.defaults.set(self.itemArray, forKey: "ToDoListArray")
//
//            self.saveData()
           
        }
        alert.addTextField { (alertTextfield) in
            alertTextfield.placeholder = "Create an item"
            textField = alertTextfield
        }
        alert.addAction(action)
        
        present(alert,animated: true,completion: nil)
    }
    
    
    func loadData(){

        //let request : NSFetchRequest<Item> = Item.fetchRequest()

        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)

        tableView.reloadData()

    }
    
    override func updateMode(at indexPath: IndexPath) {
        
        if let cellForDeletion = todoItems?[indexPath.row]{
            do{
                try realm.write {
                    realm.delete(cellForDeletion)
                }
            }
            catch{
                print("Error in deleting data")
            }
        }
    }
}

extension TodoListViewController:UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadData()

            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}
