//
//  OnboardVC.swift
//  TaskIt
//
//  Created by Robert Wais on 9/18/18.
//

import UIKit
import Onboard

class OnboardVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func viewDidAppear(_ animated: Bool) {
        let firstPage = OnboardingContentViewController(title: "Welcome", body: "Words", image: UIImage(named: "testImage1"), buttonText: "Skip") {
            print("Hello World")
        }
        
        let secondPage = OnboardingContentViewController(title: "Welcome2", body: "Words2", image: UIImage(named: "testimage"), buttonText: "Skip") {
            print("Hello World")
        }
        
        let onboardVC = OnboardingViewController(backgroundImage: UIImage(named: "testimage"), contents: [firstPage,secondPage])
        self.present(onboardVC!, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
