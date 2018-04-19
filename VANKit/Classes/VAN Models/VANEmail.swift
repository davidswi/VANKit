//
//  VANEmails.swift
//
//  Created by David Switzer on 1/26/18
//  Copyright (c) Madison Labs. All rights reserved.
//

import Foundation
import SwiftyJSON

public class VANEmail {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let email = "email"
    static let type = "type"
    static let isSubscribed = "isSubscribed"
    static let isPreferred = "isPreferred"
  }

  // MARK: Properties
  public var email: String?
  public var type: String?
  public var isSubscribed: Bool? = false
  public var isPreferred: Bool? = false

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
    email = json[SerializationKeys.email].string
    type = json[SerializationKeys.type].string
    isSubscribed = json[SerializationKeys.isSubscribed].boolValue
    isPreferred = json[SerializationKeys.isPreferred].boolValue
  }
    
    public init(address: String){
        self.email = address
    }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = email { dictionary[SerializationKeys.email] = value }
    if let value = type { dictionary[SerializationKeys.type] = value }
    dictionary[SerializationKeys.isSubscribed] = isSubscribed
    dictionary[SerializationKeys.isPreferred] = isPreferred
    return dictionary
  }

}
