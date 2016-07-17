//
//  DiscoverTableViewController.swift
//  Ga3an
//
//  Created by Abdelrahman Mohamed on 6/26/16.
//  Copyright © 2016 Abdelrahman Mohamed. All rights reserved.
//

import UIKit
import CloudKit

class DiscoverTableViewController: UITableViewController {
    
    @IBOutlet var spinner: UIActivityIndicatorView!
    
    var restaurants: [CKRecord] = []
    var imageCache:NSCache = NSCache()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        spinner.hidesWhenStopped = true
        spinner.center = view.center
        view.addSubview(spinner)
        spinner.startAnimating()
        
        getRecordsFromCloud()
        
        getRefreshControl()
    }
    
    func getRefreshControl() {
        
        // Remove existing records before refreshing
        restaurants.removeAll()
        tableView.reloadData()
        
        // pull to Refresh Control
        refreshControl = UIRefreshControl()
        refreshControl?.backgroundColor = UIColor.whiteColor()
        refreshControl?.tintColor = UIColor.grayColor()
        refreshControl?.addTarget(self, action: #selector(DiscoverTableViewController.getRecordsFromCloud), forControlEvents: UIControlEvents.ValueChanged)
    }
    
    func getRecordsFromCloud() {
        
        // Remove existing records before refreshing
        restaurants.removeAll()
        tableView.reloadData()
        
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
                self.showError("Error in iCloud", mes: "Failed to get data from iCloud)")
                return
            }
            
            print("Successfully retrieve the data from iCloud")
            self.refreshControl?.endRefreshing()
            
            NSOperationQueue.mainQueue().addOperationWithBlock({
                self.spinner.stopAnimating()
                self.tableView.reloadData()
            })
        }
        
        // Execute the query
        publicDatabase.addOperation(queryOperation)
        
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return restaurants.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! DiscoverTableViewCell
        
        // Configure the cell...
        let restaurant = restaurants[indexPath.row]
        cell.nameLabel.text = restaurant.objectForKey("name") as? String
        cell.typeLabel.text = restaurant.objectForKey("type") as? String
        cell.locationLabel.text = restaurant.objectForKey("loaction") as? String
        print(cell.locationLabel.text)

        // Set default image
        cell.bgImageView.image = nil
        
        // Check if the image is stored in cache
        if let imageFileURL = imageCache.objectForKey(restaurant.recordID) as? NSURL {
            // Fetch image from cache
            print("Get image from cache")
            cell.bgImageView.image = UIImage(data: NSData(contentsOfURL: imageFileURL)!)
            
        } else {
            
            // Fetch Image from Cloud in background
            let publicDatabase = CKContainer.defaultContainer().publicCloudDatabase
            let fetchRecordsImageOperation = CKFetchRecordsOperation(recordIDs: [restaurant.recordID])
            fetchRecordsImageOperation.desiredKeys = ["image"]
            fetchRecordsImageOperation.queuePriority = .VeryHigh
            
            fetchRecordsImageOperation.perRecordCompletionBlock = {(record:CKRecord?, recordID:CKRecordID?, error:NSError?) -> Void in
                
                if (error != nil) {
                    print("Failed to get restaurant image: \(error!.localizedDescription)")
//                    self.showError("Error", mes: "Failed to get restaurant image")
                    return
                }
                
                if let restaurantRecord = record {
                    NSOperationQueue.mainQueue().addOperationWithBlock() {
                        if let imageAsset = restaurantRecord.objectForKey("image") as? CKAsset {
                            cell.bgImageView.image = UIImage(data: NSData(contentsOfURL: imageAsset.fileURL)!)
                            
                            // Add the image URL to cache
                            self.imageCache.setObject(imageAsset.fileURL, forKey: restaurant.recordID)
                        }
                    }
                }
            }
            
            publicDatabase.addOperation(fetchRecordsImageOperation)
        }
        
        return cell
    }
    
    func showError(title:String, mes: String) {
        
        let optionMenu = UIAlertController(title: title, message: mes, preferredStyle: .Alert)
        // Add actions to the menu
        let cancelAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
        optionMenu.addAction(cancelAction)
        // Display the menu
        self.presentViewController(optionMenu, animated: true, completion: nil)
        
        spinner.stopAnimating()
    }
}
