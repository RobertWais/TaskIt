//
//  MapVC+TaskShapeDelegate.swift
//  TaskIt
//
//  Created by Robert Wais on 7/30/18.
//

import Foundation
import UIKit

extension MapVC: ShapeDelegate,CompletedDelegate {
    
    //MARK: RETURN CALLS
    
    func didTapShape(_ key: String){
        let darkView = UIView(frame: self.view.bounds)
        self.view.addSubview(darkView)
        darkView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        let modalVC = storyboard?.instantiateViewController(withIdentifier: "TaskDetailsVC") as! TaskDetailsVC
        modalVC.delegate = self
        modalVC.key = key
        modalVC.modalPresentationStyle = .overCurrentContext
        present(modalVC, animated: true, completion: nil)
    }
    
    @objc func confirmShape(){
        let modalVC = storyboard?.instantiateViewController(withIdentifier: "ConfirmationVC") as! ConfirmationVC
        modalVC.delegate = self
        modalVC.currentShape = currentShape
        modalVC.modalPresentationStyle = .overCurrentContext
        let darkView = UIView(frame: self.view.bounds)
        self.view.addSubview(darkView)
        darkView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        present(modalVC, animated: true, completion: nil)
    }
    
    
    func didComplete(){
        let darkenView = self.view.subviews[self.view.subviews.count-1]
        UIView.animate(withDuration: 1.0, animations: {
            darkenView.alpha = 0.0
        }) { (success) in
            darkenView.removeFromSuperview()
        }
    }
    
    func didConfirm(bool: Bool){
        let darkenView = self.view.subviews[self.view.subviews.count-1]
        if freeze == 1{
            scrollView.isScrollEnabled = true
            freezeView.removeFromSuperview()
            freeze = 0
        }
        if bool {
            currentShape.isUserInteractionEnabled = false
            currentShape.removeFromSuperview()
            collapseEditBar()
        }else{
            currentShape.isUserInteractionEnabled = true
        }
        UIView.animate(withDuration: 1.0, animations: {
            darkenView.alpha = 0.0
        }) { (success) in
            darkenView.removeFromSuperview()
        }
    }
}
