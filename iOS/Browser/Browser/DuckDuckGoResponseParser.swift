//
//  DuckDuckGoResponseParser.swift
//  Browser
//
//  Created by Andreas Ziemer on 12.05.16.
//  Copyright © 2016 SECH-Tag-EEXCESS-Browser. All rights reserved.
//
//

import Foundation


class DuckDuckGoResponseParser:AbstractResponseParser{
    
    let url: String
    let title: String
    let index: Int
    
    init(query:SearchQuery){
        url = query.getUrl()
        title = query.getTitle()
        index = query.getIndex()
    }
    
    func parse(data:NSData)->SearchResult?{

        var searchResultItems = [SearchResultItem]()
        let json = try? NSJSONSerialization.JSONObjectWithData(data, options: []) as! NSDictionary

        //Official site
        if let result = json!["Results"] as? Array<AnyObject>{
            
            for item in result{
                let u = item["FirstURL"] as! String
                let t = item["Text"] as! String
                let p = "duckduckgo"
                let l = "unknown"
                let m = "unknown"
                
                searchResultItems.append(SearchResultItem(title: t, provider: p, uri: u, language: l, mediaType: m))
            }
        }
        //Abstract
        let uri = json!["AbstractURL"] as! String
        let provider = json!["AbstractSource"] as! String
        let topic = json!["Heading"] as! String
        let mediaType = "unknown"
        let language = "unknown"
        if uri != "" && provider != "" && topic != "" {
            searchResultItems.append(SearchResultItem(title: topic, provider: provider, uri: uri, language: language, mediaType: mediaType))
        }
        
        //Related Topics
        if let results = json!["RelatedTopics"] as? Array<AnyObject> {
            //Topics in RelatedTopics
            for item in results{
                if let topics =  item["Topics"] as? Array<AnyObject>{
                    for topic in topics{
                        let u = topic["FirstURL"] as! String
                        let t = topic["Text"] as! String
                        let p = "duckduckgo"
                        let l = "unknown"
                        let m = "unknown"
                        if u != "" && t != "" {
                            searchResultItems.append(SearchResultItem(title: t, provider: p, uri: u, language: l, mediaType: m))
                        }
                    }
                    break
                }
                
                
                let u = item["FirstURL"] as! String
                let t = item["Text"] as! String
                let p = "duckduckgo"
                let l = "unknown"
                let m = "unknown"
                if u != "" && t != "" {
                    searchResultItems.append(SearchResultItem(title: t, provider: p, uri: u, language: l, mediaType: m))
                }
            }
        }
        if searchResultItems.isEmpty {
            return nil
        }else{
            return SearchResult(index: index, url: url, resultItems: searchResultItems, title: title)

        }
}
}