//
//  MapVC.swift
//  TaskIt
//
//  Created by Robert Wais on 7/24/18.
//

import UIKit
import FirebaseDatabase

protocol ConfirmDelegate: class {
    func didConfirm(bool: Bool)
}

protocol CompletedDelegate: class {
    func didComplete()
}

class MapVC: UIViewController, UIScrollViewDelegate, UIToolbarDelegate, ConfirmDelegate{
    
    let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    @IBOutlet weak var tempToolBar: UIToolbar!
    
    var keepGoing = 0
    var freeze = 0
    var freezeView: UIView!
    var dPadView = DirectionalPad()
    var scrollView: UIScrollView!
    var imageView: UIImageView!
    var toolbar: UIToolbar!
    var addBtn: UIButton!
    var squareButton: UIButton!
    var circleButton: UIButton!
    var rectangleButton: UIButton!
    var collapseButton: UIButton!
    var confirmBtn: UIButton!
    var revertBtn: UIButton!
    var freezeBtn: UIButton!
    var currentShape: TaskShape!
    var firstBarItems = [UIBarButtonItem]()
    var secondBarItems = [UIBarButtonItem]()
    var baseImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Controller being pressented: \(self.isBeingPresented)")
        tempToolBar.layer.masksToBounds = true
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1.0)
        setUpAddBtn()
        addBtn.isUserInteractionEnabled = false
        let wheel = LoadWheel(view: self.view)
        StorageService.getImage { (image) in
            wheel.stopAnimating()
            if image == nil {
                print("Image nil")
            }else{
                self.addBtn.isUserInteractionEnabled = true
                self.baseImage = image
                self.dPadView = DirectionalPad(view: self.view,toolbar:  self.tempToolBar)
                self.dPadView.isHidden = true
                self.setScrollView()
                
                self.view.bringSubview(toFront: self.tempToolBar)
                self.setZoomScale()
                self.initialButtons()
                self.view.addSubview(self.dPadView)
                self.view.bringSubview(toFront: self.dPadView)
                self.view.bringSubview(toFront: self.addBtn)
                
                DatabaseService.retrieveTasks(){  (Task,num) in
                    guard let task = Task else{
                        return
                    }
                    task.delegate = self
                    switch num {
                    case 0:
                        DispatchQueue.main.async {
                            self.imageView.addSubview(task.shape)
                            self.imageView.bringSubview(toFront: task.shape)
                        }
                    case 1:
                        DispatchQueue.main.async {
                            let removeTask = Constants.Data.liveTasks.removeValue(forKey: task.key)
                            removeTask?.shape.removeFromSuperview()
                        }
                    case 3:
                        print("Updating")
                    //updated
                    default:
                        print("Eror")
                        //Error
                    }
                }
            }
        }
    }
        
    
    @IBAction func signOutBtnPressed(_ sender: Any) {
        Login.signOut()
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let mainVC = storyboard.instantiateInitialViewController()!
        self.present(mainVC, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillLayoutSubviews() {
        setZoomScale()
    }
    
    func setZoomScale() {
        if self.imageView != nil {
            let zoomScale = min(self.view.bounds.size.width / (self.imageView.image?.size.width)!, self.view.bounds.size.height / (self.imageView.image?.size.height)!);
            
            if (zoomScale > 1) {
                self.scrollView.minimumZoomScale = 1;
            }
            
            self.scrollView.minimumZoomScale = zoomScale;
            self.scrollView.zoomScale = zoomScale;
            self.scrollView.maximumZoomScale = 5.0
        }
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let imageViewSize = imageView.frame.size
        let scrollViewSize = scrollView.bounds.size

        let verticalPadding = imageViewSize.height < scrollViewSize.height ? (scrollViewSize.height - (navigationController?.navigationBar.frame.height)! - imageViewSize.height) / 2 : 0
        let horizontalPadding = imageViewSize.width < scrollViewSize.width ? (scrollViewSize.width - imageViewSize.width) / 2 : 0


        scrollView.contentInset = UIEdgeInsets(top: verticalPadding + (navigationController?.navigationBar.frame.height)!, left: horizontalPadding, bottom: verticalPadding, right: horizontalPadding)
    }
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }

}

//ALL UI except scrollView
extension MapVC {
    
    func setScrollView(){
        imageView = UIImageView(image: baseImage!)
        imageView.isUserInteractionEnabled = true
        imageView.isMultipleTouchEnabled = true
        scrollView = UIScrollView(frame: view.bounds)
        scrollView.backgroundColor = UIColor.white
        //Freezes bottom
        scrollView.contentSize = imageView.bounds.size
        scrollView.autoresizingMask = UIViewAutoresizing(rawValue: UIViewAutoresizing.RawValue(UInt8(UIViewAutoresizing.flexibleWidth.rawValue) | UInt8(UIViewAutoresizing.flexibleHeight.rawValue)))
        
        scrollView.addSubview(imageView)
        view.addSubview(scrollView)
        scrollView.delegate = self
    }
}
