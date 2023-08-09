//
//  IbanValidatorModel.swift
//  KFH Assessment
//
//  Created by Yash Barot on 09/08/23.
//

import Foundation
struct IbanValidatorModel : Codable {
    let valid : Bool?
    let iban : String?
    let iban_data : Iban_data?
    let bank_data : Bank_data?
    let country_iban_example : String?
    let message : String?
    
    
    enum CodingKeys: String, CodingKey {

        case valid = "valid"
        case iban = "iban"
        case iban_data = "iban_data"
        case bank_data = "bank_data"
        case country_iban_example = "country_iban_example"
        case message = "message"
       
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        valid = try values.decodeIfPresent(Bool.self, forKey: .valid)
        iban = try values.decodeIfPresent(String.self, forKey: .iban)
        iban_data = try values.decodeIfPresent(Iban_data.self, forKey: .iban_data)
        bank_data = try values.decodeIfPresent(Bank_data.self, forKey: .bank_data)
        country_iban_example = try values.decodeIfPresent(String.self, forKey: .country_iban_example)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        
    }
}
