//
//  StartCompanyVC.swift
//  TaskIt
//
//  Created by Robert Wais on 7/24/18.
//

import UIKit
import FirebaseStorage

class StartCompanyVC: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var createCompanyBtn: UIButton!
    @IBOutlet var buttons: [UIButton]!
    @IBOutlet weak var addImageBtn: UIButton!
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

    @IBAction func createCompanyPressed(_ sender: Any) {
        darkenView()
        let wheel = LoadWheel(view: view)
        
        if companyNameField.text! == "" {
            Alerts.fillOutFields(controller: self, button: createCompanyBtn)
            removeView()
            return
        }
        DatabaseService.createCompany(name: companyNameField.text!, sender: self){ (key) in
            defer {
                self.createCompanyBtn.isEnabled = true
                wheel.stopAnimating()
                self.removeView()
            }
            guard let key = key else {
                self.createCompanyBtn.isEnabled = true
                return
            }
            let imageRef = Storage.storage().reference().child("companyImages/\(key).jpg")
            StorageService.uploadImage(self.imageView.image!, reference: imageRef) { (url) in
                guard let url = url else {
                    Alerts.couldNotCreate(sender: self)
                    self.removeView()
                    return
                }
                DatabaseService.setCompanyURL(id: key, url: String(describing: url), completion: { (error) in
                    if let error = error{
                        Alerts.simpleAlert(err: error, controller: sender as! UIViewController)
                    }else{
                        wheel.stopAnimating()
                        var newId = CoreDataHelper.newCompanyId()
                        newId.id = key
                        CoreDataHelper.saveId()
                        Alerts.displayKey(uniqueID: "\(key)", sender: self, finished: {
                            self.performSegue(withIdentifier: "unwindToStartVC", sender: self)
                        })
                    }
                })
            }
        }
    }
    
    
    func darkenView(){
        let darkView = UIView(frame: self.view.bounds)
        self.view.addSubview(darkView)
        darkView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
    }
    
    func removeView(){
        let darkenView = self.view.subviews[self.view.subviews.count-1]
        UIView.animate(withDuration: 0.3, animations: {
            darkenView.alpha = 0.0
        }) { (success) in
            darkenView.removeFromSuperview()
        }
        UIView.animate(withDuration: 1.0) {
        }
    }
    
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
    
    
    func updateAll(){
        updateMainButtons()
        updateCreateBtn()
        updateField()
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

extension StartCompanyVC: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        dismiss(animated: true, completion: nil)
         let shownImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        if shownImage != nil {
            imageView.image = shownImage
            
        }
    }
    
    
    @IBAction func addImagePressed(_ sender: Any){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        self.present(imagePicker, animated: true)
    }
    
}

