//
//  StartVC.swift
//  TaskIt
//
//  Created by Robert Wais on 7/23/18.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

protocol  SignUpDelegate: class {
    func attemptSignUp(success: Bool)
}

protocol SignInDelegate: class {
    func attemptSignIn(username: String, password: String, companyId: String)
}

protocol DarkViewDelegate: class {
    func removeDarkView()
}

class StartVC: UIViewController, SignInDelegate,DarkViewDelegate,SignUpDelegate {
    
    //Buttons
    @IBOutlet var displayBtns: [UIButton]!
    @IBOutlet weak var startCompanyBtn: UIButton!
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    var tempField: UITextField!
    
    
    func attemptSignUp(success: Bool) {
        if success {
            if self.isBeingPresented == true{
                self.dismiss(animated: false, completion: nil)
            }else{
                let storyboard = UIStoryboard(name: "MapLayout", bundle: .main)
                let mainVC = storyboard.instantiateInitialViewController()!
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.window?.rootViewController = mainVC
                appDelegate.window?.makeKeyAndVisible()
            }
        }else{
            Alerts.successButFailure(sender: self)
        }
    }
    
    override func viewDidLayoutSubviews() {
        signUpBtn.layer.cornerRadius = signUpBtn.bounds.size.height/2
        loginBtn.layer.cornerRadius = loginBtn.bounds.size.height/2
        startCompanyBtn.layer.cornerRadius = startCompanyBtn.bounds.size.height/2
    }
    
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
        darkenView.removeFromSuperview()
        if self.isBeingPresented == true{
                    self.dismiss(animated: false, completion: nil)
                }else{
                    let storyboard = UIStoryboard(name: "MapLayout", bundle: .main)
                    let mainVC = storyboard.instantiateInitialViewController()!
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.window?.rootViewController = mainVC
                    appDelegate.window?.makeKeyAndVisible()
                }
    }

   
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
    }
    @IBAction func signUpBtnPressed(_ sender: Any) {
        let VC = storyboard?.instantiateViewController(withIdentifier: "SignUpVC") as! SignUpVC
        VC.delegate = self
        navigationController?.pushViewController(VC, animated: true)
    }
    
    @IBAction func startCompanyBtnPressed(_ sender: Any) {
    }
    
    //MARK: Button Displays
    
    
    
}

//Login user
extension StartVC {
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
        
            btn.layer.cornerRadius = btn.bounds.size.height/2;
            btn.layer.masksToBounds = true
            
            btn.backgroundColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1.0)
            //            btn.backgroundColor = UIColor(red: 76, green: 217, blue: 100, alpha: 1.0)
        }
    }
    
    private func updateStartCompanyBtn(){
        startCompanyBtn.backgroundColor = UIColor.white
        startCompanyBtn.layer.borderColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1.0).cgColor
        startCompanyBtn.layer.borderWidth = 2.0
        startCompanyBtn.setTitleColor(UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1.0), for: UIControlState.normal)
    }
    
    func updateButtonUI(){
        updateAllButtonDisplay()
        updateStartCompanyBtn()
    }
    
    //LOGIN CREDENTIALS
    
    func setViewLogin(){
       self.navigationController?.navigationBar.barTintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1.0)
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
    
}
