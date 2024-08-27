
//
//  ViewController.swift
//  ToDoList
//
//  Created by Marcin Zieliński on 19/08/2024.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController {

    var itemArray = [Item]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    // zawarty tu kod daje dostęp do AppDelegate)
    
    //let itemKey = "TodoListArray"
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))

        loadItem()
        } // Do any additional setup after loading the view.

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
    
        
        context.delete(itemArray[indexPath.row])
        itemArray.remove(at: indexPath.row)
        
       // itemArray[indexPath.row].isDone = !itemArray[indexPath.row].isDone

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

    func loadItem() {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        do{
            itemArray = try context.fetch(request)
        }catch{
            print("error fetching data from context, \(error)")
        }
    }
}





