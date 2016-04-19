//
//  SearchQuery.swift
//  Browser
//
//  Created by Lothar Manuel Mödl on 22.03.16.
//  Copyright © 2016 SECH-Tag-EEXCESS-Browser. All rights reserved.
//

import UIKit

class SearchQuerys {
    
    private let /*var*/ mSearchQuerys:[SearchQuery]
    
//    var searchQuerys:[SearchQuery]{
//        get{
//            return mSearchQuerys
//        }
//    }
    
    init(mSearchQuerys:[SearchQuery]){
        self.mSearchQuerys = mSearchQuerys
    }
    
    func getSearchQuerys()->[SearchQuery]{
        return self.mSearchQuerys
    }
    
    
//    init(){
//        self.mSearchQuerys = []
//    }
//    
//    func addSearchQuery(searchQuery:SearchQuery){
//        self.mSearchQuerys.append(searchQuery)
//    }
}

class SearchQuery{

    private let index:Int
    private let searchContext:[SearchContext]
    private let url:String
    private let title:String
    
    init(index:Int,searchContext:[SearchContext],url:String,title:String){
        self.index = index
        self.searchContext = searchContext
        self.url = url
        self.title = title
    }
    
    func getSearchContext()->[SearchContext] {
        return self.searchContext
    }
    
    func getUrl()->String{
        return self.url
    }
    
    func getTitle()->String {
        return self.title
    }
    
    func getIndex()->Int{
        return self.index
    }
}
// SearchContext represent a KeyWord with attributes and filters for the searchEngine ToDO: In Wiki
class SearchContext{
    private let values:[String:AnyObject]
    private let filters:[String:AnyObject]
    
    init(values:[String:AnyObject],filters:[String:AnyObject]){
        self.values = values
        self.filters = filters
    }
    
    func getValues()->[String:AnyObject]{
        return self.values
    }
}
