//
//  HomeViewController.swift
//  AppStoreHomeInteractiveTransition
//
//  Created by Wirawit Rueopas on 3/30/2561 BE.
//  Copyright © 2561 Wirawit Rueopas. All rights reserved.
//

import UIKit

let kHighlightedFactor: CGFloat = 0.96

final class HomeViewController: AnimatableStatusBarViewController {

    enum Constant {
        static let horizontalInset: CGFloat = 20
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewLayout: UICollectionViewFlowLayout!
    
    lazy var models: [CardCollectionViewCellViewModel] = [
        CardCollectionViewCellViewModel(primaryHeader: "Primary", secondaryHeader: "Secondary", descriptionHeader: "Desc", image: #imageLiteral(resourceName: "girl1.jpg").resize(toWidth: UIScreen.main.bounds.size.width * (1/kHighlightedFactor))),
        CardCollectionViewCellViewModel(primaryHeader: "You won't believe this guy", secondaryHeader: "Something we want", descriptionHeader: "They have something we want which is not something we need.", image: #imageLiteral(resourceName: "girl2.jpg").resize(toWidth: UIScreen.main.bounds.size.width * (1/kHighlightedFactor))),
        CardCollectionViewCellViewModel(primaryHeader: "Primary", secondaryHeader: "Secondary", descriptionHeader: "Desc", image: #imageLiteral(resourceName: "girl3.jpg").resize(toWidth: UIScreen.main.bounds.size.width * (1/kHighlightedFactor))),
        CardCollectionViewCellViewModel(primaryHeader: "You won't believe this guy", secondaryHeader: "Something we want", descriptionHeader: "They have something we want which is not something we need.", image: #imageLiteral(resourceName: "girl4.jpg").resize(toWidth: UIScreen.main.bounds.size.width * (1/kHighlightedFactor))),
        CardCollectionViewCellViewModel(primaryHeader: "You won't believe this guy", secondaryHeader: "Something we want", descriptionHeader: "They have something we want which is not something we need.", image: #imageLiteral(resourceName: "girl5.jpg").resize(toWidth: UIScreen.main.bounds.size.width * (1/kHighlightedFactor))),
        CardCollectionViewCellViewModel(primaryHeader: "Primary", secondaryHeader: "Secondary", descriptionHeader: "Desc", image:#imageLiteral(resourceName: "girl6.jpg").resize(toWidth: UIScreen.main.bounds.size.width * (1/kHighlightedFactor)))
    ]

    private var transitionManager: CardToDetailTransitionManager!

    private var indexOfCellBeforeDragging = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Make it responds fast to highlight state, so we can make press-down animation immediately.
        collectionView.delaysContentTouches = false
        
//        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
//            layout.minimumLineSpacing = 20
//            layout.minimumInteritemSpacing = 0
//            layout.sectionInset = .init(top: 20, left: 0, bottom: 64, right: 0)
//        }
        
        collectionViewLayout.minimumLineSpacing = 0
        collectionView.delegate = self
        collectionView.dataSource = self
        //collectionView.register(UINib(nibName: "\(CardCollectionViewCell.self)", bundle: nil), forCellWithReuseIdentifier: "card")
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        configureCollectionViewLayoutItemSize()
    }
    
    override var animatedStatusBarPrefersStatusBarHidden: Bool {
        return false
    }

    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .slide
    }
    
    private func calculateSectionInset() -> CGFloat {
        let deviceIsIpad = UIDevice.current.userInterfaceIdiom == .pad
        let deviceOrientationIsLandscape = UIDevice.current.orientation.isLandscape
        let cellBodyViewIsExpended = deviceIsIpad || deviceOrientationIsLandscape
        let cellBodyWidth: CGFloat = 236 + (cellBodyViewIsExpended ? 174 : 0)
        
        let buttonWidth: CGFloat = 50
        
        let inset = (collectionViewLayout.collectionView!.frame.width - cellBodyWidth + buttonWidth) / 4
        return 66
    }
    
    private func configureCollectionViewLayoutItemSize() {
        let inset: CGFloat = calculateSectionInset() // This inset calculation is some magic so the next and the previous cells will peek from the sides. Don't worry about it
        collectionViewLayout.sectionInset = UIEdgeInsets(top: inset, left: 0, bottom: inset, right: 0)
        
        let width = collectionView.bounds.size.width - 2 * Constant.horizontalInset
        let height: CGFloat = collectionViewLayout.collectionView!.frame.size.height - inset * 2
        
        collectionViewLayout.itemSize = CGSize(width: width, height: height)
    }
    
    private func indexOfMajorCell() -> Int {
        let itemHeight = collectionViewLayout.itemSize.height
        let proportionalOffset = collectionViewLayout.collectionView!.contentOffset.y / itemHeight
        return Int(round(proportionalOffset))
    }
}

extension HomeViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return models.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "card", for: indexPath) as! CardCollectionViewCell
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let cell = cell as! CardCollectionViewCell
        cell.cardContentView?.viewModel = models[indexPath.row]
        cell.onCardTouch = { [unowned self] (cell) -> () in
            if let indexPath = self.collectionView?.indexPath(for: cell) {
                DispatchQueue.main.async(execute: {() -> Void in
                    self.collectionView?.selectItem(at: indexPath, animated: true, scrollPosition: .centeredVertically)
                    self.collectionView?.delegate?.collectionView!(self.collectionView, didSelectItemAt: indexPath)
                })
            }
        }
    }
    
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        indexOfCellBeforeDragging = indexOfMajorCell()
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        // Stop scrollView sliding:
        targetContentOffset.pointee = scrollView.contentOffset
        
        // calculate where scrollView should snap to:
        let indexOfMajorCell = self.indexOfMajorCell()
        
        // calculate conditions:
        let swipeVelocityThreshold: CGFloat = 0.5 // after some trail and error
        let hasEnoughVelocityToSlideToTheNextCell = indexOfCellBeforeDragging + 1 < models.count && velocity.y > swipeVelocityThreshold
        let hasEnoughVelocityToSlideToThePreviousCell = indexOfCellBeforeDragging - 1 >= 0 && velocity.y < -swipeVelocityThreshold
        let majorCellIsTheCellBeforeDragging = indexOfMajorCell == indexOfCellBeforeDragging
        let didUseSwipeToSkipCell = majorCellIsTheCellBeforeDragging && (hasEnoughVelocityToSlideToTheNextCell || hasEnoughVelocityToSlideToThePreviousCell)
        
        if didUseSwipeToSkipCell {
            
            let snapToIndex = indexOfCellBeforeDragging + (hasEnoughVelocityToSlideToTheNextCell ? 1 : -1)
            let toValue = collectionViewLayout.itemSize.height * CGFloat(snapToIndex)
            
            // Damping equal 1 => no oscillations => decay animation:
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: velocity.x, options: .allowUserInteraction, animations: {
                scrollView.contentOffset = CGPoint(x: 0, y: toValue)
                scrollView.layoutIfNeeded()
            }, completion: nil)
            
        } else {
            // This is a much better to way to scroll to a cell:
            let indexPath = IndexPath(row: indexOfMajorCell, section: 0)
            collectionViewLayout.collectionView!.scrollToItem(at: indexPath, at: .centeredVertically, animated: true)
        }
    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let width = collectionView.bounds.size.width - 2 * Constant.horizontalInset
//        let height: CGFloat = width * 1.6
//        return CGSize(width: width, height: height)
//    }
    
//    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
//        return true
//    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = storyboard!.instantiateViewController(withIdentifier: "CardDetailViewController") as! CardDetailViewController
        let ind = indexPath
        let cardModel = models[ind.item]
        let cell = collectionView.cellForItem(at: ind) as! CardCollectionViewCell

        // Freeze animation highlighted state (or else it will bounce back)
        cell.disabledAnimation = true
        cell.layer.removeAllAnimations()

        let currentCellFrame = cell.layer.presentation()!.frame
        let cardFrame = cell.superview!.convert(currentCellFrame, to: nil)

        vc.cardViewModel = cardModel.scaledHighlightImageState()

        // Card's frame relative to UIWindow
        let frameWithoutTransform = { () -> CGRect in
            let center = cell.center
            let size = cell.bounds.size
            let r = CGRect(
                x: center.x - size.width / 2,
                y: center.y - size.height / 2,
                width: size.width,
                height: size.height
            )
            return cell.superview!.convert(r, to: nil)
        }()

        let params = (fromCardFrame: cardFrame, fromCardFrameWithoutTransform: frameWithoutTransform, viewModel: cardModel, fromCell: cell)
        self.transitionManager = CardToDetailTransitionManager(params)
        self.transitionManager.cardDetailViewController = vc
        vc.transitioningDelegate = transitionManager

        self.present(vc, animated: true, completion: {
            cell.isHidden = false

            // Unfreeze
            cell.disabledAnimation = false
        })
    }
}
