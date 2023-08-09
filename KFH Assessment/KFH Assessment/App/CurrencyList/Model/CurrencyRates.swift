//
//  CurrencyRates.swift
//  KFH Assessment
//
//  Created by Yash Barot on 09/08/23.
//

import Foundation
struct CurrencyRates : Codable {
    let base : String?
    let date : String?
    let rates : [String:Double]?
    let success : Bool?
    
    enum CodingKeys: String, CodingKey {
        case base = "base"
        case date = "date"
        case rates = "rates"
        case success = "success"
        

       
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        base = try values.decodeIfPresent(String.self, forKey: .base)
        date = try values.decodeIfPresent(String.self, forKey: .date)
        rates = try values.decodeIfPresent([String:Double].self, forKey: .rates)
        success = try values.decodeIfPresent(Bool.self, forKey: .success)
        
        
    }
}
