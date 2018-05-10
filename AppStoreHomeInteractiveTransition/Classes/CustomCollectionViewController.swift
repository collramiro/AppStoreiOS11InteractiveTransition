//
//  CustomCollectionViewController.swift
//  AppStoreHomeInteractiveTransition
//
//  Created by Ramiro on 09/05/2018.
//  Copyright © 2018 Wirawit Rueopas. All rights reserved.
//

import UIKit

class CustomCollectionViewController: UICollectionView, UIGestureRecognizerDelegate {

//    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
////        if gestureRecognizer is UILongPressGestureRecognizer ||
////            otherGestureRecognizer is UILongPressGestureRecognizer {
////            return false
////        }
//        return true
//    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        //        self.animate(isHighlighted: true)
    }
    
//    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
//        return false
//    }
//
//    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
//        return false
//    }
    
    override func touchesShouldCancel(in view: UIView) -> Bool {
        return false
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        //        self.animate(isHighlighted: false)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        //        self.animate(isHighlighted: false)
    }
}
