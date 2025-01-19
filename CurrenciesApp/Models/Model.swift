//
//  Model.swift
//  CurrenciesApp
//
//  Created by Alex Ch on 19.01.25.
//

import Foundation

struct CurrenciesJsonModel: Decodable {
    let data: [String: Double]
}

class CurrencyDomain {
    let name: String
    let value: Double
    
    init(name: String, value: Double) {
        self.name = name
        self.value = value
    }
}
