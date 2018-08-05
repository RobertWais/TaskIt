//
//  StartVC.swift
//  TaskIt
//
//  Created by Robert Wais on 7/23/18.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase


protocol SignInDelegate: class {
    func attemptSignIn(username: String, password: String, companyId: String)
}

protocol DarkViewDelegate: class {
    func removeDarkView()
}

class StartVC: UIViewController, SignInDelegate,DarkViewDelegate {
    func removeDarkView() {
        let darkenView = self.view.subviews[self.view.subviews.count-1]
        UIView.animate(withDuration: 0.3, animations: {
            darkenView.alpha = 0.0
        }, completion: { (success) in
            darkenView.removeFromSuperview()
        })
    }
    
    
    func attemptSignIn(username: String, password: String, companyId: String) {
        let darkenView = self.view.subviews[self.view.subviews.count-1]
        print("username: \(username)")
        print("password: \(password)")
        darkenView.removeFromSuperview()
        signInModal(username: username, password: password, completion: { (success) in
            if success {
                self.performSegue(withIdentifier: "fromStartToMap", sender: self)
            }
        })
    }

    //Buttons
    @IBOutlet var displayBtns: [UIButton]!
    @IBOutlet weak var startComapnyBtn: UIButton!
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    
    //Login Credentials
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet var textFields: [UITextField]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setDelegate()
        updateButtonUI()
        setViewLogin()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Button Listeners
//    let mapVC = MapVC()
    @IBAction func loginBtnPressed(_ sender: Any) {
        
        let darkView = UIView(frame: self.view.bounds)
        self.view.addSubview(darkView)
        darkView.backgroundColor = UIColor.black.withAlphaComponent(0.5)

        let modalVC = storyboard?.instantiateViewController(withIdentifier: "ChooseId") as! ChooseIdVC
        modalVC.modalPresentationStyle = .overCurrentContext
        modalVC.delegate = self
        modalVC.darkdelegate = self 

        present(modalVC, animated: true, completion: nil)
        
        
//        let darkenView = self.view.subviews[self.view.subviews.count-1]
//        UIView.animate(withDuration: 1.0, animations: {
//            darkenView.alpha = 0.0
//        }) { (success) in
//            darkenView.removeFromSuperview()
//        }
        
//        signIn(){ (success) in
//            if success {
//              self.performSegue(withIdentifier: "fromStartToMap", sender: self)
//            }
//        }
    }
    @IBAction func signUpBtnPressed(_ sender: Any) {
    }
    
    @IBAction func startCompanyBtnPressed(_ sender: Any) {
    }
    
    //MARK: Button Displays
    
    
    
}

//Login user
extension StartVC {
    func signIn(completion: @escaping (Bool)->()){
        Auth.auth().signIn(withEmail: usernameField.text!, password: passwordField.text!) { (user, error) in
            if let error = error {
                Alerts.simpleAlert(err: error, controller: self)
                completion(false)
                return
            }
            let ref = Database.database().reference().child("users").child((Auth.auth().currentUser?.uid)!)
                
                ref.observeSingleEvent(of: .value, with: { (snapshot) in
                    let currUser = TaskUser(snapshot: snapshot)
                    TaskUser.setCurrent(currUser!)
                    print("current user: \(TaskUser.current.username)")
                    completion(true)
                    return
                })
            }
    }
    func signInModal(username: String , password: String, completion: @escaping (Bool)->()){
        Auth.auth().signIn(withEmail: username, password: password) { (user, error) in
            if let error = error {
                Alerts.simpleAlert(err: error, controller: self)
                completion(false)
                return
            }
            let ref = Database.database().reference().child("users").child((Auth.auth().currentUser?.uid)!)
            
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                let currUser = TaskUser(snapshot: snapshot)
                TaskUser.setCurrent(currUser!)
                print("current user: \(TaskUser.current.username)")
                completion(true)
                return
            })
        }
    }
}

//MARK: UI Elements
extension StartVC {
    
    
    //BUTTON ELEMENTS
    private func updateAllButtonDisplay(){
        for btn in displayBtns {
            btn.layer.cornerRadius = btn.frame.height/2
            btn.layer.masksToBounds = true
            btn.backgroundColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1.0)
            //            btn.backgroundColor = UIColor(red: 76, green: 217, blue: 100, alpha: 1.0)
        }
    }
    
    private func updateStartCompanyBtn(){
        startComapnyBtn.backgroundColor = UIColor.white
        startComapnyBtn.layer.borderColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1.0).cgColor
        startComapnyBtn.layer.borderWidth = 2.0
        startComapnyBtn.setTitleColor(UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1.0), for: UIControlState.normal)
    }
    
    func updateButtonUI(){
        updateAllButtonDisplay()
        updateStartCompanyBtn()
    }
    
    //LOGIN CREDENTIALS
    
    func updateTextFields(){
        
        for field in textFields {
            field.layer.borderWidth = 2.0
            field.layer.borderColor = Constants.Colors.baseColor.cgColor
            field.backgroundColor = UIColor.white
            field.layer.cornerRadius = field.frame.height/2
            field.layer.masksToBounds = true
            field.tintColor = Constants.Colors.baseColor
            field.textColor = Constants.Colors.baseColor
            
            
            let placeholder = NSAttributedString(string: field.placeholder!, attributes: [NSAttributedStringKey.foregroundColor : Constants.Colors.baseColor])
            field.attributedPlaceholder = placeholder
            
        }
    }
    
    func setViewLogin(){
       self.navigationController?.navigationBar.barTintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1.0)
        updateTextFields()
    }
    
    @IBAction func unwindWithSegue(_ segue: UIStoryboardSegue){
    }
    
}

extension StartVC: UITextFieldDelegate {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func setDelegate(){
        self.passwordField.delegate = self
        self.usernameField.delegate = self
    }
    
}
