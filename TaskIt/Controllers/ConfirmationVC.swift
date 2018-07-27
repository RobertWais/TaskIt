//
//  ConfirmationVC.swift
//  TaskIt
//
//  Created by Robert Wais on 7/26/18.
//

import UIKit

class ConfirmationVC: UIViewController {

    weak var delegate: confirmDelegate?
    @IBOutlet weak var mainView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

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
        delegate?.didConfirm(bool: true)
        self.performSegue(withIdentifier: "unwindToMap", sender: self)
    }
    @IBAction func cancelBtnPressed(_ sender: Any) {
        delegate?.didConfirm(bool: false)
        self.performSegue(withIdentifier: "unwindToMap", sender: self)
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
