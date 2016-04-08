//
//  TaskConvenience.swift
//  Groceries
//
//  Created by Roger Yong on 19/03/2016.
//  Copyright © 2016 rycbn. All rights reserved.
//

import Foundation

extension TaskConfig {
    func getLiveCurrency(completionHandler: (results: [String: AnyObject]?, error: NSError?) -> Void) {

        let parameters = [ParametersKeys.AccessKey: UrlKeys.UserId]
        let mutableMethod: String = Methods.Live
        
        taskForGETMethod(mutableMethod, parameters: parameters) { (JSONResult, error) in
            if let error = error {
                completionHandler(results: nil, error: error)
            }
            else {
                if let result = JSONResult as? [String: AnyObject] {
                    completionHandler(results: result, error: nil)
                }
                else {
                    completionHandler(results: nil, error: NSError(domain: "\(#function) parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse \(#function)"]))
                }
            }
        }
    }
}