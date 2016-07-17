//
//  CloudKitClient.swift
//  Ga3an
//
//  Created by Abdelrahman Mohamed on 7/17/16.
//  Copyright © 2016 Abdelrahman Mohamed. All rights reserved.
//

import Foundation
import UIKit
import CloudKit

class CloudKitClient {
    
    var restaurants: [CKRecord] = []
    
    func getRecordsFromCloud(completionHandler: (success: Bool, error: NSError?) -> Void) {
        
        // Remove existing records before refreshing
        restaurants.removeAll()
//        tableView.reloadData()
        
        // Fetch data using convenience API
        let cloudContainer = CKContainer.defaultContainer()
        let publicDatabase = cloudContainer.publicCloudDatabase
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "Restaurant", predicate: predicate)
        query.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        // Create the query operation with the query
        let queryOperation = CKQueryOperation(query: query)
        queryOperation.desiredKeys = ["name", "type", "loaction"]
        queryOperation.queuePriority = .VeryHigh
        queryOperation.resultsLimit = 50
        
        queryOperation.recordFetchedBlock = { (record: CKRecord!) -> Void in
            
            if let restaurantRecord = record {
                self.restaurants.append(restaurantRecord)
            }
        }
        
        queryOperation.queryCompletionBlock = { (cursor: CKQueryCursor?, error: NSError?) -> Void in
            
            if (error != nil) {
                print("Failed to get data from iCloud - \(error?.localizedDescription)")
                completionHandler(success: false, error: error)
                return
            }
            
            print("Successfully retrieve the data from iCloud")
//            self.refreshControl?.endRefreshing()
            
            NSOperationQueue.mainQueue().addOperationWithBlock({
                
                completionHandler(success: true, error: nil)
//                self.spinner.stopAnimating()
//                self.tableView.reloadData()
            })
        }
        
        // Execute the query
        publicDatabase.addOperation(queryOperation)
        
    }
    
    class func sharedInstance() -> CloudKitClient {
        
        struct Singleton {
            static var sharedInstance = CloudKitClient()
        }
        
        return Singleton.sharedInstance
    }
}