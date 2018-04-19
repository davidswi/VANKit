//
//  VANPerson.swift
//
//  Created by David Switzer on 1/26/18
//  Copyright (c) Madison Labs. All rights reserved.
//

import Foundation
import SwiftyJSON

public class VANPerson {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let suffix = "suffix"
    static let selfReportedRaces = "selfReportedRaces"
    static let middleName = "middleName"
    static let party = "party"
    static let nickname = "nickname"
    static let lastName = "lastName"
    static let customFieldValues = "customFieldValues"
    static let selfReportedGenders = "selfReportedGenders"
    static let selfReportedSexualOrientations = "selfReportedSexualOrientations"
    static let emails = "emails"
    static let identifiers = "identifiers"
    static let title = "title"
    static let phones = "phones"
    static let employer = "employer"
    static let selfReportedLanguagePreference = "selfReportedLanguagePreference"
    static let addresses = "addresses"
    static let website = "website"
    static let recordedAddresses = "recordedAddresses"
    static let dateOfBirth = "dateOfBirth"
    static let salutation = "salutation"
    static let occupation = "occupation"
    static let selfReportedEthnicities = "selfReportedEthnicities"
    static let vanId = "vanId"
    static let envelopeName = "envelopeName"
    static let contactMethodPreferenceCode = "contactMethodPreferenceCode"
    static let suppressions = "suppressions"
    static let firstName = "firstName"
    static let sex = "sex"
  }

  // MARK: Properties
  public var suffix: String?
  public var selfReportedRaces: [VANSelfReportedRace]?
  public var middleName: String?
  public var party: String?
  public var nickname: String?
  public var lastName: String?
  public var customFieldValues: [VANCustomFieldValue]?
  public var selfReportedGenders: [VANSelfReportedGender]?
  public var selfReportedSexualOrientations: [VANSelfReportedSexualOrientation]?
  public var emails: [VANEmail]?
  public var identifiers: [VANIdentifier]?
  public var title: String?
  public var phones: [VANPhone]?
  public var employer: String?
  public var selfReportedLanguagePreference: VANSelfReportedLanguagePreference?
  public var addresses: [VANAddress]?
  public var website: String?
  public var recordedAddresses: [VANAddress]?
  public var dateOfBirth: String?
  public var salutation: String?
  public var occupation: String?
  public var selfReportedEthnicities: [VANSelfReportedEthnicity]?
  public var vanId: Int?
  public var envelopeName: String?
  public var contactMethodPreferenceCode: String?
  public var suppressions: [VANSuppression]?
  public var firstName: String?
  public var sex: String?
    
    public var phoneNumber : String?{
        set{
            if phones?.count == 0{
                phones?.append(VANPhone(number: newValue!))
            }
            else{
                phones?[0] = VANPhone(number: newValue!)
            }
        }
        get {
            return phones?[0].phoneNumber
        }
    }
    
    public var emailAddress : String?{
        set{
            if emails?.count == 0{
                emails?.append(VANEmail(address: newValue!))
            }
            else{
                self.emails?[0] = VANEmail(address: newValue!)
            }
        }
        get{
            return self.emails?[0].email
        }
    }
    
    public var zipCode : String?{
        set{
            if addresses?.count == 0{
                addresses?.append(VANAddress(zip: newValue!))
            }
            else{
                self.addresses?[0] = VANAddress(zip: newValue!)
            }
        }
        get{
            return self.addresses?[0].zipOrPostalCode
        }
    }

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
    suffix = json[SerializationKeys.suffix].string
    if let items = json[SerializationKeys.selfReportedRaces].array { selfReportedRaces = items.map { VANSelfReportedRace(json: $0) } }
    middleName = json[SerializationKeys.middleName].string
    party = json[SerializationKeys.party].string
    nickname = json[SerializationKeys.nickname].string
    lastName = json[SerializationKeys.lastName].string
    if let items = json[SerializationKeys.customFieldValues].array { customFieldValues = items.map { VANCustomFieldValue(json: $0) } }
    if let items = json[SerializationKeys.selfReportedGenders].array { selfReportedGenders = items.map { VANSelfReportedGender(json: $0) } }
    if let items = json[SerializationKeys.selfReportedSexualOrientations].array { selfReportedSexualOrientations = items.map { VANSelfReportedSexualOrientation(json: $0) } }
    if let items = json[SerializationKeys.emails].array { emails = items.map { VANEmail(json: $0) } }
    if let items = json[SerializationKeys.identifiers].array { identifiers = items.map { VANIdentifier(json: $0) } }
    title = json[SerializationKeys.title].string
    if let items = json[SerializationKeys.phones].array { phones = items.map { VANPhone(json: $0) } }
    employer = json[SerializationKeys.employer].string
    selfReportedLanguagePreference = VANSelfReportedLanguagePreference(json: json[SerializationKeys.selfReportedLanguagePreference])
    if let items = json[SerializationKeys.addresses].array { addresses = items.map { VANAddress(json: $0) } }
    website = json[SerializationKeys.website].string
    if let items = json[SerializationKeys.recordedAddresses].array { recordedAddresses = items.map { VANAddress(json: $0) } }
    dateOfBirth = json[SerializationKeys.dateOfBirth].string
    salutation = json[SerializationKeys.salutation].string
    occupation = json[SerializationKeys.occupation].string
    if let items = json[SerializationKeys.selfReportedEthnicities].array { selfReportedEthnicities = items.map { VANSelfReportedEthnicity(json: $0) } }
    vanId = json[SerializationKeys.vanId].int
    envelopeName = json[SerializationKeys.envelopeName].string
    contactMethodPreferenceCode = json[SerializationKeys.contactMethodPreferenceCode].string
    if let items = json[SerializationKeys.suppressions].array { suppressions = items.map { VANSuppression(json: $0) } }
    firstName = json[SerializationKeys.firstName].string
    sex = json[SerializationKeys.sex].string
  }
    
    public init(firstName : String, lastName : String){
        self.firstName = firstName
        self.lastName = lastName
        self.phones = Array<VANPhone>()
        self.addresses = Array<VANAddress>()
        self.emails = Array<VANEmail>()
    }
    
    public init(vanId : Int){
        self.vanId = vanId
    }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = suffix { dictionary[SerializationKeys.suffix] = value }
    if let value = selfReportedRaces { dictionary[SerializationKeys.selfReportedRaces] = value.map { $0.dictionaryRepresentation() } }
    if let value = middleName { dictionary[SerializationKeys.middleName] = value }
    if let value = party { dictionary[SerializationKeys.party] = value }
    if let value = nickname { dictionary[SerializationKeys.nickname] = value }
    if let value = lastName { dictionary[SerializationKeys.lastName] = value }
    if let value = customFieldValues { dictionary[SerializationKeys.customFieldValues] = value.map { $0.dictionaryRepresentation() } }
    if let value = selfReportedGenders { dictionary[SerializationKeys.selfReportedGenders] = value.map { $0.dictionaryRepresentation() } }
    if let value = selfReportedSexualOrientations { dictionary[SerializationKeys.selfReportedSexualOrientations] = value.map { $0.dictionaryRepresentation() } }
    if let value = emails { dictionary[SerializationKeys.emails] = value.map { $0.dictionaryRepresentation() } }
    if let value = identifiers { dictionary[SerializationKeys.identifiers] = value.map { $0.dictionaryRepresentation() } }
    if let value = title { dictionary[SerializationKeys.title] = value }
    if let value = phones { dictionary[SerializationKeys.phones] = value.map { $0.dictionaryRepresentation() } }
    if let value = employer { dictionary[SerializationKeys.employer] = value }
    if let value = selfReportedLanguagePreference { dictionary[SerializationKeys.selfReportedLanguagePreference] = value.dictionaryRepresentation() }
    if let value = addresses { dictionary[SerializationKeys.addresses] = value.map { $0.dictionaryRepresentation() } }
    if let value = website { dictionary[SerializationKeys.website] = value }
    if let value = recordedAddresses { dictionary[SerializationKeys.recordedAddresses] = value.map { $0.dictionaryRepresentation() } }
    if let value = dateOfBirth { dictionary[SerializationKeys.dateOfBirth] = value }
    if let value = salutation { dictionary[SerializationKeys.salutation] = value }
    if let value = occupation { dictionary[SerializationKeys.occupation] = value }
    if let value = selfReportedEthnicities { dictionary[SerializationKeys.selfReportedEthnicities] = value.map { $0.dictionaryRepresentation() } }
    if let value = vanId { dictionary[SerializationKeys.vanId] = value }
    if let value = envelopeName { dictionary[SerializationKeys.envelopeName] = value }
    if let value = contactMethodPreferenceCode { dictionary[SerializationKeys.contactMethodPreferenceCode] = value }
    if let value = suppressions { dictionary[SerializationKeys.suppressions] = value.map { $0.dictionaryRepresentation() } }
    if let value = firstName { dictionary[SerializationKeys.firstName] = value }
    if let value = sex { dictionary[SerializationKeys.sex] = value }
    return dictionary
  }

}
