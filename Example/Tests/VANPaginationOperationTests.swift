//
//  VANPaginationOperationTests.swift
//  VANKit
//
//  Created by David Switzer on 2/2/18.
//  Copyright © 2018 MadisonLabs. All rights reserved.
//

import XCTest
import SwiftyJSON
@testable import VANKit

class VANPaginationOperationTests: XCTestCase {
    var pageOpQueue : OperationQueue?
    var testComplete : Bool?
    
    override func setUp() {
        super.setUp()
        self.pageOpQueue = OperationQueue()
        self.pageOpQueue!.maxConcurrentOperationCount = 1
        self.testComplete = false
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    private func buildExpectedJSON()->Data?{
        let items : Array<Dictionary<String, Any>> = [
            ["title" : "widget1", "id" : 3],
            ["title" : "widget2", "id" : 7],
            ["title" : "widget3", "id" : 8],
            ["title" : "widget1", "id" : 9],
            ["title" : "widget1", "id" : 12]
        ]
        let jsonResponse : Dictionary<String, Any> = ["items" : items, "count" : 5]
        if let jsonStr = JSON(jsonResponse).rawString(){
            let jsonData = jsonStr.data(using: String.Encoding.utf8)
            return jsonData
        }
        return nil
    }
    
    func testPaginatedRequest() {
        let getUrl = "https://api.vantest.com/v1/widget"
        let authToken = "D4C107DA-A9BA-4D3B-A7D9-B00849A03B1C"
        
        let pageCompletion : VANPageCompletion = {[weak self] (items : [JSON]?, remaining : Int, error : Error?) -> Bool in
            XCTAssert(remaining == 0)
            XCTAssertNotNil(items)
            if items != nil{
                XCTAssert(items!.count == 5)
            }
            self?.testComplete = true
            return false
        }
        let paginationOp : VANPaginationOperation = VANPaginationOperation(paginationGetUrl: getUrl, getParams: nil, expandProperties: nil, itemsPerPage: 10, authToken: authToken, completion: pageCompletion)
        self.pageOpQueue?.addOperation(paginationOp)
        while !testComplete!{
            RunLoop.main.run(until: Date(timeIntervalSinceNow: 0.1))
        }
    }
}
