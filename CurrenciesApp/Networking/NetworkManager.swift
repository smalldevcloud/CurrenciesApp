//
//  NetworkManager.swift
//  CurrenciesApp
//
//  Created by Alex Ch on 19.01.25.
//

import Foundation

final class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() {}
    
    let someStringToBotsCantParse = "Y2GkaoDO9sifOubk3FrrMYHkOA3hmThWPeLI7gIJ"
    let url = "https://api.freecurrencyapi.com/v1/latest?apikey=fca_live_"
    
    func getNewData(onResponse: @escaping (Result<CurrenciesJsonModel, Error>) -> Void) {
        guard let fullUrl = URL(string: "\(url)\(someStringToBotsCantParse)") else { return }
        var request = URLRequest(url: fullUrl)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let dataResponse = data,
                  error == nil else {
                print(error?.localizedDescription ?? "Response Error")
                return
            }
            do {
                let decoder = JSONDecoder()
                let model = try decoder.decode(CurrenciesJsonModel.self, from: dataResponse)
                
                DispatchQueue.main.async {
                    onResponse(.success(model))
                }
            } catch let parsingError {
                print("Parsing error", parsingError)
            }
        }
        task.resume()
    }
}
