//
//  ConnectionCtrl.swift
//  Browser
//
//  Created by Burak Erol on 10.12.15.
//  Copyright © 2015 SECH-Tag-EEXCESS-Browser. All rights reserved.
//

import Foundation

class FarooConnectionCtrl:URLConnectionCtrlOld{
    
    func sendRequest(searchQuerys: SearchQuerys, queryCompleted: (searchResults: SearchResults) ->()){
        
        var topic: String = ""

        let language = searchQuerys.getLanguage()
        let basicUrl = "http://www.faroo.com/api?q="

        let key = "&key=FQtTu5NKF02wXVyU2viD2SjfJ4Q_"
        let restUrl = "&start=1&length=10&l=\(language)&src=web&f=json\(key)"

        
        var searchResults: [SearchResult] = []
        
        
        let searchQueryArray = searchQuerys.getSearchQuerys()
        
        for searchQuery in searchQueryArray{

          topic += checkSpecialCharakters(searchQuery.getLink().getSearchWord())
            topic += "&q="
            
            topic += checkSpecialCharakters(searchQuery.getSection().getSearchWord())
            
            topic += "&q="
            
            topic += checkSpecialCharakters(searchQuery.getHead().getSearchWord())

            let completeUrl = basicUrl + topic + restUrl
            
            print("URL " + completeUrl)

            let request = NSMutableURLRequest(URL: NSURL(string: completeUrl)!)
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            
            self.post((searchQuerys, NSData()), request: request, postCompleted: { (succeeded, data, searchQuerys) -> () in

                
                let searchRes: SearchResult? = self.parseJson(data, index: searchQuery.getIndex(), url: searchQuery.getUrl(), title: searchQuery.getTitle(), language: language)
                
                if(searchRes != nil){
                    searchResults.append(searchRes!)
                }
                
                
            })
            
            
            topic = ""
            
        }
        
    
        queryCompleted(searchResults: SearchResults(searchResults: searchResults))
    
    }

    
    private func checkSpecialCharakters(var query: String)->String{
        let specialCharacters = [" ", "/", "=", "(", ")", ":", ";"]
        
        
        for specialChar in specialCharacters{
            
            query = query.stringByReplacingOccurrencesOfString(specialChar, withString: "%20")
        }
        
        return query
    }
    
    
    
    

    private func parseJson(data: NSData, index: Int, url: String, title: String, language: String)->SearchResult?{
        
        let provider = "Faroo"
         var searchResultItems: [SearchResultItem] = []
        
        
        let json = try? NSJSONSerialization.JSONObjectWithData(data, options: []) as AnyObject
        
        print("Faroo json" + String(data: data, encoding: NSUTF8StringEncoding)!)
        
        guard let allResults = JSONData.fromObject(json!)!["results"]?.array as [JSONData]! else{
            return nil
        }
        
        if(allResults.count == 0){
            return nil
        }
        
        for(index, allResult) in allResults.enumerate(){
            let title2 = allResult.object!["title"]?.string
            let url = allResult.object!["url"]?.string
            let author = allResult.object!["author"]?.string
            
            searchResultItems.append(SearchResultItem(title: title2!, provider: provider, uri: url!, language: language, mediaType: MediaTypes.unknown.simpleDescription()))
            
        }
        
        return SearchResult(index: index, url: url, resultItems: searchResultItems, title: title)
        
    }

}

class JSONConnectionCtrlOld:ConnectionCtrl {
    
    override func post(params : (SearchQuerys,AnyObject), url : String,
        postCompleted : (succeeded: Bool, data: NSData, searchQuerys:SearchQuerys?) -> ())
    {
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let data =  try! NSJSONSerialization.dataWithJSONObject(params.1, options: [NSJSONWritingOptions()])
        
        self.post((params.0 ,data), request: request, postCompleted: postCompleted)
    }
}

class URLConnectionCtrlOld:ConnectionCtrl {
    
    override func post(params : (SearchQuerys,AnyObject), url : String,
        postCompleted : (succeeded: Bool, data: NSData, searchQuerys:SearchQuerys?) -> ())
    {
        postCompleted(succeeded: false, data: NSData(), searchQuerys: params.0)
    }
    
    func post(data : SearchQuerys, postCompleted : (succeeded: Bool, data: NSData, searchQuerys:SearchQuerys?) -> ())
    {
        postCompleted(succeeded: false, data: NSData(), searchQuerys: data)
    }
    
    func post(data : SearchQuerys , url : String,
        postCompleted : (succeeded: Bool, data: NSData, searchQuerys:SearchQuerys?) -> ())
    {
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        self.post((data,NSData()), request: request, postCompleted: postCompleted)
    }
}

class ConnectionCtrl {

    var searchQuerys:SearchQuerys?
    
    func post(params : (SearchQuerys,AnyObject), url : String,
        postCompleted : (succeeded: Bool, data: NSData, searchQuerys:SearchQuerys?) -> ()){
            postCompleted(succeeded: false,data: "Es wird die abstrakte Klasse ConnectionCtrl".dataUsingEncoding(NSUTF8StringEncoding)!,searchQuerys: nil)
    }
    
     func post(data : (SearchQuerys,NSData), request : NSMutableURLRequest,
        postCompleted : (succeeded: Bool, data: NSData, searchQuerys:SearchQuerys?) -> ())
     {
        print("start")
        self.searchQuerys = data.0
        request.HTTPMethod = "POST"
        request.HTTPBody = data.1
        let session = NSURLSession.sharedSession()
        print("running")
        let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            print("stoped")
            postCompleted(succeeded: error == nil, data: data!,searchQuerys: self.searchQuerys!)
        })
        task.resume()
    }
}

