
//
//  ViewController.swift
//  ToDoList
//
//  Created by Marcin Zieliński on 19/08/2024.
//

import UIKit

class ToDoListViewController: UITableViewController {

    var itemArray = [Item]()
    
  
    //let itemKey = "TodoListArray"
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Item.plist")
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(dataFilePath)
        
     
        
        let newItem1 = Item()
        newItem1.title = "New Item1"
        itemArray.append(newItem1)
        
        let newItem2 = Item()
        newItem2.title = "New Item2"
        itemArray.append(newItem2)
        
        let newItem3 = Item()
        newItem3.title = "New Item3"
        itemArray.append(newItem3)
        
      //  if let items = defaults.array(forKey: itemKey) as? [Item]{
            
          //  itemArray = items

        }
         
        // Do any additional setup after loading the view.
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)

        
        let item = itemArray[indexPath.row] // uproszenie i skrócenie kodu dodając nowa stałą
        
        cell.textLabel?.text = item.title
        
        cell.accessoryType =  item.isDone ? .checkmark : .none   // aktywowanie checkmark'a kiedy nie jest włączony i jego dezaktywacja kod ponizej wykonuje to samo
       
         /*
          
        if item.isDone == true {
            cell.accessoryType = .checkmark
        }else {
            cell.accessoryType = .none
        }]
          
        */
        
        
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
        //print(itemArray[indexPath.row]) - wypis w konsoli który wiersz jest wybierany
        
        itemArray[indexPath.row].isDone = !itemArray[indexPath.row].isDone
        // kod wyzej wykonuje dokładnie to samo co poniżej
/*
        if itemArray[indexPath.row].isDone == false {
            itemArray[indexPath.row].isDone = true
        }else{
                itemArray[indexPath.row].isDone = false
        }
*/
        saveItems()
        
        
    
        tableView.deselectRow(at: indexPath, animated: true)  // wyłączenie i właczenie podswietlenia kiedy dotykamy na dany wiersz
    }
    
    
    
    
    
    //MARK: - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var alertText = UITextField() // dodatkowa zmienna lokalna
        
        let alert = UIAlertController(title: "Dodaj zadanie", message: "", preferredStyle: .alert)
        
        
        let action = UIAlertAction(title: "Dodaj", style: .default) { (action) in
            //co sie stanie gdy użytkownik kliknie przyciks dodaj(plus)
            
            let newItem = Item()
            newItem.title = alertText.text!
          
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
        let encoder = PropertyListEncoder()
        
        
        do{
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        }catch {
            print("error encoding item array, \(error)")
            
        }
        
        tableView.reloadData() // ponowne załadowanie danych w tabeli
    }
    
    
}





