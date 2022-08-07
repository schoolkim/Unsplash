//
//  ExploreViewController.swift
//  unsplashrimp
//
//  Created by HAKKYU KIM on 2022/05/14.
//

import UIKit


class ExploreViewController: UIViewController {
    
    private var unsplashService: UnshrimpService {
        UnshrimpService.shared
    }
    
    weak var pageViewController: UIPageViewController?
    
    var pageViewControllers: [UIViewController] = []
    
    var topicDataStore = [UnTopic]()
    
    weak var topicViewController: TopicViewController?
    
    @IBOutlet weak var loadingView: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadingView.startAnimating()

        unsplashService.requestTopics { [weak self] topics in
            guard let self = self else { return }
            
            self.loadingView.stopAnimating()
            
            self.topicDataStore = topics
            self.topicViewController?.applyInitialData(items: self.topicDataStore)
            self.pageViewControllers = self.topicDataStore.map { topic in
                
                let storyboard = UIStoryboard(name: "Main", bundle: .main)
                return storyboard.instantiateViewController(identifier: "PhotoListViewController") { coder in
                    let viewController = PhotoListViewController(coder: coder)
                    viewController?.currentTopic = topic
                    return viewController
                }
            }
            
            if let pageContentViewController = self.pageViewControllers.first {
                self.pageViewController?.setViewControllers([pageContentViewController], direction: .forward, animated: false)
            }
            
        } onFailure: { [weak self] unError in
            guard let self = self else { return }
            self.loadingView.stopAnimating()
            self.showAlert(title: "Error", message: unError.errors.first)
        }
    }
    
    @IBSegueAction func segueTopicViewController(_ coder: NSCoder) -> TopicViewController? {
        let viewController = TopicViewController(coder: coder)
        viewController?.eventDelegate = self
        self.topicViewController = viewController
        return viewController
    }
    
    @IBSegueAction func seguePageController(_ coder: NSCoder) -> UIPageViewController? {
        let pageViewController = UIPageViewController(coder: coder)
        self.pageViewController = pageViewController
        pageViewController?.dataSource = self
        pageViewController?.delegate = self
        return pageViewController
    }

}

extension ExploreViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        if let currentIndex = pageViewControllers.firstIndex(of: viewController) {
            if currentIndex == 0 {
                return nil
            }
            return pageViewControllers[currentIndex - 1]
        }
        
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        
        if let currentIndex = pageViewControllers.firstIndex(of: viewController) {
            if currentIndex == pageViewControllers.count - 1 {
                return nil
            }
            return pageViewControllers[currentIndex+1]
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard completed else { return }
        if let currentViewController = pageViewController.viewControllers?.first,
           let currentIndex = pageViewControllers.firstIndex(of: currentViewController) {
            let indexPath = IndexPath(item: currentIndex, section: .zero)
            topicViewController?.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: [.centeredHorizontally])
        }
    }
}

extension ExploreViewController: TopicViewControllerEvent {
    func topic(_ viewController: TopicViewController, didSelectedItem: UnTopic) {
        if let selectedIndex = topicDataStore.firstIndex(of: didSelectedItem),
           let currentViewController = pageViewController?.viewControllers?.first,
           let currentIndex = pageViewControllers.firstIndex(of: currentViewController) {
            let direction: UIPageViewController.NavigationDirection = (currentIndex > selectedIndex) ? .reverse : .forward
            pageViewController?.setViewControllers([pageViewControllers[selectedIndex]], direction: direction, animated: true)
        }
    }
    
    
}
