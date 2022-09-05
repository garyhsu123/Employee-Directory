//
//  ViewController.swift
//  Employee Dictionary
//
//  Created by Yu-Chun Hsu on 2022/8/13.
//

import UIKit

class ViewController: UIViewController {

    lazy var network = Network()
    var employeesData: [Employee]?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.customView.tableView.dataSource = self
        self.customView.tableView.delegate = self
        try? self.network.requestJsonData(requestUrl: URL(string: "https://s3.amazonaws.com/sq-mobile-interview/employees.json"), jsonModel: CompanyData.self, completion: { response in
            // TODO: Sorting
            self.employeesData = response?.employees
            DispatchQueue.main.async {
            }
        })
    }
    }


}

