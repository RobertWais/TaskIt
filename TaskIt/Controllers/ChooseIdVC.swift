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
    @IBOutlet weak var newCompanyField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var confirmBtn: UIButton!
    
    var tempField: UITextField?
    weak var delegate: SignInDelegate?
    weak var darkdelegate: DarkViewDelegate?
    
    @IBAction func cancelBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: {
            self.darkdelegate?.removeDarkView()
        })
    }
    @IBAction func confirmBtnPressed(_ sender: Any) {
        guard let field = self.tempField else{
            return
        }
        field.resignFirstResponder()
        if checkFields() == true {
            guard let username = self.usernameField.text,
                let password = self.passwordField.text,
                let companyId = self.newCompanyField.text else{
                    return
            }
            let darkView = UIView(frame: self.view.bounds)
            self.view.addSubview(darkView)
            darkView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
            let loadWheel = LoadWheel(view: darkView)
            UserService.switchCurrentCompany(newId: companyId, email: username, password: password, sender: self) { (success) in
                if success{
                    darkView.removeFromSuperview()
                    self.dismiss(animated: true) {
                        self.delegate?.attemptSignIn(username: username, password: password, companyId: companyId)
                    }
                }else{
                    Alerts.companyDoesNotExist(sender: self)
                    TaskUser.setNil()
                    darkView.removeFromSuperview()
                }
            }
        }else{
            Alerts.fillOutFields(controller: self, button: confirmBtn)
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Choose Group Id"
        }
        return ""
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
        Constants.Data.liveCompanyIds = CoreDataHelper.retrieveIds()
        scrollView.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        print("array \(Constants.Data.liveCompanyIds)")
        // Do any additional setup after loading the view.
        
        mainView.backgroundColor = Constants.Colors.baseColor
        mainView.layer.cornerRadius = 10.0
        mainView.layer.borderWidth = 1.0
        mainView.layer.borderColor = Constants.Colors.baseColor.cgColor
        
        confirmBtn.setTitleColor(UIColor.white, for: .normal)
        cancelBtn.setTitleColor(UIColor.white, for: .normal)
    }
    
    
    func checkFields()->Bool{
        if usernameField.text == "" || passwordField.text == "" || newCompanyField.text == "" {
            return false
        }else{
            return true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


extension ChooseIdVC: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        tempField = textField
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        print("ues")
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


