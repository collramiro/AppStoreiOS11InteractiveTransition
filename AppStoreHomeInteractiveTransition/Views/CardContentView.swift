//
//  CardContentView.swift
//  AppStoreHomeInteractiveTransition
//
//  Created by Wirawit Rueopas on 3/4/2561 BE.
//  Copyright © 2561 Wirawit Rueopas. All rights reserved.
//

import UIKit

@IBDesignable class CardContentView: UIView {

    var viewModel: CardCollectionViewCellViewModel? {
        didSet {
            secondaryLabel.text = viewModel?.secondaryHeader
            primaryLabel.text = viewModel?.primaryHeader
            detailLabel.text = viewModel?.descriptionHeader
            imageView.image = viewModel?.image
        }
    }
    
    @IBOutlet weak var secondaryLabel: UILabel!
    @IBOutlet weak var primaryLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var detailLabel: UILabel!
    
    @IBOutlet weak var imageToTopAnchor: NSLayoutConstraint!
    @IBOutlet weak var imageToLeadingAnchor: NSLayoutConstraint!
    @IBOutlet weak var imageToTrailingAnchor: NSLayoutConstraint!
    @IBOutlet weak var imageToBottomAnchor: NSLayoutConstraint!
    @IBOutlet weak var collectionView: UICollectionView!
    
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
    
    private func commonSetup() {
        // *Make the background image stays still at the center while we animationg,
        // else the image will get resized during animation.
//        imageView.contentMode = .center
        
        collectionView.register(UINib(nibName: "\(ImageCollectionViewCell.self)", bundle: nil), forCellWithReuseIdentifier: "imagePage")

        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.delaysContentTouches = true
        
        imageView.contentMode = .scaleAspectFill
        fontState(isHighlighted: false)
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
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
//        self.animate(isHighlighted: true)
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
    
}

extension CardContentView: UICollectionViewDelegateFlowLayout {
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return collectionView.bounds.size
        }
}
