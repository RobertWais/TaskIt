//
//  Task.swift
//  TaskIt
//
//  Created by Robert Wais on 7/27/18.
//

import Foundation
import UIKit

struct Task{
    private var _shape: TaskShape?
    private var _title = ""
    private var _description = ""
    private var _userPosted = ""
    private var _completed = ""
    

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
    
}
