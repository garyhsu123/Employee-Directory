//
//  DataModel.swift
//  Employee Dictionary
//
//  Created by Yu-Chun Hsu on 2022/8/13.
//

//{
//"employees" : [{
//        "uuid" : "some-uuid",
//        "full_name" : "Eric Rogers",
//        "phone_number" : "5556669870",
//        "email_address" : "erogers.demo@squareup.com",
//        "biography" : "A short biography describing the employee.",
//        "photo_url_small" : "https://some.url/path1.jpg",
//        "photo_url_large" : "https://some.url/path2.jpg",
//        "team" : "Seller",
//        "employee_type" : "FULL_TIME",
//}]}

import Foundation

struct CompanyData: Codable {
    let employees: [Employee]
}

struct Employee: Codable {
    let uuid: String
    let fullName: String
    let phoneNumber: String
    let emailAddress: String
    let biography: String
    let photoUrlSmall: URL
    let photoUrlLarge: URL
    let team: String
    let employeeType: String
}
