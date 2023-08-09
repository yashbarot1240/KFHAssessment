//
//  CurrencyViewController.swift
//  KFH Assessment
//
//  Created by Yash Barot on 09/08/23.
//

import UIKit

class CurrencyViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    lazy var viewModel: CurrencyViewModel = {
        return CurrencyViewModel()
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Init the static view
        initView()
        
        // init view model
        initVM()
    }
    

    

}

extension CurrencyViewController {
    
    //Mark: Setup View Component
    func initView() {
        
        
    }
    
    //Mark: Update View
    func updateUI()  {
       
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
                        self?.tableView.alpha = 0.0
                    })
                }else {
                    self?.activityIndicator.stopAnimating()
                    UIView.animate(withDuration: 0.2, animations: {
                        self?.tableView.alpha = 1.0
                    })
                }
                
                self?.activityIndicator.isHidden = !isLoading
            }
        }
        
        viewModel.reloadTableViewClosure = { [weak self] () in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        
        

        viewModel.getCurrencyList()
        
    }
    
}



extension CurrencyViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Cells.currencyCellIdentifier , for: indexPath) as? CurrencyTableViewCell else {
            fatalError("Cell not exists in storyboard")
        }
        
        let cellVM = viewModel.getCellViewModel( at: indexPath )
        
        cell.labelCurrecyCode.text = cellVM.to
        cell.labelRate.text = cellVM.rate
    
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfCells
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        
        
        return nil
       
    }
    
}

