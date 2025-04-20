//
//  MainViewModel.swift
//  CurrenciesApp
//
//  Created by Alex Ch on 19.01.25.
//

import Foundation

extension MainViewModel {
    enum MainState {
        case defaultState
        case loading
        case newData([CurrencyDomain])
        case error(Error)
    }
}

class MainViewModel {
    var mainState = Dynamic<MainState>(.defaultState)
    var timer: Timer?
    
    func start() {
        makeRequest()
        timer = Timer.scheduledTimer(timeInterval: 30, target: self, selector: #selector(makeRequest), userInfo: nil, repeats: true)
    }
    
    @objc func makeRequest() {
        mainState.value = .loading

        var domainObjects: [CurrencyDomain] = []

        Task { @MainActor in
            do {
                let newData = try await NetworkManager.shared.getNewData()
                for item in newData.data {
                    domainObjects.append(CurrencyDomain(name: item.key, value: item.value))
                }
                self.mainState.value = .newData(domainObjects)
            }
            catch {
                self.mainState.value = .error(error)
            }
        }
    }
    
    func stop() {
        timer?.invalidate()
    }
}
