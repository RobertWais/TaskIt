//
//  StartVC.swift
//  TaskIt
//
//  Created by Robert Wais on 7/23/18.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class StartVC: UIViewController {

    //Buttons
    @IBOutlet var displayBtns: [UIButton]!
    @IBOutlet weak var startComapnyBtn: UIButton!
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    
    //Login Credentials
    @IBOutlet weak var loginCredentialsView: UIView!
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    
    //MARK: Button Listeners
    let mapVC = MapVC()
    @IBAction func loginBtnPressed(_ sender: Any) {
        signIn(){ (success) in
            if success {
              self.performSegue(withIdentifier: "fromStartToMap", sender: self)
            }
        }
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
                    let currUser = taskUser(snapshot: snapshot)
                    taskUser.setCurrent(currUser!)
                    print("current user: \(taskUser.current.username)")
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
            field.layer.borderColor = UIColor.white.cgColor
            field.backgroundColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1.0)
            field.layer.cornerRadius = field.frame.height/2
            field.layer.masksToBounds = true
            field.tintColor = UIColor.white
            field.textColor = UIColor.white
            
            
            let placeholder = NSAttributedString(string: field.placeholder!, attributes: [NSAttributedStringKey.foregroundColor : UIColor.white])
            field.attributedPlaceholder = placeholder
            
        }
    }
    
    func setViewLogin(){
       self.navigationController?.navigationBar.barTintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1.0)
        loginCredentialsView.backgroundColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1.0)
        loginCredentialsView.layer.cornerRadius = 25
        updateTextFields()
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
