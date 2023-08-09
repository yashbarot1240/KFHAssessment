//
//  CurrencyViewModel.swift
//  KFH Assessment
//
//  Created by Yash Barot on 09/08/23.
//

import Foundation

class CurrencyViewModel {
 
    let apiService: APIServiceProtocol
    
    
    private var currencyRates: CurrencyRates?
    
    private var cellViewModels: [CurrencyListCellViewModel] = [CurrencyListCellViewModel]() {
        didSet {
            self.reloadTableViewClosure?()
        }
    }
    
    var isLoading: Bool = false {
        didSet {
            self.updateLoadingStatus?()
        }
    }
    
    var alertMessage: String? {
        didSet {
            self.showAlertClosure?()
        }
    }
    
    var numberOfCells: Int {
        return cellViewModels.count
    }
    
    var showAlertClosure: (()->())?
    var updateLoadingStatus: (()->())?
    var reloadTableViewClosure: (()->())?
    
    
    init( apiService: APIServiceProtocol = APIService()) {
        self.apiService = apiService
    }
    
    
    func getCurrencyList() {
        self.isLoading = true
        apiService.getCurrencyList { [weak self] success, currency, error in
            
            
            if let error = error {
                self?.isLoading = false
                self?.alertMessage = error.localizedDescription
            } else {
                let symbols : [String] = currency?.symbols!.map{ $0.key } ?? []
                self?.getCurrencyRate(base: "KWD", symbols: symbols)
                
            }
        }
    }
    
    
    func getCurrencyRate(base : String,symbols : [String]) {
        self.isLoading = true
        apiService.getCurrencyRate(base: base, symbols: symbols) { [weak self] success, currencyRates, error in
            self?.isLoading = false
            
            if let error = error {
             
                self?.alertMessage = error.localizedDescription
            } else {
                self?.processValidate(currencyRates: currencyRates!)
                
            }
        }
    }
    
    
    func getCellViewModel( at indexPath: IndexPath ) -> CurrencyListCellViewModel {
        return cellViewModels[indexPath.row]
    }
    
    func createCellViewModel(from: String, to: String, rate: String) -> CurrencyListCellViewModel {
        
        return CurrencyListCellViewModel(from: from, to: to, rate: rate)
    }
    
    private func processValidate(currencyRates: CurrencyRates) {
        self.currencyRates = currencyRates // Cache
        var vms = [CurrencyListCellViewModel]()
        for (key, value) in currencyRates.rates! {
            vms.append( createCellViewModel(from: "KWD", to: key, rate: "\(value)"))
        }
        self.cellViewModels = vms
    }
    
}


struct CurrencyListCellViewModel {
    let from: String
    let to: String
    let rate: String
}
