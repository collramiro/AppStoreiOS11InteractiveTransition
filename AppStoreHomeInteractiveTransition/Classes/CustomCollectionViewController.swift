//
//  CustomCollectionViewController.swift
//  AppStoreHomeInteractiveTransition
//
//  Created by Ramiro on 09/05/2018.
//  Copyright © 2018 Wirawit Rueopas. All rights reserved.
//

import UIKit

class CustomCollectionViewController: UICollectionView, UIGestureRecognizerDelegate {

    public var touchesBeganAction: ((_ touches: Set<UITouch>, _ event: UIEvent?) -> ())?
    public var touchesEndedAction: ((_ touches: Set<UITouch>, _ event: UIEvent?) -> ())?
    public var touchesCancelledAction: ((_ touches: Set<UITouch>, _ event: UIEvent?) -> ())?
    
//    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
////        if gestureRecognizer is UILongPressGestureRecognizer ||
////            otherGestureRecognizer is UILongPressGestureRecognizer {
////            return false
////        }
//        return true
//    }
    
//    override func touchesShouldCancel(in view: UIView) -> Bool {
//        return false
//    }
//
    
    //
    //    override func touchesShouldCancel(in view: UIView) -> Bool {
    //        return false
    //    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard let touchesBeganAction = touchesBeganAction else { return }
        touchesBeganAction(touches, event)
    }

    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        guard let touchesEndedAction = touchesEndedAction else { return }
        touchesEndedAction(touches, event)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        guard let touchesCancelledAction = touchesCancelledAction else { return }
        touchesCancelledAction(touches, event)
    }
}
