//
//  ChooseIdVC.swift
//  TaskIt
//
//  Created by Robert Wais on 8/3/18.
//

import UIKit




class ChooseIdVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    @IBOutlet weak var mainView: UIView!
    weak var delegate: SignInDelegate?
    weak var darkdelegate: DarkViewDelegate?
     @IBOutlet weak var newCompanyField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var confirmBtn: UIButton!
    
    @IBAction func cancelBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: {
            self.darkdelegate?.removeDarkView()
        })
    }
    @IBAction func confirmBtnPressed(_ sender: Any) {
        
        //Enter Id in companies in iD
            //Check if company id matches,
                // if so update userDefaults,
                    //check if exists and if not update coredat company ids
                // if not
                    //Company does not exist
                    //return
        guard let username = self.usernameField.text,
            let password = self.passwordField.text,
            let companyId = self.newCompanyField.text else{
                //Alert Error
                return
        }
        
        UserService.switchCurrentCompany(newId: companyId, email: username, password: password, sender: self) { (success) in
            if success{
                self.dismiss(animated: true) {
                    self.delegate?.attemptSignIn(username: username, password: password, companyId: companyId)
                }
            }else{
                
            }
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Constants.Data.liveCompanyIds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "idCell", for: indexPath) as! IdTableViewCell
        cell.configurecell(companyId: Constants.Data.liveCompanyIds[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! IdTableViewCell
        guard let id = cell.companyId.text else{
            return
        }
        newCompanyField.text = id
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        registerForKeyboardNotifications()
        setDelegate()
        scrollView.delegate = self
        Constants.Data.liveCompanyIds = CoreDataHelper.retrieveIds()
        tableView.dataSource = self
        tableView.delegate = self
        print("array \(Constants.Data.liveCompanyIds)")
        // Do any additional setup after loading the view.
        
        mainView.backgroundColor = Constants.Colors.baseColor
        mainView.layer.cornerRadius = 10.0
        mainView.layer.borderWidth = 1.0
        mainView.layer.borderColor = Constants.Colors.baseColor.cgColor
        
        confirmBtn.setTitleColor(UIColor.white, for: .normal)
        cancelBtn.setTitleColor(UIColor.white, for: .normal)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


extension ChooseIdVC: UITextFieldDelegate {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("Touches began")
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("Return")
        textField.resignFirstResponder()
        return true
    }
    
    func setDelegate(){
        passwordField.delegate = self
        usernameField.delegate = self
        newCompanyField.delegate = self
    }
    
}

extension ChooseIdVC {
    func registerForKeyboardNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWasShown(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyBoardWasShown(notification: NSNotification){
        print("Yes")
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


