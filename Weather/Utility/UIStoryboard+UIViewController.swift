//
//  UIStoryboard+UIViewController.swift
//  Weather
//
//  Created by Madhuri Agrawal on 22/02/24.
//

import UIKit

enum StoryboardAccessory: String {

    case main = "Main"

    var object: UIStoryboard {
        return UIStoryboard(name: rawValue, bundle: Bundle.main)
    }
}

class ViewControllerAccessors {

    class func getViewController<T:UIViewController>(_ ofType:T.Type, storyboard: StoryboardAccessory)->T{
        return storyboard.object.instantiateViewController(withIdentifier: String(describing: T.self)) as! T
    }

    class func getViewControllerWithIdentifier<T:UIViewController>(_ ofType:T.Type, storyboard: StoryboardAccessory, identifier: String)->T{
        return storyboard.object.instantiateViewController(withIdentifier: identifier) as! T
    }
}

