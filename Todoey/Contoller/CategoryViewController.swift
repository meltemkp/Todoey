//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Mac Book on 27.10.2018.
//  Copyright © 2018 Yunsa. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    var categoryArray = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()

    }
    
    
    // MARK - Tableview Datasource Methods

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = categoryArray[indexPath.row].name
        
        return cell
    }
    
    
    
    // MARK - Tableview Delegete Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItem", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as? TodoListViewContoller
        
        if let indexPath = tableView.indexPathForSelectedRow {
            
            destinationVC?.selectedCategory = categoryArray[indexPath.row]
        }
        
    }
    

    
    //MARK - Add New Categories

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var alertTextview = UITextField()
        
        let alert = UIAlertController(title: "New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            let category = Category(context: self.context)
            category.name = alertTextview.text!
            self.categoryArray.append(category)
            self.saveContext()
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
    
    func loadCategories(With request:NSFetchRequest<Category> = Category.fetchRequest()){

        do{
            categoryArray =  try context.fetch(request)
            
        }catch{
            
            print("Error fetching category \(error)")
        }
        
        tableView.reloadData()
        
    }
    
    
    func saveContext() {
        
        do{
            try context.save()
            
        } catch {
            
            print("Error saving category\(error)")
        }
        
    }
    
}

