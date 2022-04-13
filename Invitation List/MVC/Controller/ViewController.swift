//
//  ViewController.swift
//  Invitation List
//
//  Created by Imam MohammadUvesh on 05/12/21.
//

import UIKit
import CoreData


class ViewController: UIViewController {
    
    //MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    //MARK: Variables
   // var arrData = [UsersList]()
    var userArray = [List]()
    override func viewDidLoad() {
        super.viewDidLoad()
        userArray = DatabaseHelper.shareInstance.getallUsers()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        controller()
        hideKeyboardWhenTapped()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(#function)
        
    }
    
    //MARK: Add Button Tapped
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        
        let alertController = UIAlertController(title: "Alert", message: "Message", preferredStyle: .alert)
        
        let save = UIAlertAction(title: "Save", style: .default) { _ in
//            if let firstname = alertController.textFields?.first?.text{
//                self.arrData.append(firstname)
//                self.contactTableView.reloadData()
//            }
            
            if let firstname = alertController.textFields?.first?.text, let lastname = alertController.textFields?[1].text{
                let contact = UsersList(firstname: firstname, lastname: lastname)
                DatabaseHelper.shareInstance.saveUser(usersModel: contact)
                self.userArray = DatabaseHelper.shareInstance.getallUsers()
                self.tableView.reloadData()
            }
            
            
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            print("cancel tapped")
        }
        
        alertController.addTextField { firstnameField in
            firstnameField.placeholder = "Enter Person Name"
        }
        
        alertController.addTextField { lastnameField in
            lastnameField.placeholder = "Enter Last Name"
        }
        
        alertController.addAction(save)
        alertController.addAction(cancel)

        self.present(alertController, animated: true)
    }

    
    
}

//MARK: Search Controller
extension ViewController
{
    func controller()
    {
        userArray = getallContacts()
        searchControl()
    }
    
    func getallContacts() -> [List]
        {
            return DatabaseHelper.shareInstance.getallUsers()
        }
    
    func searchControl()
     {
         let searchController = UISearchController(searchResultsController: nil)
         searchController.searchBar.placeholder = "Search"
         searchController.searchResultsUpdater = self
         searchController.obscuresBackgroundDuringPresentation = false
         navigationItem.searchController = searchController
         self.title = "Invitation List"
         self.definesPresentationContext = true
     }
}
//MARK: SearchResult Updating
extension ViewController:UISearchResultsUpdating
{
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchString = searchController.searchBar.text else{ return }
        print(searchString)
        if searchString.isEmpty
        {
            
            userArray = getallContacts()
        }
        else
        {
            userArray = getallContacts().filter
            {
                $0.firstname!.lowercased().contains(searchString.lowercased()) || $0.lastname!.lowercased().contains(searchString.lowercased())
            }
            
        }
        tableView.reloadData()
    }
}

//MARK: TableView DataSource Methods
extension ViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        userArray.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard var cell = tableView.dequeueReusableCell(withIdentifier: "cell") else{
            return UITableViewCell()
        }
        
        cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        
        cell.textLabel?.text = userArray[indexPath.row].firstname
        cell.detailTextLabel?.text = userArray[indexPath.row].lastname
//      cell.accessoryType = .detailDisclosureButton
    
        return cell
    }
}

//MARK: TableView Delegate Methods
extension ViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let editAction = UIContextualAction(style: .normal, title: "Edit") { (action, view, handler) in
            print("Edit Action Tapped")
            let controllerAlert = UIAlertController(title: "Alert", message: "Message", preferredStyle: .alert)
            
            let update = UIAlertAction(title: "Update", style: .default)
            {
                _ in print("Update Tapped")
                
                if let firstname = controllerAlert.textFields?.first?.text,
                   let lastname = controllerAlert.textFields?[1].text
                {
                    let contact = UsersList(firstname: firstname, lastname: lastname)
                    DatabaseHelper.shareInstance.updateUsers(currentUsers: self.userArray[indexPath.row], usersModel: contact)
                    self.tableView.reloadData()
                }
                
            }
            
            let cancel = UIAlertAction(title: "Cancel", style: .cancel)
            {
                _ in print("Cancel Tapped")
                
            }
            controllerAlert.addTextField {
                firstnameField in firstnameField.placeholder = self.userArray[indexPath.row].firstname
            }
            controllerAlert.addTextField {
                lastnameField in lastnameField.placeholder = self.userArray[indexPath.row].lastname
            }
            controllerAlert.addAction(update)
            controllerAlert.addAction(cancel)
            self.present(controllerAlert, animated: true)
            
        }
        editAction.backgroundColor = .blue
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, handler) in
            print("Delete Action Tapped")
            DatabaseHelper.shareInstance.deleteUsers(users: self.userArray[indexPath.row])
            self.userArray.remove(at: indexPath.row)
            self.tableView.reloadData()
        }
        deleteAction.backgroundColor = .red
        let configuration = UISwipeActionsConfiguration(actions: [editAction,deleteAction])
        return configuration
    }

}

//extension ViewController
//{
//    func hideKeyboardWhenTapped(){
//        let viewTap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
//        view.addGestureRecognizer(viewTap)
//    }
//
//    @objc
//    func dismissKeyboard(){
//        view.endEditing(true)
//    }
//}
