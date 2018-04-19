//
//  VANDefaultLocation.swift
//
//  Created by David Switzer on 1/25/18
//  Copyright (c) Madison Labs. All rights reserved.
//

import Foundation
import SwiftyJSON

public class VANLocation {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let name = "name"
    static let id = "id"
    static let locationId = "locationId"
    static let address = "address"
    static let displayName = "displayName"
  }

  // MARK: Properties
  public var name: String?
  public var id: Int?
  public var locationId: Int?
  public var address: VANAddress?
  public var displayName: String?

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
    id = json[SerializationKeys.id].int
    locationId = json[SerializationKeys.locationId].int
    address = VANAddress(json: json[SerializationKeys.address])
    displayName = json[SerializationKeys.displayName].string
  }
    
    public init(vanLocationId : Int){
        locationId = vanLocationId
    }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = name { dictionary[SerializationKeys.name] = value }
    if let value = id { dictionary[SerializationKeys.id] = value }
    if let value = locationId { dictionary[SerializationKeys.locationId] = value }
    if let value = address { dictionary[SerializationKeys.address] = value.dictionaryRepresentation() }
    if let value = displayName { dictionary[SerializationKeys.displayName] = value }
    return dictionary
  }

}
