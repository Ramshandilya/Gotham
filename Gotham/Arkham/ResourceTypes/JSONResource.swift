//
//  JSONResource.swift
//  Gotham
//
//  Created by Ramsundar Shandilya on 11/10/16.
//  Copyright © 2016 Ramsundar Shandilya. All rights reserved.
//

import Foundation

public typealias JSONDictionary = [String: Any]
public typealias JSONArray = [JSONDictionary]

public enum JSONParsingError: Error {
    case invalidJSONData
    case cannotParseJSONDictionary
    case cannotParseJSONArray
    case unsupportedType
    case notAJSONDictionary
    case notAJSONArray
}

//MARK:- JSONDictionaryResource
/**
 *  Defines a generic JSON Resource type. NOT to be used directly. Use either `JSONDictionaryResource` or `JSONArrayResource`
 */
public protocol JSONResource: DataResource {
    
    //TODO: May not be the right place to have this variable. Revisit.
    var request: NetworkRequestable { get }
}

//MARK:- JSONDictionaryResource
/**
 *  Defines a specific Resource type used for JSON dictionary (i.e.[String : Any]) resources
 */
public protocol JSONDictionaryResource: JSONResource {
    
    func model(fromJSONDictionary jsonDictionary: JSONDictionary) -> Model?
}

public extension JSONDictionaryResource {
    
    func result(fromData data: Data) -> Result<Model> {
        
        guard let jsonObject = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) else {
            return .failure(JSONParsingError.invalidJSONData)
        }
        
        guard let jsonDictionary = jsonObject as? JSONDictionary else {
            return .failure(JSONParsingError.notAJSONDictionary)
        }
        
        guard let parsedResults = model(fromJSONDictionary: jsonDictionary) else {
            return .failure(JSONParsingError.cannotParseJSONDictionary)
        }
        
        return .success(parsedResults)
    }
}


//MARK:- JSONArrayResource
/**
 *  Defines a specific ResourceType used for JSON array (i.e.[Any]) resources
 */
public protocol JSONArrayResource: JSONResource {
    
    func model(fromJSONArray jsonArray: JSONArray) -> Model?
}

public extension JSONArrayResource {
    
    func result(fromData data: Data) -> Result<Model> {
        
        guard let jsonObject = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) else {
            return .failure(JSONParsingError.invalidJSONData)
        }
        
        guard let jsonArray = jsonObject as? JSONArray else {
            return .failure(JSONParsingError.notAJSONArray)
        }
        
        guard let parsedResults = model(fromJSONArray: jsonArray) else {
            return .failure(JSONParsingError.cannotParseJSONArray)
        }
        
        return .success(parsedResults)
    }
}
