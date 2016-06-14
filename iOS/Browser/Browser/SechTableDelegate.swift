//
//  SechTableDelegate.swift
//  Browser
//
//  Created by Burak Erol on 31.05.16.
//  Copyright © 2016 SECH-Tag-EEXCESS-Browser. All rights reserved.
//

import Foundation
import UIKit

class SechTableViewDelegate: NSObject, UITableViewDelegate{
    
    internal var viewCtrl: ViewController!
    
func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
    

        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        viewCtrl.indexPathForSelectedSearchTag = indexPath.row
        
        let currentCell = tableView.cellForRowAtIndexPath(indexPath)! as UITableViewCell
        
        viewCtrl.headLine = (currentCell.textLabel?.text!)! as String
        print("\n\n\n\n\n\n\n")
        print("selected: "+viewCtrl.headLine)
    
    return indexPath
}
}