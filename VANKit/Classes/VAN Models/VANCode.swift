//
//  Codes.swift
//
//  Created by David Switzer on 1/25/18
//  Copyright (c) Madison Labs. All rights reserved.
//

import Foundation
import SwiftyJSON

public class VANCode {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let codeId = "codeId"
    static let dateCreated = "dateCreated"
    static let name = "name"
    static let codeType = "codeType"
  }

  // MARK: Properties
  public var codeId: Int?
  public var dateCreated: String?
  public var name: String?
  public var codeType: String?

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
    codeId = json[SerializationKeys.codeId].int
    dateCreated = json[SerializationKeys.dateCreated].string
    name = json[SerializationKeys.name].string
    codeType = json[SerializationKeys.codeType].string
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = codeId { dictionary[SerializationKeys.codeId] = value }
    if let value = dateCreated { dictionary[SerializationKeys.dateCreated] = value }
    if let value = name { dictionary[SerializationKeys.name] = value }
    if let value = codeType { dictionary[SerializationKeys.codeType] = value }
    return dictionary
  }

}
