//
//  VANPhones.swift
//
//  Created by David Switzer on 1/26/18
//  Copyright (c) Madison Labs. All rights reserved.
//

import Foundation
import SwiftyJSON

public class VANPhone {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let phoneOptInStatus = "phoneOptInStatus"
    static let phoneNumber = "phoneNumber"
    static let phoneType = "phoneType"
    static let isPreferred = "isPreferred"
    static let ext = "ext"
  }

  // MARK: Properties
  public var phoneOptInStatus: String?
  public var phoneNumber: String?
  public var phoneType: String?
  public var isPreferred: Bool? = false
  public var ext: Int?

  // MARK: SwiftyJSON Initializers
  /// Initiates the instance based on the object.
  ///
  /// - parameter object: The object of either Dictionary or Array kind that was passed.
  /// - returns: An initialized instance of the class.
  public convenience init(object: Any) {
    self.init(json: JSON(object))
  }

  /// Initiates the instance based on the JSON that was passed.
  ///
  /// - parameter json: JSON object from SwiftyJSON.
  public required init(json: JSON) {
    phoneOptInStatus = json[SerializationKeys.phoneOptInStatus].string
    phoneNumber = json[SerializationKeys.phoneNumber].string
    phoneType = json[SerializationKeys.phoneType].string
    isPreferred = json[SerializationKeys.isPreferred].boolValue
    ext = json[SerializationKeys.ext].int
  }
    
    public init(number : String){
        self.phoneNumber = number
        self.isPreferred = true
    }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = phoneOptInStatus { dictionary[SerializationKeys.phoneOptInStatus] = value }
    if let value = phoneNumber { dictionary[SerializationKeys.phoneNumber] = value }
    if let value = phoneType { dictionary[SerializationKeys.phoneType] = value }
    dictionary[SerializationKeys.isPreferred] = isPreferred
    if let value = ext { dictionary[SerializationKeys.ext] = value }
    return dictionary
  }

}
