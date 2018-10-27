//
//  ViewController.swift
//  Todoey
//
//  Created by Mac Book on 22.10.2018.
//  Copyright © 2018 Yunsa. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewContoller: UITableViewController {
    
    var itemArray = [Item]()
    
    var selectedCategory : Category? {
        
        didSet{
            loadItems()
        }
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    

    override func viewDidLoad() {
        super.viewDidLoad()
       // print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        loadItems()
        
    }

    // MARK - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done ? .checkmark : .none 
        
        return cell
        
    }
    
    // MARK - TableView Delegete Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
        
        saveItems()
        
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    // MARK - Add New Items
    
    @IBAction func barButtonItemPressed(_ sender: UIBarButtonItem) {
        
        var alertText = UITextField()
        
        let alert = UIAlertController(title: "Add New Todo Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            let item = Item(context: self.context)
            item.title = alertText.text!
            item.done = false
            item.parentCategory = self.selectedCategory
            self.itemArray.append(item)
            self.saveItems()
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Write New Item"
            alertText = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    // MARK - Data Manupilation Methods
    
    func saveItems() {
        
        do{
            try context.save()
            
        } catch {
            print("Error saving context, \(error)")
        }
        
    }
    
    func loadItems(With request : NSFetchRequest<Item> = Item.fetchRequest(),predicate : NSPredicate? = nil){
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let additionalPredicate = predicate{
            
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [additionalPredicate,categoryPredicate])
        } else{
            
            request.predicate = categoryPredicate
        }
        



        
        do{
            itemArray = try context.fetch(request)
        } catch {
            print("error fetching data from context \(error)")
        }
        
        tableView.reloadData()

    }
    

}


// MARK - Search bar methods
extension TodoListViewContoller : UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)

        request.predicate = predicate
        
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        
        request.sortDescriptors = [sortDescriptor]
        
        loadItems(With: request,predicate: predicate)
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text?.count == 0 {
            loadItems()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
        
    }
    
}


