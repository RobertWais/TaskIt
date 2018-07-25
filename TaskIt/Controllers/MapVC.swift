//
//  MapVC.swift
//  TaskIt
//
//  Created by Robert Wais on 7/24/18.
//

import UIKit
import FirebaseDatabase

class MapVC: UIViewController, UIScrollViewDelegate{

//    @IBOutlet weak var imageView: UIImageView!
//    @IBOutlet weak var scrollView: UIScrollView!
    
    var scrollView: UIScrollView!
    var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
//RUN TEST - Phyliss
//        let ref = Database.database().reference().child("company").child("234567")
//
//        ref.observeSingleEvent(of: .value) { (snapshot) in
//            print("Value 1: \(snapshot.value)")
//        }
//
//        let notWork = Database.database().reference().child("company").child("1234")
//
//        notWork.observeSingleEvent(of: .value, with: { (snapshot) in
//            print("Value 2: \(snapshot.value)")
//        })
        
        
        
        
        
        
        
        
        
        
        
        
//        Image size: (375.0, 530.357142857143)
//        Optional(990.0) Optional(700.0)
//        let image = UIImage(named: "testimage2.jpg")
//        print("Image height: \(image?.size.height) \(image?.size.width)")
        imageView = UIImageView(image: UIImage(named: "testimage2.jpg"))
        print("Size \(imageView.layer.frame.height)")
        
        scrollView = UIScrollView(frame: view.bounds)
        scrollView.backgroundColor = UIColor.white
        scrollView.contentSize = imageView.bounds.size
        scrollView.autoresizingMask = UIViewAutoresizing(rawValue: UIViewAutoresizing.RawValue(UInt8(UIViewAutoresizing.flexibleWidth.rawValue) | UInt8(UIViewAutoresizing.flexibleHeight.rawValue)))
        
        scrollView.addSubview(imageView)
        view.addSubview(scrollView)
        
        scrollView.delegate = self
        setZoomScale()
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
        print("Image size: \(imageView.frame.size)")
        let imageViewSize = imageView.frame.size
        let scrollViewSize = scrollView.bounds.size
        
        let verticalPadding = imageViewSize.height < scrollViewSize.height ? (scrollViewSize.height - imageViewSize.height) / 2 : 0
        let horizontalPadding = imageViewSize.width < scrollViewSize.width ? (scrollViewSize.width - imageViewSize.width) / 2 : 0
        print("Vertical: \(verticalPadding)")
        print("horizontalPadding: \(horizontalPadding)")
        
        scrollView.contentInset = UIEdgeInsets(top: verticalPadding, left: horizontalPadding, bottom: verticalPadding, right: horizontalPadding)
    }
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }

}
