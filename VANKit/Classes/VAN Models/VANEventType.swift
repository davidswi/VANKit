//
//  VANEventType.swift
//
//  Created by David Switzer on 1/25/18
//  Copyright (c) Madison Labs. All rights reserved.
//

import Foundation
import SwiftyJSON

public class VANEventType {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let eventTypeId = "eventTypeId"
    static let defaultLocation = "defaultLocation"
    static let name = "name"
    static let canHaveMultipleLocations = "canHaveMultipleLocations"
    static let canHaveGoals = "canHaveGoals"
    static let canHaveRoleMinimums = "canHaveRoleMinimums"
    static let isSharedWithMasterCommitteeByDefault = "isSharedWithMasterCommitteeByDefault"
    static let isSharedWithChildCommitteesByDefault = "isSharedWithChildCommitteesByDefault"
    static let color = "color"
    static let canHaveMultipleShifts = "canHaveMultipleShifts"
    static let statuses = "statuses"
    static let isAtLeastOneLocationRequired = "isAtLeastOneLocationRequired"
    static let roles = "roles"
    static let canHaveRoleMaximums = "canHaveRoleMaximums"
    static let canBeRepeatable = "canBeRepeatable"
  }

  // MARK: Properties
  public var eventTypeId: Int?
  public var defaultLocation: VANLocation?
  public var name: String?
  public var canHaveMultipleLocations: Bool? = false
  public var canHaveGoals: Bool? = false
  public var canHaveRoleMinimums: Bool? = false
  public var isSharedWithMasterCommitteeByDefault: Bool? = false
  public var isSharedWithChildCommitteesByDefault: Bool? = false
  public var color: String?
  public var canHaveMultipleShifts: Bool? = false
  public var statuses: [VANStatus]?
  public var isAtLeastOneLocationRequired: Bool? = false
  public var roles: [VANRole]?
  public var canHaveRoleMaximums: Bool? = false
  public var canBeRepeatable: Bool? = false

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
    eventTypeId = json[SerializationKeys.eventTypeId].int
    defaultLocation = VANLocation(json: json[SerializationKeys.defaultLocation])
    name = json[SerializationKeys.name].string
    canHaveMultipleLocations = json[SerializationKeys.canHaveMultipleLocations].boolValue
    canHaveGoals = json[SerializationKeys.canHaveGoals].boolValue
    canHaveRoleMinimums = json[SerializationKeys.canHaveRoleMinimums].boolValue
    isSharedWithMasterCommitteeByDefault = json[SerializationKeys.isSharedWithMasterCommitteeByDefault].boolValue
    isSharedWithChildCommitteesByDefault = json[SerializationKeys.isSharedWithChildCommitteesByDefault].boolValue
    color = json[SerializationKeys.color].string
    canHaveMultipleShifts = json[SerializationKeys.canHaveMultipleShifts].boolValue
    if let items = json[SerializationKeys.statuses].array { statuses = items.map { VANStatus(json: $0) } }
    isAtLeastOneLocationRequired = json[SerializationKeys.isAtLeastOneLocationRequired].boolValue
    if let items = json[SerializationKeys.roles].array { roles = items.map { VANRole(json: $0) } }
    canHaveRoleMaximums = json[SerializationKeys.canHaveRoleMaximums].boolValue
    canBeRepeatable = json[SerializationKeys.canBeRepeatable].boolValue
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = eventTypeId { dictionary[SerializationKeys.eventTypeId] = value }
    if let value = defaultLocation { dictionary[SerializationKeys.defaultLocation] = value.dictionaryRepresentation() }
    if let value = name { dictionary[SerializationKeys.name] = value }
    dictionary[SerializationKeys.canHaveMultipleLocations] = canHaveMultipleLocations
    dictionary[SerializationKeys.canHaveGoals] = canHaveGoals
    dictionary[SerializationKeys.canHaveRoleMinimums] = canHaveRoleMinimums
    dictionary[SerializationKeys.isSharedWithMasterCommitteeByDefault] = isSharedWithMasterCommitteeByDefault
    dictionary[SerializationKeys.isSharedWithChildCommitteesByDefault] = isSharedWithChildCommitteesByDefault
    if let value = color { dictionary[SerializationKeys.color] = value }
    dictionary[SerializationKeys.canHaveMultipleShifts] = canHaveMultipleShifts
    if let value = statuses { dictionary[SerializationKeys.statuses] = value.map { $0.dictionaryRepresentation() } }
    dictionary[SerializationKeys.isAtLeastOneLocationRequired] = isAtLeastOneLocationRequired
    if let value = roles { dictionary[SerializationKeys.roles] = value.map { $0.dictionaryRepresentation() } }
    dictionary[SerializationKeys.canHaveRoleMaximums] = canHaveRoleMaximums
    dictionary[SerializationKeys.canBeRepeatable] = canBeRepeatable
    return dictionary
  }

}
