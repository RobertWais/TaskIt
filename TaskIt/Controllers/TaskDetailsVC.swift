//
//  TaskDetailsVC.swift
//  TaskIt
//
//  Created by Robert Wais on 7/30/18.
//

import UIKit

class TaskDetailsVC: UIViewController {
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var completedBtn: UIButton!
    weak var delegate: CompletedDelegate?
    var key: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let task = Constants.Data.liveTasks[key!]
        titleLbl.text = task?.title
        textView.text = task?.description
        baseView.layer.cornerRadius = 10.0
        baseView.layer.masksToBounds = true
        textView.layer.cornerRadius = 5.0
        textView.backgroundColor = baseView.backgroundColor
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.borderWidth = 1.0        
        completedBtn.setTitleColor(Constants.Colors.baseColor, for: .normal)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelBtnPressed(_ sender: Any) {
        self.delegate?.didComplete()
        UIView.animate(withDuration: 0.4, animations: {
            self.view.center = CGPoint(x: self.view.center.x, y: self.view.bounds.height+self.view.bounds.height)
            
        }) { (success) in
            self.performSegue(withIdentifier: "unwindToMapFromDetails", sender: self)
        }
    }
    @IBAction func completedBtnPressed(_ sender: Any) {
        let darkView = UIView(frame: self.view.bounds)
        darkView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        let loadWheel = LoadWheel(view: darkView)
        self.view.addSubview(darkView)
        
        completedBtn.isUserInteractionEnabled = false
        DatabaseService.deleteTask(key: key!, sender: self) { (success) in
            
            defer{
                self.completedBtn.isUserInteractionEnabled = true
            }
            if success{
                loadWheel.removeFromSuperview()
                Constants.Data.liveTasks.removeValue(forKey: self.key!)
                self.delegate?.didComplete()
                UIView.animate(withDuration: 0.4, animations: {
                    self.baseView.center = CGPoint(x: self.view.center.x, y: self.view.bounds.height+self.view.bounds.height)
                    darkView.alpha = 0.0
                }) { (success) in
                    self.performSegue(withIdentifier: "unwindToMapFromDetails", sender: self)
                }
            }else{
                Alerts.couldNotDelete(sender: self)
                darkView.removeFromSuperview()
            }
        }
        
        
        
        
        
        ///////////////////
        
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
