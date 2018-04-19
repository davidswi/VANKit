//
//  Roles.swift
//
//  Created by David Switzer on 1/25/18
//  Copyright (c) Madison Labs. All rights reserved.
//

import Foundation
import SwiftyJSON

public class VANRole {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let name = "name"
    static let roleId = "roleId"
    static let isEventLead = "isEventLead"
  }

  // MARK: Properties
  public var name: String?
  public var roleId: Int?
  public var isEventLead: Bool? = false

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
    name = json[SerializationKeys.name].string
    roleId = json[SerializationKeys.roleId].int
    isEventLead = json[SerializationKeys.isEventLead].boolValue
  }
    
    public init(vanRoleId : Int){
        roleId = vanRoleId
    }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = name { dictionary[SerializationKeys.name] = value }
    if let value = roleId { dictionary[SerializationKeys.roleId] = value }
    dictionary[SerializationKeys.isEventLead] = isEventLead
    return dictionary
  }

}
