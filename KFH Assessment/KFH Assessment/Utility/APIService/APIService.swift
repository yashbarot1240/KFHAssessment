//
//  APIService.swift
//  KFH Assessment
//
//  Created by Yash Barot on 09/08/23.
//

import Foundation

struct ApiName {
    static let validateAccountNumber = "bank_data/iban_validate"
    static let currencyList = "fixer/symbols"
    static let currencyconvert = "fixer/latest"
    

}

protocol APIServiceProtocol {
    func validateAccountNumber(account_number : String, complete: @escaping ( _ success: Bool, _ iban_validator: IbanValidatorModel?, _ error: Error? )->() )
    func getCurrencyList(complete: @escaping ( _ success: Bool, _ currency: Currency?, _ error: Error? )->() )
    func getCurrencyRate(base : String,symbols: [String], complete: @escaping ( _ success:Bool, _ currencyRates:  CurrencyRates?, _ error: Error?) -> () )
    
    
}

class UrlComponents {
    let path: String
    let baseUrlString = "https://api.apilayer.com/"
    let apiKey = "h7xRsol7mnvFMDnq6f7yY0KoeeG5rJBD"
    let searchQuery: String?
    
    
    var url: URL {
        var query = [String]()
        if let searchQuery = searchQuery {
            query.append("\(searchQuery)")
        }
//        query.append("apikey=\(apiKey)")
        
        guard let composedUrl = URL(string: "?" + query.joined(separator: "&"), relativeTo: NSURL(string: baseUrlString + path + "?") as URL?) else {
            fatalError("Unable to build request url")
        }
        
        return composedUrl
    }
    
    init(path: String, query: String? = nil) {
        self.path = path
        guard var query = query else {
            self.searchQuery = nil
            return
        }
        
        query = query.replacingOccurrences(of: " ", with: "+")
        self.searchQuery = query
    }
}


class APIService: APIServiceProtocol {
   
    
    private let sessionManager: URLSession = {
        let urlSessionConfiguration: URLSessionConfiguration = URLSessionConfiguration.default
        return URLSession(configuration: urlSessionConfiguration, delegate: nil, delegateQueue: nil)
    }()
    
    
    // Uncomment For SSL Pinning
//    private let sessionManager: URLSession = {
//        let urlSessionConfiguration: URLSessionConfiguration = URLSessionConfiguration.default
//        return URLSession(configuration: urlSessionConfiguration, delegate: SSLURLSessionPinningDelegate(), delegateQueue: nil)
//    }()

    
    // Validate Account Number
    func validateAccountNumber(account_number: String, complete: @escaping (Bool, IbanValidatorModel?, Error?) -> ()) {
        
        let urlComponents = UrlComponents(path: ApiName.validateAccountNumber,query: "iban_number=\(account_number)")
        var request = URLRequest(url: urlComponents.url)
        request.setValue(urlComponents.apiKey, forHTTPHeaderField: "apikey")
        request.httpMethod = "get"
        
        sessionManager.dataTask(with: request) { (data, response, error) in
            
            //Handle error case
            guard error == nil else {
                complete( false,nil, error )

                return
            }
                        
            let decoder = JSONDecoder()
            
            guard let data = data,
                let responseData = try? decoder.decode(IbanValidatorModel.self, from: data) else {
                complete(false, nil, error)
                    return
            }
                        
            if responseData.valid! {
                
                complete( true, responseData, nil )
            }
            else{
                //Manage the else case
                complete( false,nil, error )

                return
            }
          
          
            }.resume()

    }
    
    // Get Currency List
    func getCurrencyList(complete: @escaping (Bool, Currency?, Error?) -> ()) {
        
        let urlComponents = UrlComponents(path: ApiName.currencyList)
        var request = URLRequest(url: urlComponents.url)
        request.setValue(urlComponents.apiKey, forHTTPHeaderField: "apikey")
        request.httpMethod = "get"
        
        
        sessionManager.dataTask(with: request) { (data, response, error) in
            
            //Handle error case
            guard error == nil else {
                complete( false,nil, error )

                return
            }
            let decoder = JSONDecoder()

            
            guard let data = data,
                let responseData = try? decoder.decode(Currency.self, from: data) else {
                complete(false, nil, error)
                    return
            }
            
            
            
            if responseData.success! {
                
                
                
                complete( true, responseData, nil )
            }
            else{
                //Manage the else case
                complete( false,nil, error )

                return
            }
          
          
            }.resume()

    }
    
    
    
    // Get Currency Rates
    func getCurrencyRate(base : String,symbols: [String], complete: @escaping (Bool, CurrencyRates?, Error?) -> ()) {
        
        let urlComponents = UrlComponents(path: ApiName.currencyconvert,query: "symbols=\(symbols.joined(separator: "%2C"))&base=\(base)")
        var request = URLRequest(url: urlComponents.url)
        request.setValue(urlComponents.apiKey, forHTTPHeaderField: "apikey")
        request.httpMethod = "get"
        
        
        sessionManager.dataTask(with: request) { (data, response, error) in
            
            //Handle error case
            guard error == nil else {
                complete( false,nil, error )

                return
            }
            let decoder = JSONDecoder()

            
            guard let data = data,
                let responseData = try? decoder.decode(CurrencyRates.self, from: data) else {
                complete(false, nil, error)
                    return
            }
            
            
            
            if responseData.success! {
                
                
                
                complete( true, responseData, nil )
            }
            else{
                //Manage the else case
                complete( false,nil, error )

                return
            }
          
          
            }.resume()

    }
    
    
}




class SSLURLSessionPinningDelegate: NSObject, URLSessionDelegate {
    
    let certFileName = "certificateFile"
    let certFileType = "cer"
    
    func urlSession(_ session: URLSession,
                    didReceive challenge: URLAuthenticationChallenge,
                    completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Swift.Void) {
        
        if (challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust) {
            if let serverTrust = challenge.protectionSpace.serverTrust {
                var secresult = SecTrustResultType.invalid
                let status = SecTrustEvaluate(serverTrust, &secresult)
                
                if(errSecSuccess == status) {
                    if let serverCertificate = SecTrustGetCertificateAtIndex(serverTrust, 0) {
                        let serverCertificateData = SecCertificateCopyData(serverCertificate)
                        let data = CFDataGetBytePtr(serverCertificateData);
                        let size = CFDataGetLength(serverCertificateData);
                        let certificateOne = NSData(bytes: data, length: size)
                        let filePath = Bundle.main.path(forResource: self.certFileName,
                                                        ofType: self.certFileType)
                        
                        if let file = filePath {
                            if let certificateTwo = NSData(contentsOfFile: file) {
                                if certificateOne.isEqual(to: certificateTwo as Data) {
                                    completionHandler(URLSession.AuthChallengeDisposition.useCredential,
                                                      URLCredential(trust:serverTrust))
                                    return
                                }
                            }
                        }
                    }
                }
            }
        }
        
        // Pinning failed
        completionHandler(URLSession.AuthChallengeDisposition.cancelAuthenticationChallenge, nil)
    }
}
