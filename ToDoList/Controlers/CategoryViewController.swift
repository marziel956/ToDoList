//
//  CategoryViewController.swift
//  ToDoList
//
//  Created by Marcin Zieliński on 30/08/2024.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

    var categoryArray = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        loadCategory()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        
    }
    
    // MARK: - Hide Keyboard
    
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }// metoda która pozwala ukryc klawiature
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
            hideKeyboard()
        }
    
    
    
    // MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        let category = categoryArray[indexPath.row] // uproszenie i skrócenie kodu dodając nowa stałą
        
        cell.textLabel?.text = category.name
    
        
        
        return cell
    }
    
    
    

    // MARK: - Add New Categoris
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var alertText = UITextField() // dodatkowa zmienna lokalna
        
        let alert = UIAlertController(title: "Dodaj kategorie", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Dodaj", style: .default) { (action) in
            //co sie stanie gdy użytkownik kliknie przyciks dodaj(plus)
            
            let newCategory = Category(context: self.context)
            newCategory.name = alertText.text!
            
            
            self.categoryArray.append(newCategory) // dodanie elementu do tablicy 'itemArray'
            
            self.saveCategory()
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Dodaj nową kategorię"
            alertText = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        

        
    }
    


    
    // MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
        
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
        
        
        
        
    }
    
    
    

    // MARK: - Data Manipulation Methods
    // tutaj trzeba napisac co zrobic aby po wybraniu danej celi przejsc na nowy widok
    
    func saveCategory() {
        do{
            try context.save()
        }catch {
            print("error saving context, \(error)")
        }
        self.tableView.reloadData() // ponowne załadowanie danych w tabeli
    }
    
    func loadCategory(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        
        do{
            categoryArray = try context.fetch(request)
        }catch{
            print("error fetching data from context, \(error)")
        }
        self.tableView.reloadData()
    }
    
    
    
}
