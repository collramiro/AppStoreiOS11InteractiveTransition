//
//  CardDetailViewController.swift
//  AppStoreHomeInteractiveTransition
//
//  Created by Wirawit Rueopas on 4/4/2561 BE.
//  Copyright © 2561 Wirawit Rueopas. All rights reserved.
//

import UIKit

protocol CardDetailInteractivityDelegate: class {
    func shouldDragDownToDismiss()
}

class CardDetailViewController: AnimatableStatusBarViewController, UIScrollViewDelegate {

    @IBOutlet weak var cardContentView: CardContentView!

    @IBOutlet weak var scrollView: UIScrollView!
    var cardViewModel: CardCollectionViewCellViewModel! {
        didSet {
            if self.cardContentView != nil {
                self.cardContentView.viewModel = cardViewModel
            }
        }
    }

    weak var interactivityDelegate: CardDetailInteractivityDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        scrollView.delegate = self
        cardContentView.viewModel = cardViewModel
        cardContentView.fontState(isHighlighted: true)
        cardContentView.isDetailView = true
        cardContentView.collectionView.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        cardContentView.collectionView.isHidden = false
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let shouldScrollEnabled: Bool
        if self.scrollView.isTracking && scrollView.contentOffset.y < 0 {
            shouldScrollEnabled = false
            cardContentView.collectionView.isHidden = true
            self.interactivityDelegate?.shouldDragDownToDismiss()
        } else {
//            cardContentView.collectionView.isHidden = false
            shouldScrollEnabled = true
        }

        // Update only on change
        if shouldScrollEnabled != scrollView.isScrollEnabled {
            scrollView.showsVerticalScrollIndicator = shouldScrollEnabled
            scrollView.isScrollEnabled = shouldScrollEnabled
        }
    }

    override var animatedStatusBarPrefersStatusBarHidden: Bool {
        return true
    }

    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .slide
    }
}
