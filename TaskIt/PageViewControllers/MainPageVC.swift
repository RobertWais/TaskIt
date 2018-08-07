//
//  MainPageVC.swift
//  TaskIt
//
//  Created by Robert Wais on 8/7/18.
//

import UIKit

class MainPageVC: UIPageViewController {

    private(set) lazy var orderViewControllers: [UIViewController] = {
        return [self.newController(number: "second"),
                self.newController(number: "third")]
    }()
    
    private func newController(number: String) -> UIViewController{
        return UIStoryboard(name: "Page", bundle: .main ).instantiateViewController(withIdentifier: "\(number)Controller")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
self.new
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
       
        // Dispose of any resources that can be recreated.
    }
}

extension MainPageVC: UIPageViewControllerDataSource{
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        return nil
    }
}
