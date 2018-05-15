//
//  CardContentView.swift
//  AppStoreHomeInteractiveTransition
//
//  Created by Wirawit Rueopas on 3/4/2561 BE.
//  Copyright © 2561 Wirawit Rueopas. All rights reserved.
//

import UIKit

@IBDesignable class CardContentView: UIView {

    public var touchAction: ((_ touchType: ImageGalleryCollectionViewController.TouchType, _ touches: Set<UITouch>, _ event: UIEvent?) -> ())?

    var viewModel: CardCollectionViewCellViewModel? {
        didSet {
            secondaryLabel.text = viewModel?.secondaryHeader
            primaryLabel.text = viewModel?.primaryHeader
            detailLabel.text = viewModel?.descriptionHeader
            imageView.image = viewModel?.image
            self.pageControl.numberOfPages = images.count
            if let imageIndex = viewModel?.imageIndex {
                DispatchQueue.main.async(execute: {() -> Void in
                    self.imageView.image = UIImage.init(named: self.images[imageIndex])
                    self.pageControl.currentPage = imageIndex
                    self.collectionView.scrollToItem(at: IndexPath.init(row: imageIndex, section: 0), at: .centeredHorizontally, animated: false)
                })
            }
        }
    }

    @IBOutlet weak var collectionView: ImageGalleryCollectionViewController!
    @IBOutlet weak var collectionViewLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var secondaryLabel: UILabel!
    @IBOutlet weak var primaryLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var dataStackView: UIStackView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var imageToTopAnchor: NSLayoutConstraint!
    @IBOutlet weak var imageToLeadingAnchor: NSLayoutConstraint!
    @IBOutlet weak var imageToTrailingAnchor: NSLayoutConstraint!
    @IBOutlet weak var imageToBottomAnchor: NSLayoutConstraint!
    
    var isDetailView = false
    
    lazy var images: [String] = [
        "girl1.jpg",
        "girl2.jpg",
        "girl3.jpg",
        "girl4.jpg",
        "girl5.jpg"
        ]
    
    @IBInspectable var backgroundImage: UIImage? {
        get {
            return self.imageView.image
        }

        set(image) {
            self.imageView.image = image
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fromNib()
        commonSetup()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        fromNib()
        commonSetup()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        commonSetup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    private func commonSetup() {
        // *Make the background image stays still at the center while we animationg,
        // else the image will get resized during animation.
//        imageView.contentMode = .center
        
        setupCollectionView()
        
        imageView.contentMode = .scaleAspectFill
        fontState(isHighlighted: false)
        
    }
    
    private func setupCollectionView() {
        collectionView.register(UINib(nibName: "\(ImageCollectionViewCell.self)", bundle: nil), forCellWithReuseIdentifier: "imagePage")
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.delaysContentTouches = true
        //        collectionView.canCancelContentTouches = false
        
        collectionView.touchAction = { [unowned self] (type, touches, event) -> () in
            guard let touchesAction = self.touchAction else { return }
            touchesAction(type, touches, event)
        }

    }
    

    // This is for smooth animation state, it "connects" highlighted (pressedDown) font's size with the destination card's font size
    func fontState(isHighlighted: Bool) {
        if isHighlighted {
            primaryLabel.font = UIFont.systemFont(ofSize: 33 * kHighlightedFactor, weight: .bold)
            secondaryLabel.font = UIFont.systemFont(ofSize: 18 * kHighlightedFactor, weight: .semibold)
        } else {
            primaryLabel.font = UIFont.systemFont(ofSize: 33, weight: .bold)
            secondaryLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        }
    }
}

extension CardContentView: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imagePage", for: indexPath) as! ImageCollectionViewCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let cell = cell as! ImageCollectionViewCell
        cell.imageView?.image = UIImage.init(named: images[indexPath.row])
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if let collectionView = scrollView as? ImageGalleryCollectionViewController,
            let row = collectionView.indexPathForItem(at: targetContentOffset.pointee)?.row {
            imageView.image = UIImage.init(named: images[row])
            self.pageControl.currentPage = row
        }
    }
}

extension CardContentView: UICollectionViewDelegateFlowLayout {
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return collectionView.bounds.size
        }
}
