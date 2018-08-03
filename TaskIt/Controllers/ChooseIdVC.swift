//
//  ChooseIdVC.swift
//  TaskIt
//
//  Created by Robert Wais on 8/3/18.
//

import UIKit




class ChooseIdVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
   
    
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
        guard let username = self.usernameField.text,
            let password = self.passwordField.text,
            let companyId = self.newCompanyField.text else{
                //Alert Error
                return
        }
        dismiss(animated: true) {
            self.delegate?.attemptSignIn(username: username, password: password, companyId: companyId)
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
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func setDelegate(){
        passwordField.delegate = self
        usernameField.delegate = self
        newCompanyField.delegate = self
    }
    
}


