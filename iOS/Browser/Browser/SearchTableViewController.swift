//
//  SearchTableViewController.swift
//  Browser
//
//  Created by Philipp Winterholler  on 08.01.16.
//  Copyright © 2016 SECH-Tag-EEXCESS-Browser. All rights reserved.
//
// This class implements the Delegate and Controller for the tableView that displayes the titels of the found search-tags.
// At the top the class-varables are defined and below tableView-controller-specific methods are collected.
// For the tableViewDATASOURCE look for file SechTableDataSource.swift.

import UIKit

class SearchTableViewController: UITableViewController {

    //#########################################################################################################################################
    //##########################################################___Class_Variables___##########################################################
    //#########################################################################################################################################
    
    var searchLists : [SearchResultItem] = [SearchResultItem(title: "Test", provider: "unknown", uri: "http://www.google.de", language: "de", mediaType: "text")]
    var sechWebView: UIWebView!

    
    let providersDictonary = ["swissbib.ch":"Swissbib","coro.ac.uk":"CORE.ac.uk","mendeley.com":"Mendeley","zbw.eu":"ZBW","dp.la":"Digital%20Public%20Library%20of%20America","nationalarchives.gov.uk":"The%20National%20Archives%20UK","rijksmuseum.nl":"RijksMuseum","dnb.de":"DeutscheNationalbibliothek","europeana.eu":"Europeana","kgportal.bl.ch":"KIMPortal","deutsche-digitale-bibliothek.de":"Deutsche%20Digitale%20Bibliothek","duckduckgo":"","faroo":""]
    
    //#########################################################################################################################################
    //##########################################################___Table_ViewController_Methods___#############################################
    //#########################################################################################################################################
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source


    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        self.tableView.backgroundColor = UIColor.clearColor()
        return searchLists.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("listCell", forIndexPath: indexPath) as! SearchCell
        
        cell.backgroundColor = UIColor.clearColor()
        
        cell.textLabelTitle.text! = searchLists[indexPath.row].getTitle()
        cell.textLabelUri.text! = searchLists[indexPath.row].getUri()
        
        for (pkey,pvalue) in providersDictonary {

            if searchLists[indexPath.row].getUri().contains(pkey){
                
                print("https://eexcess.joanneum.at/eexcess-privacy-proxy-issuer-1.0-SNAPSHOT/issuer/getPartnerFavIcon?partnerId="+pvalue)
                
                print("##########################################")
                var url = NSURL(string : "https://eexcess.joanneum.at/eexcess-privacy-proxy-issuer-1.0-SNAPSHOT/issuer/getPartnerFavIcon?partnerId="+pvalue)

                if pkey.contains("duckduckgo"){
                    url = NSURL(string : "https://duckduckgo.com/favicon.ico")
                }
                if pkey.contains("faroo"){
                    url = NSURL(string : "http://www.faroo.com/favicon.ico")
                }
                if(url != nil){
                    let data = NSData(contentsOfURL: url!)
                    if (data != nil)
                    {
                        cell.imageIcon.image = UIImage(data: data!)
                    }
                    return cell
                }

            }
            
        }
        cell.imageIcon.image = UIImage(named:"AppIconPopUp")
         return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let requesturl = NSURL(string: searchLists[indexPath.row].getUri())
        let request = NSURLRequest(URL: requesturl!)
               
        sechWebView.loadRequest(request)
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
