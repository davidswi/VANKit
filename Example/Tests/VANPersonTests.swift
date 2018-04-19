//
//  VANPersonTests.swift
//  VANKit
//
//  Created by David Switzer on 1/26/18.
//  Copyright © 2018 MadisonLabs. All rights reserved.
//

import XCTest
@testable import VANKit

class VANPersonTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testVANPerson(){
        let voter = VANPerson(firstName: "David", lastName: "Switzer")
        voter.phoneNumber = "425-753-2102"
        voter.emailAddress = "davishke@gmail.com"
        voter.zipCode = "98122"
        let voterDict : Dictionary<String, Any>? = voter.dictionaryRepresentation()
        XCTAssertNotNil(voterDict)
        let phones : Array<Dictionary<String, Any>>? = voterDict!["phones"] as? Array<Dictionary<String, Any>>
        XCTAssertNotNil(phones)
        let phoneNumber : String? = phones!.first!["phoneNumber"] as? String
        XCTAssert(phoneNumber == "425-753-2102")
        let emails : Array<Dictionary<String, Any>>? = voterDict!["emails"] as? Array<Dictionary<String, Any>>
        XCTAssertNotNil(emails)
        let emailAddress : String? = emails!.first!["email"] as? String
        XCTAssert(emailAddress == "davishke@gmail.com")
        let addresses : Array<Dictionary<String, Any>>? = voterDict!["addresses"] as? Array<Dictionary<String, Any>>
        XCTAssertNotNil(addresses)
        let zipCode : String? = addresses!.first!["zipOrPostalCode"] as? String
        XCTAssert(zipCode == "98122")
    }
}
