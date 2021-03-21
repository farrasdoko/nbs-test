//
//  DataManager.swift
//  nbs-test
//
//  Created by Farras Doko on 24/02/21.
//

import UIKit
import CoreData

class CDManager {
    
    static let shared = CDManager()
    var objContext : NSManagedObjectContext
    
    init() {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        objContext = appDelegate!.persistentContainer.viewContext
    }
    
    func addData(movie: CDDetail) {
        guard let entity = NSEntityDescription.entity(forEntityName: "Favorite", in: objContext) else {return}
        let newData = NSManagedObject(entity: entity, insertInto: objContext)
    
        newData.setValue(movie.title, forKey: "title")
        newData.setValue(movie.genre, forKey: "genre")
        newData.setValue(movie.year, forKey: "year")
        newData.setValue(movie.image?.jpegData(compressionQuality: 1.0), forKey: "image")
        newData.setValue(movie.body, forKey: "body")
        newData.setValue(movie.banner?.jpegData(compressionQuality: 1.0), forKey: "banner")
        newData.setValue(movie.movieID, forKey: "movieID")
        
        do {
            try objContext.save()
            print("saved \(newData)")
        }catch let error as NSError{
            print("couldn't save. \(error)")
            fatalError()
        }
    }
    
    func loadData() -> [Favorite] {
        let request: NSFetchRequest<Favorite> = Favorite.fetchRequest()
        var favorites = [Favorite]()
        do {
            favorites = try objContext.fetch(request)
        } catch {
            print("error load data")
            fatalError()
        }
        return favorites
    }
    
    func deleteData(by id: NSManagedObjectID) {
        let object = objContext.object(with: id)
        objContext.delete(object)
        
        do {
            try objContext.save()
        } catch {
            print("delete data fail")
            fatalError()
        }
    }
    
    func deleteData(by movieID: String) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Favorite")
        let predicate = NSPredicate(format: "movieID = %@", movieID)
        request.predicate = predicate
        
        do {
            let objects = try objContext.fetch(request)
            for obj in objects {
                if let deleteObj = obj as? NSManagedObject {
                    objContext.delete(deleteObj)
                }
            }
            try objContext.save()
        } catch {
            print("delete by 'movieID' fail")
            fatalError()
        }
    }
}
