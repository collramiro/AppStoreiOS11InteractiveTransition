//
//  CustomCollectionViewController.swift
//  AppStoreHomeInteractiveTransition
//
//  Created by Ramiro on 09/05/2018.
//  Copyright © 2018 Wirawit Rueopas. All rights reserved.
//

import UIKit

class ImageGalleryCollectionViewController: UICollectionView, UIScrollViewDelegate, UIGestureRecognizerDelegate {

    public enum TouchType {
        case began
        case ended
        case cancelled
    }
    
    public var touchAction: ((_ touchType: TouchType, _ touches: Set<UITouch>, _ event: UIEvent?) -> ())?
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard let touchesBeganAction = touchAction else { return }
        touchesBeganAction(.began, touches, event)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        guard let touchesEndedAction = touchAction else { return }
        touchesEndedAction(.ended, touches, event)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        guard let touchesCancelledAction = touchAction else { return }
        touchesCancelledAction(.cancelled, touches, event)
    }

//        func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
//    //        if gestureRecognizer is UILongPressGestureRecognizer ||
//    //            otherGestureRecognizer is UILongPressGestureRecognizer {
//    //            return false
//    //        }
//            return true
//        }
    
}
