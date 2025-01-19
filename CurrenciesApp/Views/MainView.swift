//
//  MainView.swift
//  CurrenciesApp
//
//  Created by Alex Ch on 19.01.25.
//

import UIKit

class MainView: UIViewController {
    var safeArea: UILayoutGuide!
    let viewModel = MainViewModel()
    let tableView = UITableView()
    let updateButton = UIButton()
    var currenciesArr: [CurrencyDomain] = []
    var filteredCurrencies: [CurrencyDomain] = []
    let activityView = UIActivityIndicatorView(style: .large)
    let searchBarController = UISearchController(searchResultsController: nil)
    var isSearching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.safeArea = view.layoutMarginsGuide
        self.bindViewModel()
        self.setupUI()
    }

    func bindViewModel() {
        viewModel.mainState.bind { [weak self] newState in
            switch newState {
            case .defaultState:
                print("default")
            case .newData(let dictionary):
                self?.currenciesArr.removeAll()
                self?.currenciesArr = dictionary.sorted { $0.name < $1.name }
                self?.tableView.reloadData()
                self?.removeActivityIndicator()
                self?.updateButton.isEnabled = true
            case .error(let error):
                self?.removeActivityIndicator()
                self?.updateButton.isEnabled = true
                let alert = UIAlertController(title: "Something went wrong :(", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default) { _ in
                    alert.dismiss(animated: true)
                })
                self?.present(alert, animated: true, completion: nil)
                
            case .loading:
                self?.updateButton.isEnabled = false
                self?.showActivityIndicatory()
            }
            
            
        }
        viewModel.start()
    }

    func setupUI() {
        tableView.delegate = self
        tableView.dataSource = self
        setSearchBarUI()
        view.backgroundColor = .white
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: safeArea.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        tableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -50).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        tableView.register(CurrencyCell.self, forCellReuseIdentifier: "CurrencyCell")
        tableView.backgroundColor = .white
        
        view.addSubview(updateButton)
        updateButton.translatesAutoresizingMaskIntoConstraints = false
        updateButton.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 16).isActive = true
        updateButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        updateButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor).isActive = true
        updateButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        updateButton.setTitle("Update", for: .normal)
        updateButton.backgroundColor = .darkGray
        updateButton.layer.cornerRadius = 16
        updateButton.layer.cornerCurve = .continuous
        updateButton.addTarget(self, action: #selector(updateData), for: .touchUpInside)
        
    }

    func setSearchBarUI() {
        searchBarController.searchBar.delegate = self
        searchBarController.obscuresBackgroundDuringPresentation = false
        searchBarController.searchBar.sizeToFit()
        let textField = self.searchBarController.searchBar.value(forKey: "searchField") as? UITextField
        textField?.textColor = .black
        textField?.attributedPlaceholder = NSAttributedString(string: "Search here", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        navigationItem.searchController = searchBarController
    }

    @objc func updateData() {
        viewModel.makeRequest()
    }

    func showActivityIndicatory() {
        activityView.center = self.view.center
        activityView.color = .black
        self.view.addSubview(activityView)
        activityView.startAnimating()
    }
    
    func removeActivityIndicator() {
        activityView.stopAnimating()
        self.activityView.removeFromSuperview()
    }
}

extension MainView: UITableViewDataSource, UITableViewDelegate {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      if isSearching {
          return filteredCurrencies.count
      } else {
          return currenciesArr.count
      }
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "CurrencyCell", for: indexPath) as? CurrencyCell
      if isSearching {
          cell?.nameLabel.text = "\(filteredCurrencies[indexPath.row].name)"
          cell?.valueLabel.text = "1 USD = \(filteredCurrencies[indexPath.row].value) \(filteredCurrencies[indexPath.row].name)"
      } else {
          cell?.nameLabel.text = "\(currenciesArr[indexPath.row].name)"
          cell?.valueLabel.text = "1 USD = \(currenciesArr[indexPath.row].value) \(currenciesArr[indexPath.row].name)"
      }

      return cell ?? UITableViewCell()
  }
}
extension MainView: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let searchResultArr = currenciesArr.filter{ ($0.name.contains(searchText.uppercased())) }
        isSearching = true
        filteredCurrencies = searchResultArr
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        isSearching = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        searchBar.text = String()
        isSearching = false
        tableView.reloadData()
    }
    
}
