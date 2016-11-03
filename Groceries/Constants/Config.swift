//
//  Config.swift
//  Groceries
//
//  Created by Roger Yong on 19/03/2016.
//  Copyright © 2016 rycbn. All rights reserved.
//

import UIKit

// API Documentation
// Exchange rate data is refreshed every 60 minutes for Free & Basic Customers, every 10 minutes for the Professional Plan,
// and every 60 seconds for Enterprise Customers.
//

struct Api {
    static let BaseUrl = "http://apilayer.net/api/"
}

struct Methods {
    static let Live = "live"
}

struct ParametersKeys {
    static let AccessKey = "access_key"
}

struct UrlKeys {
    static let UserId = "f7dd82784ae24987a0097ba85af7b113"
}

struct JsonDefault {
    static let Product = NSBundle.mainBundle().pathForResource("products", ofType: "json")
    static let CurrencyExchange = NSBundle.mainBundle().pathForResource("exchangerate", ofType: "json")
}

struct JsonResponseKeys {
    static let Products = "Products"
    static let Id = "id"
    static let Name = "name"
    static let Price = "price"
    static let PriceInfo = "priceInfo"
    static let Success = "success"
    static let Terms = "terms"
    static let Privacy = "privacy"
    static let TimeStamp = "timestamp"
    static let Source = "Source"
    static let Quotes = "quotes"
    static let Error = "error"
    static let Code = "code"
    static let Info = "info"
}

struct JsonErrorKey {
    static let Error = "Error"
}

struct JsonErrorValue {
    static let Error = "Error"
    static let BadRequest = "BadRequest"
    static let Unauthorized = "Unauthorized"
    static let NoData = "NoData"
    static let AuthorizationDenied = "Authorization has been denied for this request."
}