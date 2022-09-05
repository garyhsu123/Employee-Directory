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
    
    private var customView: EmployeeDictionaryView = {
        var view = EmployeeDictionaryView.init(frame: UIScreen.main.bounds)
        return view
    }()
    
    override func loadView() {
        self.view = customView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.customView.tableView.dataSource = self
        self.customView.tableView.delegate = self
        try? self.network.requestJsonData(requestUrl: URL(string: "https://s3.amazonaws.com/sq-mobile-interview/employees.json"), jsonModel: CompanyData.self, completion: { response in
            // TODO: Sorting
            self.employeesData = response?.employees
            DispatchQueue.main.async {
                self.customView.tableView.reloadData()
            }
        })
    }
}

extension ViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EmployeeInfoTableViewCell", for: indexPath) as! EmployeeInfoTableViewCell
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 87
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.employeesData?.count ?? 0
    }
}

extension ViewController: UITableViewDelegate {

}

