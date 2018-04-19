//
//  VoterInfo.swift
//  AlamoVANClient
//
//  Created by David Switzer on 1/18/18.
//  Copyright © 2018 MadisonLabs. All rights reserved.
//

import Foundation
import SwiftyJSON

class VoterInfo{
    var vanId : String?
    var firstName : String!
    var lastName : String!
    var emailAddresses : [EmailAddress]?
    var phoneNumbers : [PhoneNumber]?
    var mailingAddresses : [MailingAddress]?
    var zipCode : String?{
        get{
            if mailingAddresses != nil{
                if mailingAddresses!.count == 1{
                    return mailingAddresses!.first?.zipCode
                }
                else{
                    if let zip : String = mailingAddresses!.first(where: {$0.isPreferred})?.zipCode{
                        return zip
                    }
                    else{
                        return mailingAddresses!.first?.zipCode
                    }
                }
            }
            else{
                return nil
            }
        }
    }
    
    init(firstName : String, lastName : String){
        self.firstName = firstName
        self.lastName = lastName
    }
    
    init(voterJSON : JSON) {
        self.vanId = voterJSON["vanId"].string
        self.firstName = voterJSON["firstName"].stringValue
        self.lastName = voterJSON["lastName"].stringValue
        if let phoneNumbers = voterJSON["phones"].array{
            self.phoneNumbers = Array<PhoneNumber>()
            for phoneNumber in phoneNumbers{
                self.phoneNumbers?.append(PhoneNumber(phoneJSON: phoneNumber))
            }
        }
        
        if let emailAddresses = voterJSON["emails"].array{
            self.emailAddresses = Array<EmailAddress>()
            for email in emailAddresses{
                self.emailAddresses?.append(EmailAddress(emailJSON: email))
            }
        }
    }
    
    func defaultPhoneNumber()->String?{
        if self.phoneNumbers != nil{
            if self.phoneNumbers!.count == 1{
                return self.phoneNumbers?.first?.number
            }
            else{
                return self.phoneNumbers?.first(where: {$0.isPreferred})?.number
            }
        }
        else{
            return nil
        }
    }
    
    func defaultEmailAddress()->String?{
        if self.emailAddresses != nil{
            if self.emailAddresses!.count == 1{
                return self.emailAddresses?.first?.address
            }
            else{
                return self.emailAddresses?.first(where: {$0.isPreferred})?.address
            }
        }
        else{
            return nil
        }
    }
    
    func toDict()->Dictionary<String, Any>{
        var jsonDict : Dictionary<String, Any> = ["firstName" : firstName, "lastName" : lastName];
        
        if vanId != nil{
            jsonDict["vanId"] = vanId;
        }
        
        if let emailAddress = defaultEmailAddress(){
            jsonDict["emails"] = [["email" : emailAddress]]
        }
        
        if let phoneNumber = defaultPhoneNumber(){
            jsonDict["phones"] = [["phoneNumber" : phoneNumber]]
        }
        
        if zipCode != nil{
            jsonDict["addresses"] = [["zipOrPostalCode" : zipCode!]]
        }
        
        return jsonDict
    }
    
    func toJSON()->JSON{
        return JSON(toDict());
    }
}
