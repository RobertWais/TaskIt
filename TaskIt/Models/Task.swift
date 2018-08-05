//
//  Task.swift
//  TaskIt
//
//  Created by Robert Wais on 7/27/18.
//

import Foundation
import UIKit
import FirebaseDatabase.FIRDataSnapshot

protocol ShapeDelegate: class {
    func didTapShape(_ key: String)
}


class Task{
    weak var delegate: ShapeDelegate?
    
    
    private var _shape: TaskShape?
    private var _title = ""
    private var _description = ""
    private var _userPosted = ""
    private var _completed = ""
    private var _key = ""
    

    init(shape: TaskShape, title: String, description: String, userPosted: String, completed: String ) {
        self._shape = shape
        self._title = title
        self._description = description
        self._userPosted = userPosted
        self._completed = completed
    }
    
    var shape: TaskShape {
        guard let returnShape = _shape else {
            return TaskShape()
        }
        return returnShape
    }
    
    var key: String{
        return _key
    }
    
    var title: String {
        return _title
    }
    
    var description: String {
        return _description
    }
    
    var userPosted: String{
        return _userPosted
    }
    
    var completed: String {
        return _completed
    }
    
    var dictValue: [String: Any] {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        shape.backgroundColor?.getRed(&r, green: &g, blue: &b, alpha: &a)
        let radians:CGFloat = atan2((shape.transform.b), (shape.transform.a))
        let shapeDict: NSDictionary = ["colorR": r,
                                       "colorG": g,
                                       "colorB": b,
                         "width" : shape.bounds.width,
                         "height" : shape.bounds.height,
                         "positionX" : shape.center.x,
                         "positionY" : shape.center.y,
                         "type" : shape.type,
                         "angle" : radians,
                         "alpha" : a]
//        let userDict = ["uid" : poster.uid,
//                        "username" : poster.username]
        return ["title" : title,
                "description" : description,
                "userPosted" : userPosted,
                "completed" : completed,
                "shape" : shapeDict]
    }
    init?(snapshot: DataSnapshot){
        guard let dict = snapshot.value as? [String: Any],
        let title = dict["title"] as? String,
        let description = dict["description"] as? String,
        let userPosted = dict["userPosted"] as? String,
        let completed = dict["completed"] as? String,
        let shapeLayout = dict["shape"] as? [String : Any],
            let colorR = shapeLayout["colorR"] as? CGFloat,
            let colorG = shapeLayout["colorG"] as? CGFloat,
            let colorB = shapeLayout["colorB"] as? CGFloat,
            let width = shapeLayout["width"] as? CGFloat,
            let height = shapeLayout["height"] as? CGFloat,
            let positionX = shapeLayout["positionX"] as? CGFloat,
            let positionY = shapeLayout["positionY"] as? CGFloat,
            let type = shapeLayout["type"] as? Int,
            let angle = shapeLayout["angle"] as? CGFloat,
            let alpha = shapeLayout["alpha"] as? CGFloat
            else {return nil}
        
        
        self._title = title
        self._description = description
        self._userPosted = userPosted
        self._completed = completed
        self._shape = TaskShape(shape: type)
        self._shape?.bounds = CGRect(x: 0, y: 0, width: width, height: height)
        self._shape?.center.x = positionX
        self._shape?.center.y = positionY
        self._shape?.transform = CGAffineTransform(rotationAngle: angle)
        if type == 0{
            self._shape?.layer.cornerRadius = (self._shape?.layer.frame.width)!/2
        }
        //Change when adding new features of colors
//        self._shape?.backgroundColor = UIColor(red: colorR, green: colorG, blue: colorB, alpha: alpha)
        self.shape.backgroundColor = Constants.Colors.safeRed
        self._key = snapshot.key
    }
    
    func addTapGesture(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showDetails(recognizer:)))
        self.shape.addGestureRecognizer(tapGesture)
    }
//    let modalVC = storyboard?.instantiateViewController(withIdentifier: "ConfirmationVC") as! ConfirmationVC
//    modalVC.delegate = self
//    modalVC.currentShape = currentShape
//    modalVC.modalPresentationStyle = .overCurrentContext
    @objc func showDetails(recognizer: UITapGestureRecognizer){
        self.delegate?.didTapShape(self.key)
    }
}
