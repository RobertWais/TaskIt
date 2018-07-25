//
//  StartCompanyVC.swift
//  TaskIt
//
//  Created by Robert Wais on 7/24/18.
//

import UIKit

class StartCompanyVC: UIViewController {

    @IBOutlet weak var createCompanyBtn: UIButton!
    @IBOutlet var buttons: [UIButton]!
    @IBOutlet weak var addImageBtn: UIButton!
    @IBOutlet weak var uniqueKeyLbl: UILabel!
    @IBOutlet weak var getUniqueKeyBtn: UIButton!
    @IBOutlet weak var companyNameField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        updateAll()
        companyNameField.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func uniqueKeyBtn(_ sender: Any) {
        
    }
    
    @IBAction func addImagePressed(_ sender: Any){
        
    }
    
    @IBAction func createCompanyPressed(_ sender: Any) {
        createCompanyBtn.isEnabled = false
        
        //Add company ID
        if companyNameField.text! == "" {
            Alerts.fillOutFields(controller: self, button: createCompanyBtn)
            return
        }
        DatabaseService.createCompany(uniqueId: "1234", name: companyNameField.text!, sender: self){ (success) in
            if success{
                print("Success")
                //SEGUE
            }
            self.createCompanyBtn.isEnabled = true
        }
        
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

//UPDATE UI
extension StartCompanyVC {
    func updateMainButtons(){
        for btn in buttons {
            btn.layer.cornerRadius = btn.frame.height/2
            btn.layer.masksToBounds = true
            btn.backgroundColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1.0)
        }
    }
    
    func updateCreateBtn(){
        createCompanyBtn.backgroundColor = UIColor.white
        createCompanyBtn.layer.borderColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1.0).cgColor
        createCompanyBtn.layer.borderWidth = 2.0
        createCompanyBtn.setTitleColor(UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1.0), for: UIControlState.normal)
        createCompanyBtn.layer.cornerRadius = createCompanyBtn.frame.height/2
        createCompanyBtn.layer.masksToBounds = true
    }
    
    func updateField(){
        companyNameField.backgroundColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1.0)
        companyNameField.layer.borderColor = UIColor.white.cgColor
        companyNameField.layer.borderWidth = 2.0
        companyNameField.tintColor = UIColor.white
        companyNameField.textColor = UIColor.white
        companyNameField.layer.cornerRadius = companyNameField.frame.height/2
        companyNameField.layer.masksToBounds = true
        
        let placeholder = NSAttributedString(string: companyNameField.placeholder!, attributes: [NSAttributedStringKey.foregroundColor : UIColor.white])
        companyNameField.attributedPlaceholder = placeholder
        
    }
    
    func updateLbl(){
        uniqueKeyLbl.textColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1.0)
    }
    
    func updateAll(){
        updateMainButtons()
        updateCreateBtn()
        updateField()
        updateLbl()
    }
}

extension StartCompanyVC: UITextFieldDelegate {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("yes")
        textField.resignFirstResponder()
        return true
    }

}

