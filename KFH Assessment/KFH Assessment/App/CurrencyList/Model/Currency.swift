//
//  Currency.swift
//  KFH Assessment
//
//  Created by Yash Barot on 09/08/23.
//

import Foundation
struct Currency : Codable {
   
    let symbols : [String:String]?
    let success : Bool?
    
    enum CodingKeys: String, CodingKey {

        case symbols = "symbols"
        case success = "success"
       
       
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        success = try values.decodeIfPresent(Bool.self, forKey: .success)
        symbols = try values.decodeIfPresent([String:String].self, forKey: .symbols)
     
        
    }
}
