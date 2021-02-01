//
//  Networking.swift
//  WorldNewsTestAppForPecode
//
//  Created by Anton on 30.01.2021.
//

import Foundation

class Networking {
    
    func perform(request: URLRequest, completionHandler: @escaping ((Data?) -> Void)){
        let task = URLSession.shared.dataTask(with: request) {
            (data, response, error) in completionHandler(data)
        }
        
        task.resume()
    }
    
}
