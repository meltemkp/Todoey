//
//  ViewController.swift
//  Todoey
//
//  Created by Mac Book on 22.10.2018.
//  Copyright © 2018 Yunsa. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewContoller: SwipeTableViewController {
    
    let realm = try! Realm()
    
    var toDoItems : Results<Item>?
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var selectedCategory : Category? {
        
        didSet{
           loadItems()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        title = selectedCategory?.name
        
        guard let colourHex = selectedCategory?.cellBackgroundColor  else {fatalError("Selected category does not have color property")}
        
        updateNavBar(withHexCode: colourHex)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        updateNavBar(withHexCode: "1D91F6")
        
    }
    
    func updateNavBar(withHexCode colourHexCode:String) {
        
        guard let navBar = navigationController?.navigationBar else {fatalError("Navigation controller does not exist")}
        
        guard let  navBarColour = UIColor(hexString: colourHexCode) else {fatalError("Hex colour does not have correct format")}
        
        navBar.tintColor = ContrastColorOf(navBarColour, returnFlat: true)
        
        navBar.barTintColor = navBarColour
        
        navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : ContrastColorOf(navBarColour, returnFlat: true)]
        
        searchBar.barTintColor =  navBarColour
        
    }

    // MARK - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = toDoItems?[indexPath.row] {
        
            cell.textLabel?.text = item.title
        
            cell.accessoryType = item.done ? .checkmark : .none
            
            let colour = UIColor(hexString:selectedCategory!.cellBackgroundColor)
            
            if let cellColour = colour?.darken(byPercentage: CGFloat(indexPath.row)/CGFloat(toDoItems!.count)) {
                
                cell.backgroundColor = cellColour
                
                cell.textLabel?.textColor = ContrastColorOf(cellColour, returnFlat: true)
            }
            
            

        }
        else {
            
            cell.textLabel?.text =  "No items added"
        }
        
        
        
        return cell
        
    }
    
    // MARK - TableView Delegete Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = toDoItems?[indexPath.row]{
            
            do {
                try realm.write {
                    item.done = !item.done
                }
            } catch  {
                print("Error saving done status\(error)")
            }
            
        }
        
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    // MARK - Add New Items
    
    @IBAction func barButtonItemPressed(_ sender: UIBarButtonItem) {
        
        var alertText = UITextField()
        
        let alert = UIAlertController(title: "Add New Todo Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            if let currentCategory = self.selectedCategory {
            
                do{
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = alertText.text!
                        currentCategory.items.append(newItem)
                    }
                }catch{
                    
                    print("Error adding new item\(error)")
                    
                }
                
            }

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
    
    func loadItems(){
        
        toDoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)

        tableView.reloadData()

    }
    
    override func updateModel(indexPath: IndexPath) {
        
        if let item = toDoItems?[indexPath.row] {
            
            do {
                try realm.write {
                    realm.delete(item)
                }
            } catch  {
                print("Error deleting item\(error)")
            }
        }
    }

}


// MARK - Search bar methods
extension TodoListViewContoller : UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        toDoItems = toDoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
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


