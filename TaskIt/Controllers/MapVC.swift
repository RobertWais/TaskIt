//
//  MapVC.swift
//  TaskIt
//
//  Created by Robert Wais on 7/24/18.
//

import UIKit
import FirebaseDatabase

protocol confirmDelegate: class {
    func didConfirm(bool: Bool)
}

class MapVC: UIViewController, UIScrollViewDelegate, UIToolbarDelegate, confirmDelegate{
    
    let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)

//    @IBOutlet weak var imageView: UIImageView!
//    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var tempToolBar: UIToolbar!
    
    var dPadView = DirectionalPad()
    var scrollView: UIScrollView!
    var imageView: UIImageView!
    var toolbar: UIToolbar!
    var addBtn: UIButton!
    var squareButton: UIButton!
    var collapseButton: UIButton!
    var confirmBtn: UIButton!
    var revertBtn: UIButton!
    var upBtn: UIButton!
    var currentShape: TaskShape!
    var firstBarItems = [UIBarButtonItem]()
    var secondBarItems = [UIBarButtonItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dPadView = DirectionalPad(view: self.view,toolbar:  tempToolBar)
        dPadView.isHidden = true
        setScrollView()
        view.bringSubview(toFront: tempToolBar)
        setZoomScale()
        initialButtons()
        view.addSubview(dPadView)
        view.bringSubview(toFront: dPadView)
        
        
        
        
        
        
        
        
        
        // Do any additional setup after loading the view.
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
    
    override func viewWillLayoutSubviews() {
        setZoomScale()
    }
    
    func setZoomScale() {
        let zoomScale = min(self.view.bounds.size.width / (self.imageView.image?.size.width)!, self.view.bounds.size.height / (self.imageView.image?.size.height)!);
        
        if (zoomScale > 1) {
            self.scrollView.minimumZoomScale = 1;
        }
        
        self.scrollView.minimumZoomScale = zoomScale;
        self.scrollView.zoomScale = zoomScale;
        self.scrollView.maximumZoomScale = 5.0
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let imageViewSize = imageView.frame.size
        let scrollViewSize = scrollView.bounds.size
        
        let verticalPadding = imageViewSize.height < scrollViewSize.height ? (scrollViewSize.height - imageViewSize.height) / 2 : 0
        let horizontalPadding = imageViewSize.width < scrollViewSize.width ? (scrollViewSize.width - imageViewSize.width) / 2 : 0
        
        scrollView.contentInset = UIEdgeInsets(top: verticalPadding, left: horizontalPadding, bottom: verticalPadding, right: horizontalPadding)
    }
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }

}

//ALL UI except scrollView
extension MapVC {
    
    func setScrollView(){
        imageView = UIImageView(image: UIImage(named: "testimage2.jpg"))
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
