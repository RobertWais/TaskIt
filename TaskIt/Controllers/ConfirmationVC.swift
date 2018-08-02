//
//  ConfirmationVC.swift
//  TaskIt
//
//  Created by Robert Wais on 7/26/18.
//

import UIKit

class ConfirmationVC: UIViewController {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var titleField: UITextField!
    
    @IBOutlet weak var confirmBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    
    weak var delegate: ConfirmDelegate?
    weak var currentShape: TaskShape?
    
    @IBOutlet weak var mainView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        enableBtns()
        mainView.layer.cornerRadius = 8.0
        mainView.layer.masksToBounds = true
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func confirmBtnPressed(_ sender: Any) {
        disableBtns()
        guard let shape = currentShape else {
            enableBtns()
            return
        }
        let task = Task(shape: shape, title: (titleField?.text)!, description: textView.text, userPosted: TaskUser.current.uid, completed: "")
        DatabaseService.makeAPost(task: task.dictValue, sender: self) { (success) in
            print("Success: \(success)")
            if success {
                self.delegate?.didConfirm(bool: true)
                self.performSegue(withIdentifier: "unwindToMap", sender: self)
                return
            }
            self.enableBtns()
        }
        
    }
    @IBAction func cancelBtnPressed(_ sender: Any) {
        delegate?.didConfirm(bool: false)
        UIView.animate(withDuration: 0.4, animations: {
            self.mainView.center = CGPoint(x: self.view.center.x, y: self.view.bounds.height+self.view.bounds.height)
        }) { (success) in
            self.performSegue(withIdentifier: "unwindToMap", sender: self)
        }
    }
    
    func disableBtns(){
        confirmBtn.isUserInteractionEnabled = false
        cancelBtn.isUserInteractionEnabled = false
    }
    
    func enableBtns(){
        confirmBtn.isUserInteractionEnabled = true
        cancelBtn.isUserInteractionEnabled = true
    }
}

extension ConfirmationVC: UITextFieldDelegate {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        print("Yas")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
