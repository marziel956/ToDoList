
//
//  ViewController.swift
//  ToDoList
//
//  Created by Marcin Zieliński on 19/08/2024.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController{
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var itemArray = [Item]()
    
    var selectedCategory: Category?{
        didSet {
            loadItems()
        }
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    // zawarty tu kod daje dostęp do AppDelegate)
    
    //let itemKey = "TodoListArray"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    
        
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
//           tapGesture.cancelsTouchesInView = false
//           view.addGestureRecognizer(tapGesture)
        
        
        searchBar.delegate = self
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
      
    } // Do any additional setup after loading the view.
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }// metoda która pozwala ukryc klawiature
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
            hideKeyboard()
        }// ukrywanie klawiatury kiedy przewijamy tabele
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row] // uproszenie i skrócenie kodu dodając nowa stałą
        
        cell.textLabel?.text = item.title
        
        cell.accessoryType =  item.isDone ? .checkmark : .none   // aktywowanie checkmark'a kiedy nie jest włączony i jego dezaktywacja
        
        return cell
    }
    // Ta metoda jest wywoływana w celu skonfigurowania i zwrócenia komórki dla danego wiersza w tabeli.
    // Metoda pobiera komórkę z kolejki, ustawia jej etykietę tekstową na odpowiednią wartość z tablicy `itemArray`,
    // a następnie zwraca skonfigurowaną komórkę.
    //
    // Parametry:
    //   - tableView: Tabela, która żąda komórki.
    //   - indexPath: Ścieżka indeksu, która określa lokalizację wiersza w tabeli.
    // - return: Zwraca konfigurowany obiekt `UITableViewCell`.
    
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        //context.delete(itemArray[indexPath.row])
        //itemArray.remove(at: indexPath.row)
       
        
        itemArray[indexPath.row].isDone = !itemArray[indexPath.row].isDone
        
        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)  // wyłączenie i właczenie podswietlenia kiedy dotykamy na dany wiersz
    }
    
    //MARK: - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var alertText = UITextField() // dodatkowa zmienna lokalna
        
        let alert = UIAlertController(title: "Dodaj zadanie", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Dodaj", style: .default) { (action) in
            //co sie stanie gdy użytkownik kliknie przyciks dodaj(plus)
            
            
            
            let newItem = Item(context: self.context)
            newItem.title = alertText.text!
            newItem.isDone = false
            newItem.parentCategory = self.selectedCategory
            self.itemArray.append(newItem) // dodanie elementu do tablicy 'itemArray'
            
            self.saveItems()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Dodaj nowe zaplanowane zadanie"
            alertText = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK: - Model Manupulation Methods
    
    func saveItems() {
        do{
            try context.save()
        }catch {
            print("error saving context, \(error)")
        }
        self.tableView.reloadData() // ponowne załadowanie danych w tabeli
    }
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        }else{
            request.predicate = categoryPredicate
        }
//        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, predicate])
//        
//        request.predicate = compoundPredicate
    
            
        
    
        
    
        
        do{
            itemArray = try context.fetch(request)
        }catch{
            print("error fetching data from context, \(error)")
        }
        self.tableView.reloadData()
    }
}

//MARK: - Search bar methods
//extension ToDoListViewController: UISearchBarDelegate {
//    
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        let request: NSFetchRequest<Item> = Item.fetchRequest()
//        
//        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//        
//        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//    
//        loadItems(with: request)
//      
//        
//    }
//    
//    
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        if searchBar.text?.count == 0 {
//            loadItems()
//           
//        }
//    }
//}
extension ToDoListViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            // Załaduj wszystkie elementy, jeśli pole wyszukiwania jest puste
            loadItems()
            
        } else {
            // Przefiltruj wyniki na podstawie wpisanego tekstu
            let request: NSFetchRequest<Item> = Item.fetchRequest()
            let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchText)
            request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
            
            loadItems(with: request, predicate: predicate)
            
           
        }
        
        
        // Odśwież tabelę po każdej zmianie tekstu
        tableView.reloadData()
    }
}



