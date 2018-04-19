//
//  Alamofire+Mock.swift
//  AlamoVANClient
//
//  Created by David Switzer on 2/2/18.
//  Copyright © 2018 MadisonLabs. All rights reserved.
// Adapted from https://stackoverflow.com/questions/26918593/unit-testing-http-traffic-in-alamofire-app

import Foundation
import Alamofire
@testable import VANKit

typealias RequestValidator = (_ request : URLRequest?)->Bool

var liveMode : Bool = true
var mockResponse : HTTPURLResponse?
var mockData : Data?
var mockError : Error?
var validator : RequestValidator?

open class MockURLHandler : URLProtocol{
    
}

extension DataRequest{
    func mockResponseJSON(completionHandler: @escaping (DataResponse<Any>) -> Void)
        -> Self{
        var mockResult : Result<Any>
        if validator != nil && !validator!(self.request){
            mockResult = Result.failure(vanError(code: "BAD_REQUEST", description: "Request failed validation"))
        }
        else{
            if mockError != nil{
                mockResult = Result.failure(mockError!)
            }
            else{
                mockResult = Result.success(mockData)
            }
        }
            
        let response : DataResponse<Any> = DataResponse(request: self.request, response: mockResponse, data: mockData, result: mockResult)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            completionHandler(response)
        }
        
        return self
    }
    
    public func responseJSON(
        queue: DispatchQueue? = nil,
        options: JSONSerialization.ReadingOptions = .allowFragments,
        completionHandler: @escaping (DataResponse<Any>) -> Void)
        -> Self{
        if liveMode{
            return response(
                queue: queue,
                responseSerializer: DataRequest.jsonResponseSerializer(options: options),
                completionHandler: completionHandler
            )
        }
        else{
            return mockResponseJSON(completionHandler: completionHandler)
        }
    }
}
