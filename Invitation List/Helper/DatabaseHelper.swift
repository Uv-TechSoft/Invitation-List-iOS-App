//
//  DatabaseHelper.swift
//  Invitation List
//
//  Created by Imam MohammadUvesh on 05/12/21.


import Foundation
import CoreData
import UIKit

//MARK: Single Ton CRUD as CREATE READ UPDATE DELETE Class Operations

public class DatabaseHelper
{
    //MARK: Create Shared Instace of Class Allocated to Persistant Container
   static let shareInstance = DatabaseHelper()
    let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
   
    
    //MARK: Save User Function
    func saveUser(usersModel: UsersList)
    {
        if let context = context
        {
            let users = List(context: context)
            users.firstname = usersModel.firstname
            users.lastname = usersModel.lastname
            
            saveContext()
        }
    }
    
    //MARK: To Get All Users or Retrive Data From The database or CoreData
    func getallUsers() -> [List]
    {
        var usersArray = [List]()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "List")
        do {
            usersArray =
            try context?.fetch(fetchRequest) as? [List] ?? []
           } catch
        {
            print(error.localizedDescription)
        }
        return usersArray
    }
    
    //MARK: Update User Data in CoreDate or Database Logic
    func updateUsers(currentUsers: List, usersModel: UsersList)
    {
        currentUsers.firstname = usersModel.firstname
        currentUsers.lastname = usersModel.lastname
        
        saveContext()
    }
    
    //MARK: Delete User From the Database of CoreData
    func deleteUsers(users: List)
    {
        context?.delete(users)
        saveContext()
    }
    
    //MARK: Save Function Logic
    func saveContext()
    {
        if let context = context
        {
            do {
                try context.save()
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
    
}


