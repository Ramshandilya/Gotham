//
//  JSONResource.swift
//  Gotham
//
//  Created by Ramsundar Shandilya on 11/10/16.
//  Copyright © 2016 Ramsundar Shandilya. All rights reserved.
//

import Foundation

typealias JSONDictionary = [String: Any]
typealias JSONArray = [JSONDictionary]

enum JSONParsingError: Error {
    case invalidJSONData
    case cannotParseJSONDictionary
    case cannotParseJSONArray
    case unsupportedType
}

protocol JSONResource: Resource {
    func model(fromJSONDictionary jsonDictionary: JSONDictionary) -> Model?
    func model(fromJSONArray jsonArray: JSONArray) -> Model?
}

extension JSONResource {
    func model(fromJSONDictionary jsonDictionary: JSONDictionary) -> Model? {
        return nil
    }
    
    func model(fromJSONArray jsonArray: JSONArray) -> Model? {
        return nil
    }
}

extension JSONResource {
    
    func result(fromData data: Data) -> Result<Model> {
        
        guard let jsonObject = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) else {
            return .Failure(JSONParsingError.invalidJSONData)
        }
        
        if let jsonDictionary = jsonObject as? JSONDictionary {
            return result(fromJSONDictionary: jsonDictionary)
        }
        
        if let jsonArray = jsonObject as? JSONArray {
            return resultFrom(fromJSONArray: jsonArray)
        }
        
        // This is likely an impossible case since `JSONObjectWithData` likely only returns [String: AnyObject] or [AnyObject] but still needed to appease the compiler
        return .Failure(JSONParsingError.unsupportedType)
    }
    
    private func result(fromJSONDictionary jsonDictionary: JSONDictionary) -> Result<Model> {
        if let parsedResults = model(fromJSONDictionary: jsonDictionary) {
            return .Success(parsedResults)
        } else {
            return .Failure(JSONParsingError.cannotParseJSONDictionary)
        }
    }
    
    private func resultFrom(fromJSONArray jsonArray: JSONArray) -> Result<Model> {
        if let parsedResults = model(fromJSONArray: jsonArray) {
            return .Success(parsedResults)
        } else {
            return .Failure(JSONParsingError.cannotParseJSONArray)
        }
    }
}

