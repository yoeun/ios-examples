//
//  MasterViewController.swift
//  ios-examples
//
//  Created by Yoeun Pen on 7/31/16.
//  Copyright © 2016 Yoeun Pen. All rights reserved.
//

import UIKit
import CoreData

class MainViewController: UITableViewController {

    var managedObjectContext: NSManagedObjectContext? = nil
    var heartRateViewController: HeartRateViewController?


    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.heartRateViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? HeartRateViewController
        }
    }

    override func viewWillAppear(animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Segues

//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if segue.identifier == "showDetail_hr" {
//            if let indexPath = self.tableView.indexPathForSelectedRow {
//                let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
//            }
//        }
//    }
}

