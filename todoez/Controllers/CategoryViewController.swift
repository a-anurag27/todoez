//
//  CategoryViewController.swift
//  todoez
//
//  Created by Anurag A on 27/04/19.
//  Copyright © 2019 Anurag A. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {

    let realm = try! Realm()
    
    var categories : Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categegories Added Yet!"
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row] 
        }
    }
    
    func save(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error Saving Category \(error)")
        }
        tableView.reloadData()
    }
    
    func loadCategories() {
        categories = realm.objects(Category.self)
        tableView.reloadData()
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "title", style: .default) { (action) in
            let newCategory = Category()
            newCategory.name = textField.text!
            self.save(category: newCategory)
        }
        alert.addAction(action)
        alert.addTextField { (field) in
            textField = field
            textField.placeholder = "Add a new Category"
        }
        present(alert, animated: true, completion: nil)
    }
}
