//
//  VANPaginationOperation.swift
//  AlamoVANClient
//
//  Created by David Switzer on 1/30/18.
//  Copyright © 2018 MadisonLabs. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

typealias VANPageCompletion = (_ items : [JSON]?, _ remaining : Int, _ error : Error?)->Bool

class VANPaginationOperation : Operation{
    var getUrl : String
    var getParams : [String : Any]?
    var offset : Int
    var total : Int
    var itemsPerPage : Int
    var authToken : String
    var pageCompletion : VANPageCompletion
    
    init(paginationGetUrl : String, getParams : [String : Any]?, expandProperties : [String]?, itemsPerPage : Int, authToken : String, completion : @escaping VANPageCompletion){
        self.getUrl = paginationGetUrl
        self.offset = 0
        self.total = 0
        self.itemsPerPage = itemsPerPage
        self.authToken = authToken
        self.pageCompletion = completion
        super.init()
        self.getParams = setupPaginationParams(queryParameters: getParams, expandProperties: expandProperties)
    }

    private func setupPaginationParams(queryParameters : [String : Any]?, expandProperties : [String]?)->[String : Any]{
        var params : [String : Any] = ["$top" : self.itemsPerPage,
                                       "$skip" : 0,
                                       "$expand" : ""]
        if expandProperties != nil{
            var expandString : String = ""
            for (index, expandProperty) in expandProperties!.enumerated(){
                expandString.append(expandProperty)
                if index != expandProperties!.count - 1{
                    expandString.append(",")
                }
            }
            params["$expand"] = expandString
        }
        
        if queryParameters != nil{
            params.merge(queryParameters!) { (current, _) -> Any in
                current
            }
        }
        
        return params
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
    
    private func getNextPage(){
        let headersSet: HTTPHeaders = [
            "Authorization": authToken,
            "Accept": "application/json"
        ]
        getParams!["$skip"] = offset
        
        Alamofire.request(getUrl, method: .get, parameters: getParams, encoding: URLEncoding.default, headers: headersSet).responseJSON {
            (response:DataResponse<Any>) in
            if let data = response.result.value{
                let json = JSON(data)
                switch(response.result) {
                case .success(_):
                    let items : [JSON]? = json["items"].array
                    if items != nil{
                        if self.total == 0{
                            self.total = json["count"].intValue
                        }
                        let newOffset = self.offset + items!.count
                        let remaining = self.total - newOffset
                        if self.pageCompletion(items, remaining, nil) && remaining > 0{
                            self.offset = newOffset
                            self.getNextPage()
                        }
                    }
                    break
                case .failure(_):
                    if let vanError = self.isVANError(response: json){
                        self.pageCompletion(nil, 0, vanError)
                    }
                    else{
                        self.pageCompletion(nil, 0, response.result.error)
                    }
                    break
                }
            }
            else{
                self.pageCompletion(nil, 0, vanError(code: "NO_DATA", description: "The response was empty"))
            }
        }
    }
    
    override func main() {
        self.getNextPage()
    }
}
