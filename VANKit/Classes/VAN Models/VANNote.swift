//
//  Notes.swift
//
//  Created by David Switzer on 1/25/18
//  Copyright (c) Madison Labs. All rights reserved.
//

import Foundation
import SwiftyJSON

public class VANNote {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let noteId = "noteId"
    static let isViewRestricted = "isViewRestricted"
    static let text = "text"
    static let createdDate = "createdDate"
  }

  // MARK: Properties
  public var noteId: Int?
  public var isViewRestricted: Bool? = false
  public var text: String?
  public var createdDate: String?

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
    noteId = json[SerializationKeys.noteId].int
    isViewRestricted = json[SerializationKeys.isViewRestricted].boolValue
    text = json[SerializationKeys.text].string
    createdDate = json[SerializationKeys.createdDate].string
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = noteId { dictionary[SerializationKeys.noteId] = value }
    dictionary[SerializationKeys.isViewRestricted] = isViewRestricted
    if let value = text { dictionary[SerializationKeys.text] = value }
    if let value = createdDate { dictionary[SerializationKeys.createdDate] = value }
    return dictionary
  }

}
