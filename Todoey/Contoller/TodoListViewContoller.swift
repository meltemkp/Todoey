//
//  ViewController.swift
//  Todoey
//
//  Created by Mac Book on 22.10.2018.
//  Copyright © 2018 Yunsa. All rights reserved.
//

import UIKit

class TodoListViewContoller: UITableViewController {
    
    var itemArray = [Item]()
//    let userDefault = UserDefaults.standard
    let dataFilePath = FileManager.default.urls(for:.documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        if let array = userDefault.array(forKey: "ItemArrayKey") as? [String] {
//        itemArray = array }
        
//        let item = Item()
//        item.done = true
//        item.title = "Find Mike"
//
//        let item2 = Item()
//        item2.title = "Buy Eggos"
//
//        let item3 = Item()
//        item3.title = "Destroy Demogorgon"
//
//        itemArray.append(item)
//        itemArray.append(item2)
//        itemArray.append(item3)
        
        let decoder = PropertyListDecoder()
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
        
        saveItems()
        
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    // MARK - Add New Items
    
    @IBAction func barButtonItemPressed(_ sender: UIBarButtonItem) {
        
        var alertText = UITextField()
        
        let alert = UIAlertController(title: "Add New Todo Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            let item = Item()
            item.title = alertText.text!
            
            self.itemArray.append(item)
            
//            self.userDefault.set(self.itemArray, forKey: "ItemArrayKey")
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
    
    func saveItems() {
        
        let encoder = PropertyListEncoder()
        
        do{
            
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
            
        } catch {
            print("Eroor with encoding array, \(error)")
        }
        
    }
    
    func loadItems(){
        
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            
            do{
            itemArray = try decoder.decode([Item].self, from: data)
            } catch {
                print("Error while decode")
            }
            
        }
        
    }
    
    
    

}


