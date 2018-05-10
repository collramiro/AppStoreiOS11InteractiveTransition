//
//  SwipeableImageViewController.swift
//  AppStoreHomeInteractiveTransition
//
//  Created by Ramiro on 09/05/2018.
//  Copyright © 2018 Wirawit Rueopas. All rights reserved.
//

import UIKit

class SwipeableImageViewController: UIPageViewController
{
    fileprivate lazy var pages: [UIViewController] = {
        return [
            self.getPageController(withImageName: "girl1.jpg"),
            self.getPageController(withImageName: "girl2.jpg"),
            self.getPageController(withImageName: "girl3.jpg"),
            self.getPageController(withImageName: "girl4.jpg"),
            self.getPageController(withImageName: "girl5.jpg")
        ]
    }()
    
    fileprivate func getPageController(withImageName imageName: String) -> UIViewController
    {
        let page = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Page") as? ImageContentViewController
        page?.imageName = imageName
        return page!
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.dataSource = self
        self.delegate   = self
        
        if let firstVC = pages.first
        {
            setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
    }
}

extension SwipeableImageViewController: UIPageViewControllerDataSource
{
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = pages.index(of: viewController) else { return nil }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0          else { return pages.last }
        
        guard pages.count > previousIndex else { return nil        }
        
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController?
    {
        guard let viewControllerIndex = pages.index(of: viewController) else { return nil }
        
        let nextIndex = viewControllerIndex + 1
        
        guard nextIndex < pages.count else { return pages.first }
        
        guard pages.count > nextIndex else { return nil         }
        
        return pages[nextIndex]
    }
}

extension SwipeableImageViewController: UIPageViewControllerDelegate { }
