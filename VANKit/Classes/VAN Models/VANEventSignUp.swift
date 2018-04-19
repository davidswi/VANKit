//
//  VANEventSignUp.swift
//
//  Created by David Switzer on 2/4/18
//  Copyright (c) Madison Labs. All rights reserved.
//

import Foundation
import SwiftyJSON

public class VANEventSignUp {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let status = "status"
    static let location = "location"
    static let eventSignupId = "eventSignupId"
    static let startTimeOverride = "startTimeOverride"
    static let endTimeOverride = "endTimeOverride"
    static let person = "person"
    static let printedLists = "printedLists"
    static let event = "event"
    static let minivanExports = "minivanExports"
    static let shift = "shift"
    static let role = "role"
  }

  // MARK: Properties
  public var status: VANStatus?
  public var location: VANLocation?
  public var eventSignupId: Int?
  public var startTimeOverride: String?
  public var endTimeOverride: String?
  public var person: VANPerson?
  public var printedLists: [VANPrintedLists]?
  public var event: VANEvent?
  public var minivanExports: [VANMinivanExports]?
  public var shift: VANShift?
  public var role: VANRole?

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
    status = VANStatus(json: json[SerializationKeys.status])
    location = VANLocation(json: json[SerializationKeys.location])
    eventSignupId = json[SerializationKeys.eventSignupId].int
    startTimeOverride = json[SerializationKeys.startTimeOverride].string
    endTimeOverride = json[SerializationKeys.endTimeOverride].string
    person = VANPerson(json: json[SerializationKeys.person])
    if let items = json[SerializationKeys.printedLists].array { printedLists = items.map { VANPrintedLists(json: $0) } }
    event = VANEvent(json: json[SerializationKeys.event])
    if let items = json[SerializationKeys.minivanExports].array { minivanExports = items.map { VANMinivanExports(json: $0) } }
    shift = VANShift(json: json[SerializationKeys.shift])
    role = VANRole(json: json[SerializationKeys.role])
  }
    
    public init(vanId : Int, eventId : Int, eventShiftId : Int, roleId : Int, statusId : Int, locationId : Int){
        person = VANPerson(vanId: vanId)
        event = VANEvent(vanEventId: eventId)
        shift = VANShift(shiftId: eventShiftId)
        role = VANRole(vanRoleId: roleId)
        status = VANStatus(vanStatusId: statusId)
        location = VANLocation(vanLocationId: locationId)
    }
    
  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = status { dictionary[SerializationKeys.status] = value.dictionaryRepresentation() }
    if let value = location { dictionary[SerializationKeys.location] = value.dictionaryRepresentation() }
    if let value = eventSignupId { dictionary[SerializationKeys.eventSignupId] = value }
    if let value = startTimeOverride { dictionary[SerializationKeys.startTimeOverride] = value }
    if let value = endTimeOverride { dictionary[SerializationKeys.endTimeOverride] = value }
    if let value = person { dictionary[SerializationKeys.person] = value.dictionaryRepresentation() }
    if let value = printedLists { dictionary[SerializationKeys.printedLists] = value.map { $0.dictionaryRepresentation() } }
    if let value = event { dictionary[SerializationKeys.event] = value.dictionaryRepresentation() }
    if let value = minivanExports { dictionary[SerializationKeys.minivanExports] = value.map { $0.dictionaryRepresentation() } }
    if let value = shift { dictionary[SerializationKeys.shift] = value.dictionaryRepresentation() }
    if let value = role { dictionary[SerializationKeys.role] = value.dictionaryRepresentation() }
    return dictionary
  }

}
