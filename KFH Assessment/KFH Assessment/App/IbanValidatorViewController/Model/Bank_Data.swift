//
//  Bank_Data.swift
//  KFH Assessment
//
//  Created by Yash Barot on 09/08/23.
//

import Foundation

struct Bank_data : Codable {
    let bank_code : String?
    let name : String?
    let zip : String?
    let city : String?
    let bic : String?
   
    
    
    enum CodingKeys: String, CodingKey {

        case bank_code = "bank_code"
        case name = "name"
        case zip = "zip"
        case city = "city"
        case bic = "bic"
    
       
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        bank_code = try values.decodeIfPresent(String.self, forKey: .bank_code)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        zip = try values.decodeIfPresent(String.self, forKey: .zip)
        city = try values.decodeIfPresent(String.self, forKey: .city)
        bic = try values.decodeIfPresent(String.self, forKey: .bic)
        
    }
}
