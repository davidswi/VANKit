//
//  Address.swift
//
//  Created by David Switzer on 1/25/18
//  Copyright (c) Madison Labs. All rights reserved.
//

import Foundation
import SwiftyJSON

public class VANAddress {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let stateOrProvince = "stateOrProvince"
    static let city = "city"
    static let geoLocation = "geoLocation"
    static let preview = "preview"
    static let countryCode = "countryCode"
    static let addressLine1 = "addressLine1"
    static let addressLine2 = "addressLine2"
    static let addressLine3 = "addressLine3"
    static let addressId = "addressId"
    static let zipOrPostalCode = "zipOrPostalCode"
    static let isPreferred = "isPreferred"
  }

  // MARK: Properties
  public var stateOrProvince: String?
  public var city: String?
  public var geoLocation: VANGeoLocation?
  public var preview: String?
  public var countryCode: String?
  public var addressLine1: String?
  public var addressLine2: String?
  public var addressLine3: String?
  public var addressId : Int?
  public var zipOrPostalCode: String?
  public var isPreferred : Bool?
    
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
    stateOrProvince = json[SerializationKeys.stateOrProvince].string
    city = json[SerializationKeys.city].string
    geoLocation = VANGeoLocation(json: json[SerializationKeys.geoLocation])
    preview = json[SerializationKeys.preview].string
    countryCode = json[SerializationKeys.countryCode].string
    addressLine1 = json[SerializationKeys.addressLine1].string
    addressLine2 = json[SerializationKeys.addressLine2].string
    addressLine3 = json[SerializationKeys.addressLine3].string
    addressId = json[SerializationKeys.addressId].int
    zipOrPostalCode = json[SerializationKeys.zipOrPostalCode].string
    isPreferred = json[SerializationKeys.isPreferred].bool
  }
    
    public init(zip : String){
        self.zipOrPostalCode = zip
    }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = stateOrProvince { dictionary[SerializationKeys.stateOrProvince] = value }
    if let value = city { dictionary[SerializationKeys.city] = value }
    if let value = geoLocation { dictionary[SerializationKeys.geoLocation] = value.dictionaryRepresentation() }
    if let value = preview { dictionary[SerializationKeys.preview] = value }
    if let value = countryCode { dictionary[SerializationKeys.countryCode] = value }
    if let value = addressLine1 { dictionary[SerializationKeys.addressLine1] = value }
    if let value = zipOrPostalCode { dictionary[SerializationKeys.zipOrPostalCode] = value }
    return dictionary
  }

}
