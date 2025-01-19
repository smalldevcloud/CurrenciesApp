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
        NetworkManager.shared.getNewData { response in
            switch response {
            case .success(let newData):
                var domainObjects: [CurrencyDomain] = []
                for item in newData.data {
                    domainObjects.append(CurrencyDomain(name: item.key, value: item.value))
                }
                self.mainState.value = .newData(domainObjects)
            case .failure(let failure):
                self.mainState.value = .error(failure)
            }
        }
    }
    
    func stop() {
        timer?.invalidate()
    }
}
