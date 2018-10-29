//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Mac Book on 27.10.2018.
//  Copyright © 2018 Yunsa. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit

class CategoryViewController: UITableViewController {
    
    let realm = try! Realm()
    
    var categories : Results<Category>?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 80.0
        
        loadCategories()

    }
    
    
    // MARK - Tableview Datasource Methods

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categories?.count ?? 1
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! SwipeTableViewCell
        
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No category added"
        
        cell.delegate = self
        
        return cell
    }
    
    
    
    // MARK - Tableview Delegete Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItem", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as? TodoListViewContoller
        
        if let indexPath = tableView.indexPathForSelectedRow {
            
            destinationVC?.selectedCategory = categories?[indexPath.row]
        }
        
    }
    

    
    //MARK - Add New Categories

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var alertTextview = UITextField()
        
        let alert = UIAlertController(title: "New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let category = Category()
            category.name = alertTextview.text!
            
            self.save(category: category)
            self.tableView.reloadData()
        }
        
        alert.addTextField { (textField) in
            textField.placeholder = "Category name"
            alertTextview = textField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    // MARK - Data Manupilation Methods
    
    func loadCategories(){

        categories = realm.objects(Category.self)
        
        tableView.reloadData()
        
    }
    
    
    func save(category : Category) {
        
        do{
            try realm.write {
                realm.add(category)
            }
            
        } catch {
            
            print("Error saving category\(error)")
        }
        
    }
    
}

// MARK - Swipe Cell Delegete Methods

extension CategoryViewController:SwipeTableViewCellDelegate{
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            
            if let currentCategory = self.categories?[indexPath.row] {
                
                do {
                    try self.realm.write {
                        self.realm.delete(currentCategory)
                    }
                } catch  {
                    print("Error deleting items\(error)")
                }
            }
            
        }
        
        deleteAction.image = UIImage(named: "delete-icon")
        
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        return options
    }
    
}

