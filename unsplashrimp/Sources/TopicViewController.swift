//
//  TopicViewController.swift
//  unsplashrimp
//
//  Created by HAKKYU KIM on 2022/05/21.
//

import UIKit

protocol TopicViewControllerEvent: AnyObject {
    func topic(_ viewController: TopicViewController, didSelectedItem: UnTopic)
}

class TopicViewController: UIViewController {
    
    typealias TopicCellRegistration = UICollectionView.CellRegistration<TopicCell, UnTopic>

    @IBOutlet weak var collectionView: UICollectionView!
    
    private var collectionViewDataSource: UICollectionViewDiffableDataSource<String, UnTopic>!
    
    weak var eventDelegate: TopicViewControllerEvent?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.alwaysBounceVertical = false
        
        configureCollectionViewDataSource()
        configureCollectionViewLayout()
        
    }
    
    func configureCollectionViewDataSource() {
        
        let topicCellRegistration = TopicCellRegistration(cellNib: TopicCell.nib) { cell, indexPath, itemIdentifier in
            cell.configureCell(itemIdentifier: itemIdentifier)
        }
        
        collectionViewDataSource = .init(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: topicCellRegistration, for: indexPath, item: itemIdentifier)
            return cell
        }
    }
    
    /**
     1. Section
     2. Group
     3. Item
     */
    
    func configureCollectionViewLayout() {
        let itemLayoutSize = NSCollectionLayoutSize(widthDimension: .estimated(128), heightDimension: .fractionalHeight(1.0))
        let itemLayout = NSCollectionLayoutItem(layoutSize: itemLayoutSize)
        let groupLayoutSize = NSCollectionLayoutSize(widthDimension: .estimated(128), heightDimension: .absolute(44))
        let groupLayout = NSCollectionLayoutGroup.horizontal(layoutSize: groupLayoutSize, subitems: [itemLayout])
        let sectionLayout = NSCollectionLayoutSection(group: groupLayout)
        sectionLayout.orthogonalScrollingBehavior = .continuous
        sectionLayout.contentInsets.leading = 16
        sectionLayout.contentInsets.trailing = 16
        sectionLayout.interGroupSpacing = 16
        collectionView.collectionViewLayout = UICollectionViewCompositionalLayout(section: sectionLayout)
    }
    
    func applyInitialData(items: [UnTopic]) {
        var snapshot = collectionViewDataSource.snapshot()
        snapshot.appendSections(["topic"])
        snapshot.appendItems(items, toSection: "topic")
        collectionViewDataSource.apply(snapshot) { [weak self] in
            self?.collectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: [])
        }
    }
    
}

extension UIColor {
    class var random: UIColor {
        UIColor(red: .random(in: 0...1), green: .random(in: 0...1), blue: .random(in: 0...1), alpha: 1)
    }
}

extension TopicViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        if let itemIdentifier = collectionViewDataSource.itemIdentifier(for: indexPath) {
            eventDelegate?.topic(self, didSelectedItem: itemIdentifier)
        }
        
    }
}










