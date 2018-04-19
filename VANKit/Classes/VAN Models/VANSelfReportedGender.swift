//
//  VANSelfReportedGenders.swift
//
//  Created by David Switzer on 1/26/18
//  Copyright (c) Madison Labs. All rights reserved.
//

import Foundation
import SwiftyJSON

public class VANSelfReportedGender {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let reportedGenderId = "reportedGenderId"
  }

  // MARK: Properties
  public var reportedGenderId: Int?

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
    reportedGenderId = json[SerializationKeys.reportedGenderId].int
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = reportedGenderId { dictionary[SerializationKeys.reportedGenderId] = value }
    return dictionary
  }

}
