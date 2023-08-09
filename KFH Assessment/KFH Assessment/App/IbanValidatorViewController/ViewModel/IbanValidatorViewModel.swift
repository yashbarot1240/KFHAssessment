//
//  IbanValidatorViewModel.swift
//  KFH Assessment
//
//  Created by Yash Barot on 09/08/23.
//

import Foundation
import UIKit

class IbanValidatorViewModel {
 
    let apiService: APIServiceProtocol
    
    private var iban: IbanValidatorModel?
    
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
    
    var showAlertClosure: (()->())?
    var updateLoadingStatus: (()->())?
    var result: ((IbanValidatorModel)->())?
    
    init( apiService: APIServiceProtocol = APIService()) {
        self.apiService = apiService
    }
    
    
    func validateAccount(account_number : String) {
        self.isLoading = true
        apiService.validateAccountNumber(account_number: account_number) { [weak self] success, iban_validator, error in
            self?.isLoading = false
            
            if let error = error {
                self?.alertMessage = error.localizedDescription
            } else {
                
                self?.processValidate(iban_validator: iban_validator)
            }
        }
    }
    
    private func processValidate(iban_validator: IbanValidatorModel?) {
        self.iban = iban_validator // Cache
        self.result?(self.iban!)
    }
    
}
