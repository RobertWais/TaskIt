//
//  SignUpVC.swift
//  TaskIt
//
//  Created by Robert Wais on 7/23/18.
//

import UIKit
import FirebaseAuth
import FirebaseAuth.FIRUser

class SignUpVC: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var mainStackView: UIStackView!
    
    @IBOutlet var textFields: [UITextField]!
    @IBOutlet weak var companyIdField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var joinBtn: UIButton!
    
    
  
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDelegate()
        updateAllUI()
        registerForKeyboardNotifications()
        
        scrollView.delegate = self
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func joinBtnPressed(_ sender: Any) {
        print("hit")
        joinBtn.isEnabled = false
        login()
    }
}

//SignUp User wit CompanyID
extension SignUpVC {
    func login(){
        let loading = LoadWheel(view: self.view)
        if  usernameField?.text == "" || (emailField?.text)! == ""  || (passwordField?.text)! == "" || (companyIdField?.text)! ==  ""{
            Alerts.fillOutFields(controller: self, button: joinBtn)
            self.joinBtn.isEnabled = true
            return
        }
            Login.signUp(email: self.emailField.text!, password: self.passwordField.text!, username: self.usernameField.text!,companyId: companyIdField.text!, controller: self) {  (url) in
                defer {
                    self.joinBtn.isEnabled = true
                    loading.stopAnimating()
                }
                guard let url = url else{
                    return
                }
                self.performSegue(withIdentifier: "toMapVC", sender: self)
        }
    }
}

extension SignUpVC {
    func updateTextFields(){
        for field in textFields {
           field.backgroundColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1.0)
            field.layer.borderColor = UIColor.white.cgColor
            field.layer.borderWidth = 5.0
            field.tintColor = UIColor.white
            field.textColor = UIColor.white
            field.layer.cornerRadius = field.frame.height/2
            field.layer.masksToBounds = true
            
            let placeholder = NSAttributedString(string: field.placeholder!, attributes: [NSAttributedStringKey.foregroundColor : UIColor.white])
            field.attributedPlaceholder = placeholder
            
        }
    }
    func updateCompanyField(){
       
        companyIdField.backgroundColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1.0)
        companyIdField.layer.cornerRadius = companyIdField.frame.height/2
        companyIdField.layer.masksToBounds = true
        companyIdField.tintColor = UIColor.white
        companyIdField.textColor = UIColor.white
        companyIdField.layer.borderColor = UIColor.white.cgColor
        companyIdField.layer.borderWidth = 5.0
        
        
        let placeholder = NSAttributedString(string: companyIdField.placeholder!, attributes: [NSAttributedStringKey.foregroundColor : UIColor.white])
        companyIdField.attributedPlaceholder = placeholder
        
    }
    func updateJoinBtn(){
        joinBtn.backgroundColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1.0)
        joinBtn.layer.cornerRadius = joinBtn.frame.height/2
        joinBtn.layer.masksToBounds = true
        joinBtn.layer.borderColor = UIColor.white.cgColor
        joinBtn.layer.borderWidth = 5.0
    }
    
    func updateAllUI(){
        self.view.backgroundColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1.0)
        updateTextFields()
        updateJoinBtn()
        updateCompanyField()
    }
}


extension SignUpVC: UITextFieldDelegate {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        print("Yas")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func setDelegate(){
        self.emailField.delegate = self
        self.passwordField.delegate = self
        self.usernameField.delegate = self
        self.companyIdField.delegate = self
    }
    
}

extension SignUpVC {
    func registerForKeyboardNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWasShown(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyBoardWasShown(notification: NSNotification){
        if let userInfo = notification.userInfo {
            if let keyboardSize = (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height + 50, right: 0)
                scrollView.contentInset = contentInsets
                scrollView.scrollIndicatorInsets = contentInsets
            }
        }
    }
    
    
    
    @objc func keyBoardWillHide(notification: NSNotification){
        let contentInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
}
