//
//  Constants.swift
//  TaskIt
//
//  Created by Robert Wais on 7/25/18.
//

import Foundation
import UIKit
struct Constants {
    struct Segue {
        //FILL IN
    }
    

    struct Colors {
        static let baseColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1.0)
        static let safeRed = UIColor(red: 255/255, green: 59/255, blue: 48/255, alpha: 1.0)
        static let freezeBlue = UIColor(red: 88/255, green: 203/255, blue: 230/255, alpha: 1.0)
        static let freezeBlueLight = UIColor(red: 88/255, green: 203/255, blue: 230/255, alpha: 0.4)
    }
    
    struct Data {
        static var liveTasks = [String: Task]()
        static var liveCompanyIds = [String]()
    }
}

