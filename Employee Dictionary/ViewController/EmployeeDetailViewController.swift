//
//  EmployeeDetailViewController.swift
//  Employee Dictionary
//
//  Created by Yu-Chun Hsu on 2022/9/16.
//

import UIKit

class EmployeeDetailViewController: UIViewController {

    private var imageView: UIImageView = {
        var view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private var nameLabel: UILabel = {
       var view = UILabel()
        view.font = UIFont.systemFont(ofSize: 24, weight: .medium)
        view.textAlignment = .center
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
    
    private var teamLabel: UILabel = {
       var view = UILabel()
        view.font = UIFont.systemFont(ofSize: 22, weight: .light)
        view.textAlignment = .center
        return view
    }()
    
    private var biographyLabel: UILabel = {
       var view = UILabel()
        view.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        view.textAlignment = .center
        view.lineBreakMode = .byWordWrapping
        view.numberOfLines = 0
        return view
    }()
    
    var employeeProfileViewModel: EmployeeProfileViewModel? {
        didSet {
            updateUI()
        }
    }
    var fileModel: FileModel?
    
    private var emailTap: UITapGestureRecognizer?
    private var phoneTap: UITapGestureRecognizer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = imageView.bounds.height/2
    }
    
    func setupUI() {
        self.view.backgroundColor = .systemBackground
        self.view.addSubview(imageView)
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        self.imageView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 187/390).isActive = true
        self.imageView.widthAnchor.constraint(equalTo: self.imageView.heightAnchor).isActive = true
        self.imageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        NSLayoutConstraint(item: self.imageView, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 151.5/395, constant: 0).isActive = true
        
        let vStackView = UIStackView(arrangedSubviews: [self.nameLabel, self.teamLabel])
        vStackView.axis = .vertical
        vStackView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(vStackView)
        vStackView.topAnchor.constraint(equalTo: self.imageView.bottomAnchor, constant: 64).isActive = true
        vStackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        vStackView.heightAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 65/390).isActive = true
        
        self.emailIcon.translatesAutoresizingMaskIntoConstraints = false
        self.emailIcon.widthAnchor.constraint(equalTo: self.emailIcon.heightAnchor).isActive = true
        self.emailTap = UITapGestureRecognizer(target: self, action: #selector(clickIcogesture(gesture:)))
        self.emailIcon.addGestureRecognizer(self.emailTap!)
        
        self.phoneIcon.translatesAutoresizingMaskIntoConstraints = false
        self.phoneIcon.widthAnchor.constraint(equalTo: self.phoneIcon.heightAnchor).isActive = true
        self.phoneTap = UITapGestureRecognizer(target: self, action: #selector(clickIcogesture(gesture:)))
        self.phoneIcon.addGestureRecognizer(self.phoneTap!)
        
        let hStackView = UIStackView(arrangedSubviews: [self.emailIcon, self.phoneIcon])
        hStackView.axis = .horizontal
        hStackView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(hStackView)
        hStackView.topAnchor.constraint(equalTo: vStackView.bottomAnchor, constant: 22).isActive = true
        hStackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        hStackView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 90/390).isActive = true
        
        self.emailIcon.widthAnchor.constraint(equalTo: hStackView.widthAnchor, multiplier: 35/90).isActive = true
        self.phoneIcon.widthAnchor.constraint(equalTo: self.emailIcon.widthAnchor).isActive = true
        
        self.biographyLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.biographyLabel)
        self.biographyLabel.topAnchor.constraint(equalTo: hStackView.bottomAnchor, constant: 22).isActive = true
        self.biographyLabel.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 334/390).isActive = true
        self.biographyLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
    }
    
    func updateUI() {
        
        self.nameLabel.text = self.employeeProfileViewModel?.name
        self.teamLabel.text = self.employeeProfileViewModel?.team
        self.biographyLabel.text = self.employeeProfileViewModel?.biography
        self.imageView.image = UIImage(named: "Default Avatar")
        
        self.employeeProfileViewModel?.getPhoto(with: self.employeeProfileViewModel?.photoUrlLarge, completion: { [weak self] image in
            DispatchQueue.main.async {
                self?.imageView.image = image
            }
        })
    }

    @objc func clickIcogesture(gesture: UITapGestureRecognizer) {
        
        
        
        if gesture.view == emailIcon, let email = self.employeeProfileViewModel?.email {
            let alertVC = UIAlertController(title: "Send Email to ", message: "", preferredStyle: .actionSheet)
            alertVC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alertVC.addAction(UIAlertAction(title: email, style: .default, handler: { _ in
                UIApplication.shared.open(URL(string: "mailto://\(email)")!)
            }))
            
            self.present(alertVC, animated: true)
        }
        else if gesture.view == phoneIcon, let phoneNumber = self.employeeProfileViewModel?.phone {
            UIApplication.shared.open(URL(string: "tel://\(phoneNumber)")!)
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


