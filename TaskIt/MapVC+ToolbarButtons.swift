//
//  MapVC+ToolbarButtons.swift
//  TaskIt
//
//  Created by Robert Wais on 7/25/18.
//

import Foundation
import UIKit

//▲▼✔

extension MapVC {
    //UI For Buttons
    func initialButtons(){
        initialSet()
        secondSet()
        setUpAddBtn()
    }
    
    func initialSet(){
        ////Collapse Button
        collapseButton = getToolBarButton(function: #selector(collapseBar), color: Constants.Colors.safeRed, cRadius: tempToolBar.frame.height/4, attrString: NSAttributedString(string: "-", attributes: [NSAttributedStringKey.foregroundColor : UIColor.white,
                                                                                                                                                                                                           NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 20.0)]))
        collapseButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        let collapseButtonItem = UIBarButtonItem(customView: collapseButton)
        collapseButtonItem.customView?.frame = CGRect(x: 0, y: 0, width:  tempToolBar.frame.height/2, height: tempToolBar.frame.height/2)
        
        
        //Square Button
        squareButton = getToolBarButton(function: #selector(addSquare), color: UIColor.black, cRadius: tempToolBar.frame.height/4, attrString: NSAttributedString(string: "☐", attributes: [NSAttributedStringKey.foregroundColor : UIColor.white,
                                                                                                                                                                                              NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 20.0)]))
        let squareButtonItem = UIBarButtonItem(customView: squareButton)
        squareButtonItem.customView?.frame = CGRect(x: 0, y: 0, width:  tempToolBar.frame.height/2, height: tempToolBar.frame.height/2)
        firstBarItems = [squareButtonItem,spacer,spacer, collapseButtonItem]
        tempToolBar.setItems(firstBarItems, animated: true)
        tempToolBar.isHidden = true
        tempToolBar.alpha = 0.9
    }
    
    func setUpAddBtn(){
        addBtn = UIButton(frame: CGRect(x: (view.frame.width - 100), y:(view.frame.height - 100), width: 75, height: 75))
        //Show toolbar
        addBtn.addTarget(self, action: #selector(showToolBar), for: UIControlEvents.touchUpInside)
        addBtn.setAttributedTitle(NSAttributedString(string: "+", attributes: [NSAttributedStringKey.foregroundColor : UIColor.white,NSAttributedStringKey.font: UIFont.systemFont(ofSize: 40.0)]), for: .normal)
        addBtn.setTitleColor(UIColor.white, for: UIControlState.normal)
        addBtn.layer.cornerRadius = addBtn.layer.frame.width/2
        addBtn.layer.masksToBounds = true
        addBtn.backgroundColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 0.9)
        view.addSubview(addBtn)
        view.bringSubview(toFront: addBtn)
    }
    
    func secondSet(){
        
        let downBtn = getToolBarButton(function: #selector(scaleSmaller), color: Constants.Colors.baseColor, cRadius: tempToolBar.frame.height/4, attrString: NSAttributedString(string: "▼", attributes: [NSAttributedStringKey.foregroundColor : UIColor.white,
                                                                                                                                                                                                         NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 20.0)]))
        
        let downBtnItem = UIBarButtonItem(customView: downBtn)
        downBtnItem.customView?.frame = CGRect(x: 0, y: 0, width:  tempToolBar.frame.width/4, height: tempToolBar.frame.height/2)
        upBtn = getToolBarButton(function: #selector(scaleLarger), color: Constants.Colors.baseColor, cRadius: tempToolBar.frame.height/4, attrString: NSAttributedString(string: "▲", attributes: [NSAttributedStringKey.foregroundColor : UIColor.white,
                                                                                                                                                                                                           NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 20.0)]))
        let upBtnItem = UIBarButtonItem(customView: upBtn)
        upBtnItem.customView?.frame = CGRect(x: 0, y: 0, width:  tempToolBar.frame.width/4, height: tempToolBar.frame.height/2)
        ////Confirm Button
        confirmBtn = getToolBarButton(function: #selector(confirmShape), color: Constants.Colors.baseColor, cRadius: tempToolBar.frame.height/4,attrString: NSAttributedString(string: "✓", attributes: [NSAttributedStringKey.foregroundColor : UIColor.white ,NSAttributedStringKey.font: UIFont.systemFont(ofSize: 20.0)]))
        
        let confirmButtonItem = UIBarButtonItem(customView: confirmBtn)
        confirmButtonItem.customView?.frame = CGRect(x: 0, y: 0, width:  tempToolBar.frame.height/2, height: tempToolBar.frame.height/2)
        
        
        //RevertBtn
        revertBtn = getToolBarButton(function: #selector(collapseSecondToolBar), color: Constants.Colors.safeRed, cRadius: tempToolBar.frame.height/4, attrString: NSAttributedString(string: "-", attributes: [NSAttributedStringKey.foregroundColor : UIColor.white,NSAttributedStringKey.font: UIFont.systemFont(ofSize: 20.0)]))
        
        let revertButtonItem = UIBarButtonItem(customView: revertBtn)
        revertButtonItem.customView?.frame = CGRect(x: 0, y: 0, width:  tempToolBar.frame.height/2, height: tempToolBar.frame.height/2)
        secondBarItems = [revertButtonItem,spacer,upBtnItem,spacer,downBtnItem,spacer,confirmButtonItem]
        
        
        
        ///SET Functions
        
        dPadView.upBtn.addTarget(self, action: #selector(extendUp), for: .touchUpInside)
        dPadView.downBtn.addTarget(self, action: #selector(extendDown), for: .touchUpInside)
        dPadView.leftBtn.addTarget(self, action: #selector(extendLeft), for: .touchUpInside)
        dPadView.rightBtn.addTarget(self, action: #selector(extendRight), for: .touchUpInside)
        
        dPadView.invertUpBtn.addTarget(self, action: #selector(invertUp), for: .touchUpInside)
        dPadView.invertDownBtn.addTarget(self, action: #selector(invertDown), for: .touchUpInside)
        dPadView.invertLeftBtn.addTarget(self, action: #selector(invertLeft), for: .touchUpInside)
        dPadView.invertRightBtn.addTarget(self, action: #selector(invertRight), for: .touchUpInside)
    }
    
    
    //Functions that Buttons Call
    @objc func showToolBar(){
        tempToolBar.alpha = 0.0
        tempToolBar.isHidden = false
        UIView.animate(withDuration: 0.6, animations: {
            self.addBtn.alpha = 0.0
            self.tempToolBar.alpha = 0.9
            self.addBtn.center.x = (self.view.frame.width)+(self.addBtn.frame.width/2)
        }) { (success) in
            if success{
                self.addBtn.isHidden = true
            }
        }
    }
    
    @objc func collapseBar(){
        addBtn.isHidden = false
        UIView.animate(withDuration: 0.6, animations: {
            self.addBtn.alpha = 0.9
            self.tempToolBar.alpha = 0.0
            self.addBtn.center.x = (self.view.frame.width - 50)
        }) { (success) in
            if success{
                self.tempToolBar.isHidden = true
            }
        }
        
    }
    
    //Add Square and change toolbar to second set
    @objc func addSquare(){
        var startingY = self.collapseButton.center.y
        currentShape = TaskShape()
        imageView.addSubview(currentShape)
        imageView.bringSubview(toFront: currentShape)
        UIView.animate(withDuration: 0.3, animations: {
            self.collapseButton.center.y = self.collapseButton.center.y+100
            self.squareButton.center.y = self.squareButton.center.y+100
        }) { (success) in
            self.tempToolBar.setItems(self.secondBarItems, animated: true)
            var confirmPos =  self.confirmBtn.center.x
            var revertPos = self.revertBtn.center.x
            self.confirmBtn.center.x = self.confirmBtn.center.x + 100
            self.revertBtn.center.x = self.revertBtn.center.x - 100
            UIView.animate(withDuration: 0.3, animations: {
                self.confirmBtn.center.x = confirmPos
                self.revertBtn.center.x = revertPos
                self.dPadView.isHidden = false
            })
        }
    }
    
    @objc func scaleLarger(){
         currentShape.transform = (currentShape.transform.scaledBy(x: 1.1, y: 1.1))
    }
    
    @objc func scaleSmaller(){
        currentShape.transform = (currentShape.transform.scaledBy(x: 0.9, y: 0.9))

    }
    
    
    //MARK: RETURN CALLS
    
    @objc func confirmShape(){
        let modalVC = storyboard?.instantiateViewController(withIdentifier: "ConfirmationVC") as! ConfirmationVC
        modalVC.delegate = self
        modalVC.modalPresentationStyle = .overCurrentContext
        present(modalVC, animated: true, completion: nil)
    }
    
    func didConfirm(bool: Bool){
        if bool {
            print("true")
            currentShape.isUserInteractionEnabled = false
            imageView.addSubview(currentShape)
            //Change when reading from firebase
            collapseEditBar()
            
        }else{
            currentShape.isUserInteractionEnabled = true
        }
    }
    
    @IBAction func unwindWithSegue(_ segue: UIStoryboardSegue){
        print("returning")
        
    }
    
    @objc func extendRight(){
        currentShape.frame =  CGRect(x: currentShape.frame.minX, y: currentShape.frame.minY, width: currentShape.frame.width+2, height: currentShape.frame.height)
    }
    
    
    
    
    
    @objc func extendUp(){
        
        //Save this
//        currentShape.setAnchorPoint(CGPoint(x: 0.5, y: 1))
// ***       currentShape.center.y += currentShape.bounds.height / 2
//        currentShape.transform = currentShape.transform.scaledBy(x: 1, y: 1.1)
//        currentShape.setAnchorPoint(CGPoint(x: 0.5, y: 0.5))
//        currentShape.setNeedsDisplay()
//        view.reloadInputViews()
        
//        print("Current shape: \(currentShape.bounds.minX) \(currentShape.bounds.maxX)")

//
//        return
        //CHANGE
        
        currentShape.bounds =  CGRect(x: currentShape.bounds.minX, y: currentShape.bounds.minY, width: currentShape.bounds.width, height: currentShape.bounds.height+2)
        
        let radians = atan2f(currentShape.transform.b, currentShape.transform.a);
        var xValue = -sin(2*CGFloat.pi/3)
        var yValue =  cos(2*CGFloat.pi/3)
        print("X value: \(xValue)")
        print("Y value: \(yValue)")
        currentShape.center = CGPoint(x: currentShape.center.x-xValue, y: currentShape.center.y-yValue )
        print("Center: \(currentShape.center)")
//        print("Current bounds: \(currentShape.bounds)")
//        print("Full frame: \(currentShape.frame)")
//        print("Frame: \(currentShape.frame.minX) \(currentShape.frame.minY) \(currentShape.frame.width) \(currentShape.frame.height)")
//        print("Bounds: \(currentShape.bounds)")
//        currentShape.frame = CGRect(x: initialX, y: initialY, width: self.currentShape.frame.width, height: self.currentShape.frame.height)
//        print("Result frame: \(currentShape.frame)")
//        currentShape.transform = (currentShape?.transform.scaledBy(x: 1.0, y: 1.1))!
    }
    
    
    
    
    
    
    
    
    
    
    
    @objc func extendDown(){
        
        currentShape.setAnchorPoint(CGPoint(x: 0.5, y: 0))
//        currentShape.center.y -= currentShape.bounds.height / 2
        currentShape.transform = currentShape.transform.scaledBy(x: 1, y: 1.1)
        
        return
        
        currentShape.frame =  CGRect(x: currentShape.frame.minX, y: currentShape.frame.minY, width: currentShape.frame.width, height: currentShape.frame.height+2)
    }
    @objc func extendLeft(){
        currentShape.frame =  CGRect(x: currentShape.frame.minX-2, y: currentShape.frame.minY, width: currentShape.frame.width+2, height: currentShape.frame.height)
    }
    
    @objc func invertRight(){
        currentShape.frame =  CGRect(x: currentShape.frame.minX, y: currentShape.frame.minY, width: currentShape.frame.width-2, height: currentShape.frame.height)
    }
    @objc func invertUp(){
        
        currentShape.frame =  CGRect(x: currentShape.frame.minX, y: currentShape.frame.minY+2, width: currentShape.frame.width, height: currentShape.frame.height-2)
        //        currentShape.transform = (currentShape?.transform.scaledBy(x: 1.0, y: 1.1))!
    }
    @objc func invertDown(){
        
        currentShape.frame =  CGRect(x: currentShape.frame.minX, y: currentShape.frame.minY, width: currentShape.frame.width, height: currentShape.frame.height-2)
    }
    @objc func invertLeft(){
        currentShape.frame =  CGRect(x: currentShape.frame.minX+2, y: currentShape.frame.minY, width: currentShape.frame.width-2, height: currentShape.frame.height)
    }
    
    //Collapse toolbar and if currentShape is already confirmed, dont move it
    //Will change later
    @objc func collapseSecondToolBar(){
        collapseEditBar()
    }
    
    private func getToolBarButton(function: Selector,color: UIColor, cRadius: CGFloat, attrString: NSAttributedString ) -> UIButton{
        let button = UIButton(type: .system)
        button.addTarget(self, action: function, for: .touchUpInside)
        button.backgroundColor = color
        button.layer.cornerRadius = cRadius
        button.sizeToFit()
        button.setAttributedTitle(attrString, for: .normal)
        return button
    }
    
    func collapseEditBar(){
        if currentShape.isUserInteractionEnabled == true {
            currentShape.removeFromSuperview()
        }
        UIView.animate(withDuration: 0.3, animations: {
            self.confirmBtn.center.y = self.confirmBtn.center.y+100
            self.revertBtn.center.y = self.revertBtn.center.y+100
            self.dPadView.isHidden = true
        }) { (success) in
            print("Yes")
            self.tempToolBar.setItems(self.firstBarItems, animated: true)
            var collapsePos =  self.collapseButton.center.x
            var squarePos = self.squareButton.center.x
            self.collapseButton.center.x = self.collapseButton.center.x + 100
            self.squareButton.center.x = self.squareButton.center.x - 100
            UIView.animate(withDuration: 0.3, animations: {
                self.collapseButton.center.x = collapsePos
                self.squareButton.center.x = squarePos
            })
        }
    }
}



extension UIView {
    func setAnchorPoint(_ point: CGPoint) {
        var newPoint = CGPoint(x: bounds.size.width * point.x, y: bounds.size.height * point.y)
        var oldPoint = CGPoint(x: bounds.size.width * layer.anchorPoint.x, y: bounds.size.height * layer.anchorPoint.y);
        
        newPoint = newPoint.applying(transform)
        oldPoint = oldPoint.applying(transform)
        
        var position = layer.position
        
        position.x -= oldPoint.x
        position.x += newPoint.x
        
        position.y -= oldPoint.y
        position.y += newPoint.y
        
        layer.position = position
        layer.anchorPoint = point
    }
}


























//
//#import "ViewController.h"
//
//@interface ViewController (){
//    CGFloat tx; // x translation
//    CGFloat ty; // y translation
//    CGFloat scale; // zoom scale
//    CGFloat theta; // rotation angle
//    CGFloat initScale ;
//    CGFloat initTheta ;
//}
//@end
//
//@implementation ViewController
//
//- (void)viewDidLoad
//{
//    [super viewDidLoad];
//    // Do any additional setup after loading the view, typically from a nib.
//    UIRotationGestureRecognizer *rotationGesture = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(handleRotation:)];
//    [rotationGesture setDelegate:self];
//    [self.view addGestureRecognizer:rotationGesture];
//    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
//    [pinchGesture setDelegate:self];
//    [self.view addGestureRecognizer:pinchGesture];
//    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
//    [panGesture setDelegate:self];
//    [panGesture setMinimumNumberOfTouches:1];
//    [panGesture setMaximumNumberOfTouches:1];
//    [self.view addGestureRecognizer:panGesture];
//    _baseImage.transform = CGAffineTransformIdentity;
//    tx = 0.0f; ty = 0.0f; scale = 1.0f; theta = 0.0f;
//    scale = 1.0;
//    //removing and adding back to the view seems to fix problems with anchor point I was having, I suspect because of IB layout/scaling and constraints etc
//    UIView *mySuperView =_baseImage.superview;
//    [_baseImage removeFromSuperview];
//    [mySuperView addSubview:_baseImage];
//}
//-(void)setAnchorPoint:(CGPoint)anchorPoint forView:(UIView *)myview
//{
//    CGPoint oldOrigin = myview.frame.origin;
//    myview.layer.anchorPoint = anchorPoint;
//    CGPoint newOrigin = myview.frame.origin;
//    CGPoint transition;
//    transition.x = (newOrigin.x - oldOrigin.x);
//    transition.y = (newOrigin.y - oldOrigin.y);
//    CGPoint myNewCenter = CGPointMake (myview.center.x - transition.x, myview.center.y - transition.y);
//    myview.center =  myNewCenter;
//    }
//    - (void) updateTransformWithOffset: (CGPoint) translation
//{
//    // Create a blended transform representing translation,
//    // rotation, and scaling
//    _baseImage.transform = CGAffineTransformMakeTranslation(translation.x + tx, translation.y + ty);
//    _baseImage.transform = CGAffineTransformRotate(_baseImage.transform, theta);
//    _baseImage.transform = CGAffineTransformScale(_baseImage.transform, scale, scale);
//    }
//    - (void)adjustAnchorPointForGestureRecognizer:(UIGestureRecognizer *)uigr {
//        if (uigr.state == UIGestureRecognizerStateBegan) {
//            tx =_baseImage.transform.tx;
//            ty =_baseImage.transform.ty;
//            CGPoint locationInView = [uigr locationInView:_baseImage];
//            CGPoint newAnchor = CGPointMake( (locationInView.x / _baseImage.bounds.size.width), (locationInView.y / _baseImage.bounds.size.height ));
//            [self setAnchorPoint:newAnchor forView:_baseImage];
//        }
//        }
//        - (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
//            // if the gesture recognizers are on different views, don't allow simultaneous recognition
//            if (gestureRecognizer.view != otherGestureRecognizer.view)
//            return NO;
//
//            if (![gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]] && ![otherGestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]) {
//                return YES;
//            }
//            return NO;
//            }
//            - (void) handleRotation: (UIRotationGestureRecognizer *) uigr
//{
//    if (uigr.state == UIGestureRecognizerStateBegan) {
//        initTheta = theta;
//    }
//    theta = initTheta+uigr.rotation;
//    [self adjustAnchorPointForGestureRecognizer:uigr];
//    [self updateTransformWithOffset:CGPointZero];
//    }
//    - (void) handlePinch: (UIPinchGestureRecognizer *) uigr
//{
//    if (uigr.state == UIGestureRecognizerStateBegan) {
//        initScale = scale;
//    }
//    scale = initScale*uigr.scale;
//    [self adjustAnchorPointForGestureRecognizer:uigr];
//    [self updateTransformWithOffset:CGPointZero];
//
//    }
//    - (void) handlePan: (UIPanGestureRecognizer *) uigr
//{
//    CGPoint translation = [uigr translationInView:_baseImage.superview];
//    [self adjustAnchorPointForGestureRecognizer:uigr];
//    [self updateTransformWithOffset:translation];
//    }
//    - (void)didReceiveMemoryWarning
//        {
//            [super didReceiveMemoryWarning];
//            // Dispose of any resources that can be recreated.
//}
