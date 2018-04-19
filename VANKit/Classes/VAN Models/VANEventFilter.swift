//
//  VANEventFilter.swift
//  AlamoVANClient
//
//  Created by David Switzer on 1/28/18.
//  Copyright © 2018 MadisonLabs. All rights reserved.
//

import Foundation

class VANEventFilter{
    var startDate : Date?
    var endDate : Date?
    var districtFieldId : Int?
    
    func params()->[String : Any]{
        var paramDict = Dictionary<String, Any>()
        
        let df : DateFormatter = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        
        if startDate != nil{
            paramDict["startingAfter"] = df.string(from: startDate!)
        }
        
        if endDate != nil{
            paramDict["startingBefore"] = df.string(from: endDate!)
        }
        
        if districtFieldId != nil{
            paramDict["districtFieldValue"] = districtFieldId
        }
        
        return paramDict
    }
}
