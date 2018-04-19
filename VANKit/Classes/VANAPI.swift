//
//  VANAPI.swift
//  AlamoVANClient
//
//  Created by David Switzer on 1/18/18.
//  Copyright © 2018 MadisonLabs. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

enum VANAPIMode : Int{
    case VoterFile = 0
    case MyCampaign = 1
}

class VANAPI {
    var paginationQueue : OperationQueue
    var mode : VANAPIMode
    var vanAppName : String
    var vanUUID : String
    var vanBaseURL : String
    var vanPassword : String{
        return "\(vanUUID)|\(mode.rawValue)"
    }
    var authorizationHeader : String{
        let password : String = "\(vanUUID)|\(mode.rawValue)";
        let base64EncodedToken : String = "\(vanAppName):\(password)".data(using: String.Encoding.utf8)!.base64EncodedString()
        return "Basic \(base64EncodedToken)"
    }
    
    init(baseURL : String, appName : String, appUUID : String){
        paginationQueue = OperationQueue()
        paginationQueue.maxConcurrentOperationCount = 1
        paginationQueue.name = "com.pramilaforcongress.pageOpQ"
        vanBaseURL = baseURL
        vanAppName = appName
        vanUUID = appUUID
        mode = .VoterFile
    }
    
    private func isVANError(response : JSON)->vanError?{
        var apiError : vanError? = nil
        let errors = response["errors"].arrayValue
        if errors.count > 0{
            if let error = errors.first{
                apiError = vanError(errorJSON: error)
            }
        }
        
        return apiError
    }
    
    private func postFindRequest(voter : VANPerson, postUrl : String, completion: @escaping(_ vanId : Int?, _ error : Error?)->Void){
        let headersSet: HTTPHeaders = [
            "Authorization": authorizationHeader,
            "Accept": "application/json"
        ]
        let voterDict = voter.dictionaryRepresentation()
        let findUrl = vanBaseURL + postUrl
        let sessionDelegate = SessionManager.default.delegate
        sessionDelegate.taskWillPerformHTTPRedirectionWithCompletion = {
            (session: URLSession, task: URLSessionTask, response: HTTPURLResponse,
            newRequest: URLRequest, completionHandler: (URLRequest?) -> Void) in
            completionHandler(nil)
        }
        
        Alamofire.request(findUrl, method:.post, parameters:voterDict, encoding: JSONEncoding.default, headers: headersSet).responseJSON {
            [weak self] (response:DataResponse<Any>) in
            if let data = response.result.value{
                let json = JSON(data)
                switch(response.result) {
                case .success(_):
                    let vanId = json["vanId"].intValue
                    completion(vanId, nil)
                    break
                case .failure(_):
                    if let vanError = self?.isVANError(response: json){
                        completion(nil, vanError)
                    }
                    else{
                        completion(nil, response.result.error)
                    }
                    break
                }
            }
            else{
                completion(nil, vanError(code: "NO_DATA", description: "The response was empty"))
            }
        }
    }
    
    func findVoter(voter : VANPerson, completion: @escaping(_ vanId : Int?, _ error : Error?)->Void){
        postFindRequest(voter: voter, postUrl: "/people/find", completion: completion)
    }
    
    func findOrCreateVoter(voter : VANPerson, completion: @escaping(_ vanId : Int?, _ error : Error?)->Void){
        postFindRequest(voter: voter, postUrl: "/people/findOrCreate", completion: completion)
    }
    
    func getVoterById(vanId : Int, completion: @escaping(_ voter : VANPerson?, _ error : Error?)->Void){
        let headersSet: HTTPHeaders = [
            "Authorization": authorizationHeader,
            "Accept": "application/json"
        ]
        
        let voterUrl : String = "/people/\(vanId)"
        let params : [String : Any] = ["$expand" : ["phones", "emails", "addresses"]]
        let getUrl : String = vanBaseURL + voterUrl
        
        Alamofire.request(getUrl, method: .get, parameters: params, encoding: URLEncoding.default, headers: headersSet).responseJSON {
            [weak self] (response:DataResponse<Any>) in
            if let data = response.result.value{
                let json = JSON(data)
                switch(response.result) {
                case .success(_):
                    let voter = VANPerson(json: json)
                    completion(voter, nil)
                    break
                case .failure(_):
                    if let vanError = self?.isVANError(response: json){
                        completion(nil, vanError)
                    }
                    else{
                        completion(nil, response.result.error)
                    }
                    break
                }
            }
            else{
                completion(nil, vanError(code: "NO_DATA", description: "The response was empty"))
            }
        }
    }
    
    func getDistrictFields(fetchCustomOnly : Bool, fetchOrganizingOnly : Bool, completion: @escaping(_ districtFields : VANDistrictFields?, _ error : Error?)->Void){
        let headersSet: HTTPHeaders = [
            "Authorization": authorizationHeader,
            "Accept": "application/json"
        ]
        
        let districtFieldsUrl : String = "/districtFields"
        let params : [String : Any] = ["custom" : fetchCustomOnly, "organizeAt" : fetchOrganizingOnly]
        let getUrl = vanBaseURL + districtFieldsUrl
        
        Alamofire.request(getUrl, method: .get, parameters: params, encoding: URLEncoding.default, headers: headersSet).responseJSON {
            [weak self] (response:DataResponse<Any>) in
            if let data = response.result.value{
                let json = JSON(data)
                switch(response.result) {
                case .success(_):
                    let districts = VANDistrictFields(json: json)
                    completion(districts, nil)
                    break
                case .failure(_):
                    if let vanError = self?.isVANError(response: json){
                        completion(nil, vanError)
                    }
                    else{
                         completion(nil, response.result.error)
                    }
                    break
                }
            }
            else{
                completion(nil, vanError(code: "NO_DATA", description: "The response was empty"))
            }
        }
    }
    
    func getEvents(filter : VANEventFilter?, completion: @escaping(_ events: Array<VANEvent>?, _ error: Error?)->Void){
        let eventsUrl : String = "/events"
        let getUrl = vanBaseURL + eventsUrl
        let eventParams : [String : Any]? = filter?.params()
        let getEventsOp = VANPaginationOperation(paginationGetUrl: getUrl, getParams: eventParams, expandProperties: ["locations", "shifts", "roles"], itemsPerPage: 10, authToken: authorizationHeader) { (items : [JSON]?, remaining : Int, error : Error?) -> Bool in
            if error != nil{
                completion(nil, error)
                return false
            }
            else{
                if items != nil{
                    var returnedEvents : [VANEvent] = Array<VANEvent>()
                    for item in items!{
                        returnedEvents.append(VANEvent(json: item))
                    }
                    completion(returnedEvents, nil)
                }
            }
            
            return remaining > 0
        }
        paginationQueue.addOperation(getEventsOp)
    }
    
    func getStatuses(eventType : Int?, eventId : Int?, completion: @escaping(_ statuses : Array<VANStatus>?, _ error: Error?)->Void){
        let statusesUrl = "/signups/statuses"
        let getUrl = vanBaseURL + statusesUrl
        let headersSet: HTTPHeaders = [
            "Authorization": authorizationHeader,
            "Accept": "application/json"
        ]
        
        var filter : Dictionary<String, Any> = [ : ]
        if eventType != nil{
            filter["eventType"] = eventType!
        }
        
        if eventId != nil{
            filter["eventId"] = eventId!
        }
        
        Alamofire.request(getUrl, method: .get, parameters: filter, encoding: URLEncoding.default, headers: headersSet).responseJSON {
            [weak self] (response:DataResponse<Any>) in
            if let data = response.result.value{
                let json = JSON(data)
                switch(response.result) {
                case .success(_):
                    var statuses : Array<VANStatus> = Array<VANStatus>()
                    for statusJSON in json.arrayValue{
                        statuses.append(VANStatus(json: statusJSON))
                    }
                    completion(statuses, nil)
                    break
                case .failure(_):
                    if let vanError = self?.isVANError(response: json){
                        completion(nil, vanError)
                    }
                    else{
                        completion(nil, response.result.error)
                    }
                    break
                }
            }
            else{
                completion(nil, vanError(code: "NO_DATA", description: "The response was empty"))
            }
        }
    }
    
    func getSignUps(eventId : Int?, vanId : Int?, completion: @escaping(_ events: Array<VANEventSignUp>?, _ error: Error?)->Void){
        let signupsUrl : String = "/signups"
        let getUrl = vanBaseURL + signupsUrl
        var signupFilter : [String : Any] = [:]
        if eventId != nil{
            signupFilter["eventId"] = eventId!
        }
        
        if vanId != nil{
            signupFilter["vanId"] = vanId!
        }
        
        let getSignupsOp : VANPaginationOperation = VANPaginationOperation(paginationGetUrl: getUrl, getParams: signupFilter, expandProperties: nil, itemsPerPage: 10, authToken: authorizationHeader) { (items : [JSON]?, remaining : Int, error : Error?) -> Bool in
            if error != nil{
                completion(nil, error)
                return false
            }
            else{
                if items != nil{
                    var returnedSignUps : [VANEventSignUp] = Array<VANEventSignUp>()
                    for item in items!{
                        returnedSignUps.append(VANEventSignUp(json: item))
                    }
                    completion(returnedSignUps, nil)
                }
            }
            
            return remaining > 0
        }
        paginationQueue.addOperation(getSignupsOp)
    }
    
    func signupVolunteerForEvent(signup : VANEventSignUp, completion: @escaping (_ eventSignupId : Int?, _ error : Error?)->Void){
        let signupsUrl : String = "/signups"
        let postUrl = vanBaseURL + signupsUrl
        let headersSet: HTTPHeaders = [
            "Authorization": authorizationHeader,
            "Accept": "application/json"
        ]
        let signupDict = signup.dictionaryRepresentation()
        Alamofire.request(postUrl, method:.post, parameters:signupDict, encoding: JSONEncoding.default, headers: headersSet).responseJSON {
            [weak self] (response:DataResponse<Any>) in
            if let data = response.result.value{
                let json = JSON(data)
                switch(response.result) {
                case .success(_):
                    let signupId = json["eventSignupId"].intValue
                    completion(signupId, nil)
                    break
                case .failure(_):
                    if let vanError = self?.isVANError(response: json){
                        completion(nil, vanError)
                    }
                    else{
                        completion(nil, response.result.error)
                    }
                    break
                }
            }
            else{
                completion(nil, vanError(code: "NO_DATA", description: "The response was empty"))
            }
        }
    }
    
    func updateVolunteerSignup(signup : VANEventSignUp, completion: @escaping (_ error : Error?)->Void){
        if signup.eventSignupId == nil{
            completion(vanError(code: "NO_ID", description: "The event signup Id is nil"))
        }
        
        let signupId : Int = signup.eventSignupId!
        let signupUrl : String = "/signups/\(signupId)"
        let putUrl = vanBaseURL + signupUrl
        let headersSet: HTTPHeaders = [
            "Authorization": authorizationHeader,
            "Accept": "application/json"
        ]
        let signupDict = signup.dictionaryRepresentation()
        Alamofire.request(putUrl, method: .put, parameters: signupDict, encoding: JSONEncoding.default, headers: headersSet).responseJSON {
            [weak self] (response:DataResponse<Any>) in
            switch(response.result) {
            case .success(_):
                completion(nil)
                break
            case .failure(_):
                if let data = response.result.value{
                    let json = JSON(data)
                    if let vanError = self?.isVANError(response: json){
                        completion(vanError)
                    }
                }
                else{
                    completion(response.result.error)
                }
                break
            }
        }
    }
    
    func deleteVolunteerSignup(eventSignupId : Int, completion: @escaping(_ error : Error?)->Void){
        let signupUrl : String = "/signups/\(eventSignupId)"
        let deleteUrl = vanBaseURL + signupUrl
        let headersSet: HTTPHeaders = [
            "Authorization": authorizationHeader,
            "Accept": "application/json"
        ]

        Alamofire.request(deleteUrl, method: .delete, parameters: nil, encoding: JSONEncoding.default, headers: headersSet).responseJSON {
            [weak self] (response:DataResponse<Any>) in
            switch(response.result) {
            case .success(_):
                completion(nil)
                break
            case .failure(_):
                if let data = response.result.value{
                    let json = JSON(data)
                    if let vanError = self?.isVANError(response: json){
                        completion(vanError)
                    }
                }
                else{
                    completion(response.result.error)
                }
                break
            }
        }
    }
}
