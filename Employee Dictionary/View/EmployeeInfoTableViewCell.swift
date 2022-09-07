//
//  EmployeeInfoTableViewCell.swift
//  Employee Dictionary
//
//  Created by Yu-Chun Hsu on 2022/8/14.
//

import UIKit

class EmployeeInfoTableViewCell: UITableViewCell {
    
    var didClickEmailClosure: ((_ alertController: UIAlertController)->())?
    var didClickPhoneClosure: ((_ alertController: UIAlertController)->())?
    var phoneNumber: String?
    var email: String?
    
    let headShotImageView: UIImageView = {
        var view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    let name: UILabel = {
        var view = UILabel()
        view.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        return view
    }()
    
    let team: UILabel = {
        var view = UILabel()
        view.font = UIFont.systemFont(ofSize: 16, weight: .light)
        return view
    }()
    
    let emailIcon: UIImageView = {
        var view = UIImageView()
        view.image = UIImage(named: "Email")
        view.isUserInteractionEnabled = true
        return view
    }()
    
    let phoneIcon: UIImageView = {
        var view = UIImageView()
        view.image = UIImage(named: "Phone")
        view.isUserInteractionEnabled = true
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        customInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func customInit() {
        self.contentView.addSubview(self.headShotImageView)
        self.headShotImageView.translatesAutoresizingMaskIntoConstraints = false
        self.headShotImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        self.headShotImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16).isActive = true
        self.headShotImageView.widthAnchor.constraint(equalTo: self.headShotImageView.heightAnchor).isActive = true
        self.headShotImageView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 65/87).isActive = true
        
        self.contentView.addSubview(self.name)
        self.name.translatesAutoresizingMaskIntoConstraints = false
        self.name.leadingAnchor.constraint(equalTo: self.headShotImageView.trailingAnchor, constant: 10).isActive = true
        NSLayoutConstraint(item: self.name, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 0.68, constant: 0).isActive = true
        
        self.contentView.addSubview(self.team)
        self.team.translatesAutoresizingMaskIntoConstraints = false
        self.team.leadingAnchor.constraint(equalTo: self.name.leadingAnchor).isActive = true
        self.team.topAnchor.constraint(equalTo: self.name.bottomAnchor, constant: 5).isActive = true
        
        self.emailIcon.translatesAutoresizingMaskIntoConstraints = false
        self.emailIcon.widthAnchor.constraint(equalTo: self.emailIcon.heightAnchor).isActive = true
        self.emailTap = UITapGestureRecognizer(target: self, action: #selector(clickIcogesture(gesture:)))
        self.emailIcon.addGestureRecognizer(self.emailTap!)
        
        self.phoneIcon.translatesAutoresizingMaskIntoConstraints = false
        self.phoneIcon.widthAnchor.constraint(equalTo: self.phoneIcon.heightAnchor).isActive = true
        self.phoneTap = UITapGestureRecognizer(target: self, action: #selector(clickIcogesture(gesture:)))
        self.phoneIcon.addGestureRecognizer(self.phoneTap!)
        
        let stackView = UIStackView(arrangedSubviews: [self.emailIcon, self.phoneIcon])
        stackView.axis = .horizontal
        stackView.spacing = 15
        self.contentView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -36).isActive = true
        NSLayoutConstraint(item: stackView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.18, constant: 0).isActive = true
        stackView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 30/87).isActive = true
        
        self.emailIcon.heightAnchor.constraint(equalTo: stackView.heightAnchor).isActive = true
        self.team.trailingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: -10).isActive = true
    }
    
    private var emailTap: UITapGestureRecognizer?
    private var phoneTap: UITapGestureRecognizer?

    // FIXME: The photos are wrong in first launch.
    var employeeProfileViewModel: EmployeeProfileViewModel? {
        didSet {
            self.name.text = employeeProfileViewModel?.name
            self.team.text = employeeProfileViewModel?.team
            self.phoneNumber = employeeProfileViewModel?.phone
            self.email = employeeProfileViewModel?.email
            
            guard let url = self.employeeProfileViewModel?.photoUrlSmall, let uuid = self.employeeProfileViewModel?.uuid else {
                return
            }
            
            if let image = self.employeeProfileViewModel?.fileModel?.getPhoto(with: url, uuid: uuid) {
                self.headShotImageView.image = image
            } else {
                
                DispatchQueue.global().async {
                    if let imageData = NSData(contentsOf: url) as? Data, let image = UIImage(data: imageData) {
                        self.employeeProfileViewModel?.fileModel?.savePhoto(with: image, imageUrl: url, uuid: uuid)
                        DispatchQueue.main.async {
                            self.headShotImageView.image = image
                        }
                    }
                }
            }
        }
    }
    
    @objc func clickIcogesture(gesture: UITapGestureRecognizer) {
        
        
        
        if gesture.view == emailIcon, let email = self.email, let didClickEmailClosure = self.didClickEmailClosure {
            let alertVC = UIAlertController(title: "Send Email to ", message: "", preferredStyle: .actionSheet)
            alertVC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alertVC.addAction(UIAlertAction(title: email, style: .default, handler: { _ in
                UIApplication.shared.open(URL(string: "mailto://\(email)")!)
            }))
            didClickEmailClosure(alertVC)
        }
        else if gesture.view == phoneIcon, let phoneNumber = self.phoneNumber, let didClickPhoneClosure = self.didClickEmailClosure {
            let alertVC = UIAlertController(title: "Make a phone call to", message: "", preferredStyle: .actionSheet)
            alertVC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alertVC.addAction(UIAlertAction(title: phoneNumber, style: .default, handler: { _ in
                UIApplication.shared.open(URL(string: "tel://\(phoneNumber)")!)
            }))
            didClickPhoneClosure(alertVC)
        }
    }

}
