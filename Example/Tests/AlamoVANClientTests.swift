//
//  VANKit.swift
//  VANKit
//
//  Created by David Switzer on 1/18/18.
//  Copyright © 2018 MadisonLabs. All rights reserved.
//

import XCTest
import SwiftyJSON
@testable import VANKit

class VANKitTests: XCTestCase {
    var apiClient : VANAPI? = nil
    var testComplete : Bool = false
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        apiClient = VANAPI(baseURL: "https://api.securevan.com/v4", appName: "YOUR_APP_ID", appUUID: "YOUR_APP_UUID")
        testComplete = false
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testFindVoterInVoterFile() {
        let voter : VANPerson = VANPerson(firstName: "David", lastName: "Switzer")
        voter.phoneNumber = "202-555-1212"
        apiClient?.mode = VANAPIMode.VoterFile
        apiClient?.findVoter(voter: voter, completion: { (vanId : Int?, error : Error?) in
            XCTAssertNotNil(vanId)
            self.testComplete = true
        })
        while !testComplete{
            RunLoop.current.run(until: Date.init(timeIntervalSinceNow: 0.1))
        }
    }
    
    func testFindVoterInMyCampaign() {
        let voter : VANPerson = VANPerson(firstName: "David", lastName: "Switzer")
        voter.emailAddress = "redacted@gmail.com"
        voter.phoneNumber = "202-555-1212"
        voter.zipCode = "89817"
        apiClient?.mode = VANAPIMode.MyCampaign
        apiClient?.findVoter(voter: voter, completion: { (vanId : Int?, error : Error?) in
            XCTAssertNotNil(vanId)
            self.testComplete = true
        })
        while !testComplete{
            RunLoop.current.run(until: Date.init(timeIntervalSinceNow: 0.1))
        }
    }
    
    func testFindVoterByVanId() {
        apiClient?.mode = VANAPIMode.MyCampaign
        apiClient?.getVoterById(vanId : 104237626, completion: { (voter : VANPerson?, error : Error?) in
            XCTAssertNotNil(voter)
            self.testComplete = true
        })
        while !testComplete{
            RunLoop.current.run(until: Date.init(timeIntervalSinceNow: 0.1))
        }
    }
    
    func expectedResponseForVoterUpdate()->Data?{
        let responseString : String = "{\"vanId\" : 123456, \"status\" : \"unmatchedStored\"}"
        let jsonData = responseString.data(using: String.Encoding.utf8)
        return jsonData
    }
    
    func testUpdateVoter(){
        apiClient?.mode = VANAPIMode.MyCampaign
        let voter : VANPerson = VANPerson(firstName: "Bugs", lastName: "Bunny")
        voter.phoneNumber = "112-555-9432"
        voter.emailAddress = "b.bunny@looneytunes.com"
        voter.zipCode = "10015"
    
        apiClient?.findOrCreateVoter(voter: voter, completion: { (vanId : Int?, error : Error?) in
            XCTAssertNotNil(vanId)
            XCTAssert(vanId == 123456)
            self.testComplete = true
        })
        while !testComplete{
            RunLoop.current.run(until: Date.init(timeIntervalSinceNow: 0.1))
        }
    }
    
    func testGetEvents(){
        apiClient?.mode = VANAPIMode.MyCampaign
        let filter : VANEventFilter = VANEventFilter()
        // Set start filter to January 1, 2017 12:00 AM PST
        filter.startDate = Date(timeIntervalSince1970: 1483257600)
        // Set end filter to December 31, 2017 11:59 PM PST
        filter.endDate = Date(timeIntervalSince1970: 1514793599)
        
        apiClient?.getEvents(filter: filter, completion: {[weak self] (events : Array<VANEvent>?, error : Error?) in
            XCTAssertNotNil(events)
            if events != nil{
                XCTAssert(events!.count > 0)
            }
            self?.testComplete = true
        })
        while !testComplete{
            RunLoop.current.run(until: Date.init(timeIntervalSinceNow: 0.1))
        }
    }
    
    func testGetSignups(){
        apiClient?.mode = VANAPIMode.MyCampaign
        apiClient?.getSignUps(eventId: nil, vanId: 104237626, completion: {[weak self] (signups: Array<VANEventSignUp>?, error : Error?) in
            XCTAssertNotNil(signups)
            if signups != nil{
                XCTAssert(signups!.count > 0)
            }
            self?.testComplete = true
        })
        while !testComplete{
            RunLoop.current.run(until: Date.init(timeIntervalSinceNow: 0.1))
        }
    }
    
    func expectedResponseForSignup()->Data?{
        let signup : String = "{\"eventSignupId\": 1957}"
        let jsonData = signup.data(using: String.Encoding.utf8)
        return jsonData
    }
    
    func testSignupVolunteer(){
        apiClient?.mode = VANAPIMode.MyCampaign
        let signup = VANEventSignUp(vanId: 123456, eventId: 1897, eventShiftId: 3, roleId: 4, statusId: 2, locationId: 1089)
        apiClient?.signupVolunteerForEvent(signup: signup, completion: {[weak self] (signupId : Int?, error : Error?) in
            XCTAssertNotNil(signupId)
            XCTAssert(signupId! == 1957)
            self?.testComplete = true
        })
        
        while !testComplete{
            RunLoop.current.run(until: Date.init(timeIntervalSinceNow: 0.1))
        }
    }
    
    func testUpdateSignup(){
        apiClient?.mode = VANAPIMode.MyCampaign
        let signup = VANEventSignUp(vanId: 123456, eventId: 1897, eventShiftId: 3, roleId: 4, statusId: 3, locationId: 1089)
        signup.eventSignupId = 1957
        apiClient?.updateVolunteerSignup(signup: signup, completion: {[weak self] (error : Error?) in
            XCTAssertNil(error)
            self?.testComplete = true
        })
        
        while !testComplete{
            RunLoop.current.run(until: Date.init(timeIntervalSinceNow: 0.1))
        }
    }
    
    func testDeleteSignup(){
        apiClient?.mode = VANAPIMode.MyCampaign
        apiClient?.deleteVolunteerSignup(eventSignupId: 1957, completion: { (error : Error?) in
            XCTAssertNil(error)
        })
    }
}
