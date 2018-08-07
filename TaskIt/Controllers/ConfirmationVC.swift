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
        setDelegate()
        mainView.layer.cornerRadius = 8.0
        mainView.layer.masksToBounds = true
        
        let customView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 44))
        customView.backgroundColor = UIColor(red: 87/255, green: 86/255, blue: 86/255, alpha: 0.8)
        let btn = UIButton(frame: CGRect(x: customView.frame.width-(customView.frame.width/5), y: 0, width: customView.frame.width/5, height: customView.frame.height))
        btn.setTitle("Done", for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.addTarget(self, action: #selector(resignKeyboard), for: .touchUpInside)
        customView.addSubview(btn)
        textView.inputAccessoryView = customView
        
        
        
    }
    
    @objc func resignKeyboard(){
        textView.resignFirstResponder()
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
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func setDelegate(){
        titleField.delegate = self
    }
}

