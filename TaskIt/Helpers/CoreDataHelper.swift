//
//  CoreDataHelper.swift
//  TaskIt
//
//  Created by Robert Wais on 8/2/18.
//

import Foundation
import CoreData
import UIKit

struct CoreDataHelper {
    
    static let context: NSManagedObjectContext = {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            //Possible Alert
            fatalError()
        }
        
        let persistentContainer = appDelegate.persistentContainer
        let context = persistentContainer.viewContext
        
        return context
    }()
    
    static func newCompanyId() -> CompanyId {
        let id = NSEntityDescription.insertNewObject(forEntityName: "CompanyId", into: context) as! CompanyId
        
        return id
    }
    
    static func saveId(){
        do{
            try context.save()
        } catch let error {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    static func deleteId(id: CompanyId){
        context.delete(id)
        saveId()
    }
    
    static func retrieveIds()->[String]{
        do{
            let fetchRequest = NSFetchRequest<CompanyId>(entityName:"CompanyId")
            var results = try context.fetch(fetchRequest)
            var ids = [String]()
            
            for res in results{
                if let id = res.id {
                    ids.append(id)
                }
            }
            return  ids
        }catch let error {
            print("Error: can not retrieve portfolios")
            return []
        }
    }
    
    
}
