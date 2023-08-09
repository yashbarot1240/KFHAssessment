//
//  ViewController.swift
//  KFH Assessment
//
//  Created by Yash Barot on 09/08/23.
//

import UIKit

class IbanValidatorViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var textFieldAccountNumber: UITextField!
    @IBOutlet weak var buttonValidate: UIButton!
    @IBOutlet weak var infoLabel : UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Objects
    lazy var viewModel: IbanValidatorViewModel = {
        return IbanValidatorViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Init the static view
        initView()
        
        // init view model
        initVM()
    }

    
    // MARK: - IB ACtions
    @IBAction func click_validateButton(_ sender: Any) {
        
        self.viewModel.validateAccount(account_number: self.textFieldAccountNumber.text ?? "")

    }

}

extension IbanValidatorViewController {
    
    //Mark: Setup View Component
    func initView() {
        self.activityIndicator.isHidden = true
        self.textFieldAccountNumber.text = ""
    }
    //Mark: Update View
    func updateUI(data : IbanValidatorModel)  {
        let infoText = "Iban Information : \n" +
        "Account number : \(data.iban_data?.account_number ?? "")\n" +
        "Country : \(data.iban_data?.country ?? "") \n" +
        "Country code : \(data.iban_data?.country_code ?? "") \n\n\n" +
        "Bank Information : \n" +
        "Bank Name : \(data.bank_data?.name ?? "")\n" +
        "Bank City : \(data.bank_data?.city ?? "")\n" +
        "Bank Code : \(data.bank_data?.bank_code ?? "")\n"
        self.infoLabel.text = infoText
    }
        
    //Mark: Setup ViewModel
    func initVM() {
        viewModel.showAlertClosure = { [weak self] () in
            DispatchQueue.main.async {
                if let message = self?.viewModel.alertMessage {
                    self?.showAlert( message )
                }
            }
        }
        
        viewModel.updateLoadingStatus = { [weak self] () in
            DispatchQueue.main.async {
                
                let isLoading = self?.viewModel.isLoading ?? false
                if isLoading {
                    self?.activityIndicator.startAnimating()
                    UIView.animate(withDuration: 0.2, animations: {
//                        self?.tableView.alpha = 0.0
                    })
                }else {
                    self?.activityIndicator.stopAnimating()
                    UIView.animate(withDuration: 0.2, animations: {
//                        self?.tableView.alpha = 1.0
                    })
                }
                
                self?.activityIndicator.isHidden = !isLoading
            }
        }
        
        viewModel.result = { [weak self] (result) in
            DispatchQueue.main.async {
                //Get the result
                if let message = result.message {
                    self?.showAlert( message )
                }
                self?.updateUI(data: result)
                
            }
        }

        
    }
    
}


