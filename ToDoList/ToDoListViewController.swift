
//
//  ViewController.swift
//  ToDoList
//
//  Created by Marcin Zieliński on 19/08/2024.
//

import UIKit

class ToDoListViewController: UITableViewController {

    let itemArray = ["Find Mike", "Buy Eggs", "Go to Gym", "Clean House", "Pay Bills"]
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        itemArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row]
        
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
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(itemArray[indexPath.row]) - wypis w konsoli który wiersz jest wybierany
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }else
        {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }// aktywowanie checkmark'a kiedy nie jest włączony i jego dezaktywacja
        
        tableView.deselectRow(at: indexPath, animated: true)  // wyłączenie i właczenie podswietlenia kiedy dotykamy na dany wiersz
    }
    
}

