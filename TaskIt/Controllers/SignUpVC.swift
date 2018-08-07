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

    weak var delegate: SignUpDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDelegate()
        updateAllUI()
        registerForKeyboardNotifications()
        scrollView.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        for field in textFields {
            field.layer.cornerRadius = field.bounds.size.height/2
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func joinBtnPressed(_ sender: Any) {
        joinBtn.isEnabled = false
        login(){ (number) in
            switch number{
            case 0 :
                Alerts.fillOutFields(controller: self, button: self.joinBtn)
            case 1:
                self.navigationController?.popViewController(animated: true)
                self.delegate?.attemptSignUp(success: false)
            case 2:
                self.navigationController?.popViewController(animated: true)
                self.delegate?.attemptSignUp(success: true)
            default:
                Alerts.fillOutFields(controller: self, button: self.joinBtn)
            }
        }
    }
}

//SignUp User wit CompanyID
extension SignUpVC {
    func login(completion: @escaping (Int)->()){
        let loading = LoadWheel(view: self.view)
        if  usernameField?.text == "" || (emailField?.text)! == ""  || (passwordField?.text)! == "" || (companyIdField?.text)! ==  ""{
            self.joinBtn.isEnabled = true
            loading.stopAnimating()
            return completion(0)
        }
            Login.signUp(email: self.emailField.text!, password: self.passwordField.text!, username: self.usernameField.text!,companyId: companyIdField.text!, controller: self) {  (url) in
                defer {
                    self.joinBtn.isEnabled = true
                    loading.stopAnimating()
                }
                
                guard let _ = url else{
                    TaskUser.setNil()
                    return completion(1)
                }
                let temp = CoreDataHelper.newCompanyId()
                temp.id = TaskUser.current.companyID
                CoreDataHelper.saveId()
                return completion(2)
        }
    }
}

extension SignUpVC {
    func updateTextFields(){
        for field in textFields {
           field.backgroundColor = Constants.Colors.baseColor
            field.layer.borderColor = UIColor.white.cgColor
            field.tintColor = UIColor.white
            field.textColor = UIColor.white
            field.layer.cornerRadius = field.frame.height/2
            field.layer.masksToBounds = true
            
            let placeholder = NSAttributedString(string: field.placeholder!, attributes: [NSAttributedStringKey.foregroundColor : UIColor.white])
            field.attributedPlaceholder = placeholder
            
        }
    }
    
    func updateJoinBtn(){
        joinBtn.backgroundColor = UIColor.white
        joinBtn.layer.cornerRadius = joinBtn.frame.height/2
        joinBtn.layer.masksToBounds = true
        joinBtn.tintColor = Constants.Colors.baseColor
        joinBtn.setTitleColor(Constants.Colors.baseColor, for: .normal)
        joinBtn.layer.borderColor = Constants.Colors.baseColor.cgColor
        joinBtn.layer.borderWidth = 2.0
    }
    
    func updateAllUI(){
        self.view.backgroundColor = UIColor.white
        updateTextFields()
        updateJoinBtn()
    }
}

extension SignUpVC: UITextFieldDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
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
                let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height +
                    50, right: 0)
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
