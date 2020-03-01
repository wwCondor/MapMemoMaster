//
//  CoreDataManager.swift
//  MapMemo
//
//  Created by Wouter Willebrands on 20/02/2020.
//  Copyright © 2020 Studio Willebrands. All rights reserved.
//

import CoreData

class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "MapMemo")
        container.loadPersistentStores { (description, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        let container = self.persistentContainer
        return container.viewContext
    }()
    
    lazy var fetchedResultsController: NSFetchedResultsController<Reminder> = {
        let fetchRequest: NSFetchRequest<Reminder> = Reminder.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "isActive", ascending: false), NSSortDescriptor(key: "title", ascending: true)]
        let fetchResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        return fetchResultsController
    }()
}

extension NSManagedObjectContext {
    func saveChanges() {
        if self.hasChanges {
            do {
                try save()
            } catch {
                fatalError("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func fetchReminder(with locationName: String, context: NSManagedObjectContext) -> Reminder? {
        
        let request = NSFetchRequest<Reminder>(entityName: "Reminder")
        request.predicate = NSPredicate(format: "locationName == %@", locationName)
        
        do {
            let reminders = try context.fetch(request)
            return reminders.first
        } catch {
            // Handled at callsite
            print("Could not fetch reminder by location name, error: \(error.localizedDescription)")
            return nil
        }
    }
    
    func fetchReminderWith(title: String, context: NSManagedObjectContext) -> Reminder? {
        
        let request = NSFetchRequest<Reminder>(entityName: "Reminder")
        request.predicate = NSPredicate(format: "title == %@", title)
        
        do {
            let reminders = try context.fetch(request)
            return reminders.first
        } catch {
            // Handled at callsite
            print("Could not fetch reminder by location name, error: \(error.localizedDescription)")
            return nil
        }
    }
}
