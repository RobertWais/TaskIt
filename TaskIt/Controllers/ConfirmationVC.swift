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
    
    weak var delegate: confirmDelegate?
    weak var currentShape: TaskShape?
    
    @IBOutlet weak var mainView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        enableBtns()

        // Do any additional setup after loading the view.
        
        mainView.backgroundColor = Constants.Colors.baseColor
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
        self.performSegue(withIdentifier: "unwindToMap", sender: self)
    }
    
    func disableBtns(){
        confirmBtn.isUserInteractionEnabled = false
        cancelBtn.isUserInteractionEnabled = false
    }
    
    func enableBtns(){
        confirmBtn.isUserInteractionEnabled = true
        cancelBtn.isUserInteractionEnabled = true
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
