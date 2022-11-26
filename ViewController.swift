//
//  ViewController.swift
//  API-REQUEST
//
//  Created by Shane Ericksen on 20/10/2022.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var submitButton: UIButton!
    @IBOutlet var debtorCode: UITextField!
    @IBOutlet var displayData: UILabel!
        
    struct Debtors: Codable {
        struct Debtor: Codable {
            var code: String
            var email: String
            var fax: String
            var name: String
            var phone: String
            var territory: String
            var website: String
            var warehouse: String
            var customer_type: String
            var rep_code: Int
            var status: String
        }
        struct Brands: Codable {
            var brand_code: [String]
        }
    }
    
    var debtorArray: [Debtors] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func startDebtorCode(_ sender: Any) {
        debtorCode.text = ""
    }
    
    @IBAction func clickSubmit(_ sender: Any) {
        httpGET()
    }
    
    func httpGET() {
        var debtorcode: String = debtorCode.text!
        print("Submitted - Debtor: \(debtorcode)")
        
        var semaphore = DispatchSemaphore (value: 0)
        var request = URLRequest(url: URL(string: "https://rgs-api.prontoavenue.biz/api/json/debtor/v5_rgs/?account_code=\(debtorcode)")!, timeoutInterval: Double.infinity)
        request.addValue("Basic c0Blcmlja3Nlbi5tZTpEMGdnMWVzMTY=", forHTTPHeaderField: "Authorization")
        
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard error == nil else {
                return
            }
            guard let data = data else {
                print("Error: \(String(describing: error))")
                semaphore.signal()
                return

            }
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let response = try decoder.decode(Debtors.self, from: data)
                print("Response: \(response)")
                
            } catch {
                print(error)
            }
            
            
            
            
            /*
            guard let data = data else {
                print(String(describing: error))
                semaphore.signal()
                return
            }
            */
            print("Data: \(String(data: data, encoding: .utf8)!)")
        }
        task.resume()
        semaphore.wait()
    }
}

