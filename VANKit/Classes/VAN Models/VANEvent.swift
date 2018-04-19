//
//  VANEvent.swift
//
//  Created by David Switzer on 1/25/18
//  Copyright (c) Madison Labs. All rights reserved.
//

import Foundation
import SwiftyJSON

public class VANEvent {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let name = "name"
    static let startDate = "startDate"
    static let createdDate = "createdDate"
    static let descriptionValue = "description"
    static let eventId = "eventId"
    static let districtFieldValue = "districtFieldValue"
    static let locations = "locations"
    static let codes = "codes"
    static let voterRegistrationBatches = "voterRegistrationBatches"
    static let shortName = "shortName"
    static let roles = "roles"
    static let eventType = "eventType"
    static let endDate = "endDate"
    static let isOnlyEditableByCreatingUser = "isOnlyEditableByCreatingUser"
    static let shifts = "shifts"
    static let notes = "notes"
  }

  // MARK: Properties
  public var name: String?
  public var startDate: String?
  public var createdDate: String?
  public var descriptionValue: String?
  public var eventId: Int?
  public var districtFieldValue: String?
  public var locations: [VANLocation]?
  public var codes: [VANCode]?
  public var voterRegistrationBatches: [VANVoterRegistrationBatch]?
  public var shortName: String?
  public var roles: [VANRole]?
  public var eventType: VANEventType?
  public var endDate: String?
  public var isOnlyEditableByCreatingUser: Bool? = false
  public var shifts: [VANShift]?
  public var notes: [VANNote]?

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
    startDate = json[SerializationKeys.startDate].string
    createdDate = json[SerializationKeys.createdDate].string
    descriptionValue = json[SerializationKeys.descriptionValue].string
    eventId = json[SerializationKeys.eventId].int
    districtFieldValue = json[SerializationKeys.districtFieldValue].string
    if let items = json[SerializationKeys.locations].array { locations = items.map { VANLocation(json: $0) } }
    if let items = json[SerializationKeys.codes].array { codes = items.map { VANCode(json: $0) } }
    if let items = json[SerializationKeys.voterRegistrationBatches].array { voterRegistrationBatches = items.map { VANVoterRegistrationBatch(json: $0) } }
    shortName = json[SerializationKeys.shortName].string
    if let items = json[SerializationKeys.roles].array { roles = items.map { VANRole(json: $0) } }
    eventType = VANEventType(json: json[SerializationKeys.eventType])
    endDate = json[SerializationKeys.endDate].string
    isOnlyEditableByCreatingUser = json[SerializationKeys.isOnlyEditableByCreatingUser].boolValue
    if let items = json[SerializationKeys.shifts].array { shifts = items.map { VANShift(json: $0) } }
    if let items = json[SerializationKeys.notes].array { notes = items.map { VANNote(json: $0) } }
  }
    
    public init(vanEventId : Int){
        eventId = vanEventId
    }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = name { dictionary[SerializationKeys.name] = value }
    if let value = startDate { dictionary[SerializationKeys.startDate] = value }
    if let value = createdDate { dictionary[SerializationKeys.createdDate] = value }
    if let value = descriptionValue { dictionary[SerializationKeys.descriptionValue] = value }
    if let value = eventId { dictionary[SerializationKeys.eventId] = value }
    if let value = districtFieldValue { dictionary[SerializationKeys.districtFieldValue] = value }
    if let value = locations { dictionary[SerializationKeys.locations] = value.map { $0.dictionaryRepresentation() } }
    if let value = codes { dictionary[SerializationKeys.codes] = value.map { $0.dictionaryRepresentation() } }
    if let value = voterRegistrationBatches { dictionary[SerializationKeys.voterRegistrationBatches] = value.map { $0.dictionaryRepresentation() } }
    if let value = shortName { dictionary[SerializationKeys.shortName] = value }
    if let value = roles { dictionary[SerializationKeys.roles] = value.map { $0.dictionaryRepresentation() } }
    if let value = eventType { dictionary[SerializationKeys.eventType] = value.dictionaryRepresentation() }
    if let value = endDate { dictionary[SerializationKeys.endDate] = value }
    dictionary[SerializationKeys.isOnlyEditableByCreatingUser] = isOnlyEditableByCreatingUser
    if let value = shifts { dictionary[SerializationKeys.shifts] = value.map { $0.dictionaryRepresentation() } }
    if let value = notes { dictionary[SerializationKeys.notes] = value.map { $0.dictionaryRepresentation() } }
    return dictionary
  }

}
