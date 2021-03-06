//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Mac Book on 27.10.2018.
//  Copyright © 2018 Yunsa. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    
    var categories : Results<Category>?
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        loadCategories()

    }
    
    
    
    
    // MARK - Tableview Datasource Methods

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categories?.count ?? 1
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        guard let category = categories?[indexPath.row] else {fatalError("Category does not exist")}
        
        cell.textLabel?.text = category.name
        
        guard let categoryColor = UIColor(hexString: category.cellBackgroundColor) else {fatalError("Category colour does not exist")}
        
        cell.backgroundColor = categoryColor
        
        cell.textLabel?.textColor = ContrastColorOf(categoryColor, returnFlat: true)
        
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
            category.cellBackgroundColor = UIColor.randomFlat.hexValue()
            
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
    
    override func updateModel(indexPath:IndexPath){
        
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
}



