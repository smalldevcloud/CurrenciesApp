//
//  NetworkManager.swift
//  CurrenciesApp
//
//  Created by Alex Ch on 19.01.25.
//

import Foundation

enum NetError: Error {
    case noData
    case badURL
}

final class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() {}
    
    let someStringToBotsCantParse = "Y2GkaoDO9sifOubk3FrrMYHkOA3hmThWPeLI7gIJ"
    let url = "https://api.freecurrencyapi.com/v1/latest?apikey=fca_live_"
    
    func getNewData() async throws -> CurrenciesJsonModel {
        guard let fullUrl = URL(string: "\(url)\(someStringToBotsCantParse)") else { throw NetError.badURL }
        var request = URLRequest(url: fullUrl)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let (data, response) = try await URLSession.shared.data(for: request)

        do {
            let decoder = JSONDecoder()
            let model = try decoder.decode(CurrenciesJsonModel.self, from: data)

            return model
        } catch let parsingError {
            print("Parsing error", parsingError)
            throw parsingError
        }
    }
}
