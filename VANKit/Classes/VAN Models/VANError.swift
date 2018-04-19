//
//  VANError.swift
//  AlamoVANClient
//
//  Created by David Switzer on 1/22/18.
//  Copyright © 2018 MadisonLabs. All rights reserved.
//

import Foundation
import SwiftyJSON

struct vanError : LocalizedError{
    var vanCode : String
    var vanText : String
    var vanProperties : [String]?
    var vanReferenceCode : String?
    var vanReferenceURL : String?
    var vanHint : String?
    
    var failureReason: String?{
        return self.vanText
    }
    
    var errorDescription: String?{
        get{
            return self.vanCode
        }
    }
    
    var recoverySuggestion: String?{
        get{
            return self.vanHint
        }
    }
    
    var helpAnchor: String?{
        get{
            return self.vanReferenceURL
        }
    }
    
    init(errorJSON : JSON){
        self.vanCode = errorJSON["code"].stringValue
        self.vanText = errorJSON["text"].stringValue
        if let props = errorJSON["properties"].array{
            self.vanProperties = Array<String>()
            for prop in props{
                self.vanProperties?.append(prop.stringValue)
            }
        }
        self.vanReferenceCode = errorJSON["referenceCode"].string
        self.vanReferenceURL = errorJSON["resourceUrl"].string
        self.vanHint = errorJSON["hint"].string
    }
    
    init(code : String, description : String){
        self.vanCode = code
        self.vanText = description
    }
}
