//
//  AbstractURLBuilder.swift
//  Browser
//
//  Created by Burak Erol on 10.05.16.
//  Copyright © 2016 SECH-Tag-EEXCESS-Browser. All rights reserved.
//

import Foundation

/*
protocol for all URLBuilder

super -> AbstractBuilder

*/
protocol AbstractURLBuilder:AbstractBuilder {
    func generateURL(query:SearchQuery)->String
}