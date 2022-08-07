//
//  PhotoDetailViewController.swift
//  unsplashrimp
//
//  Created by HAKKYU KIM on 2022/06/11.
//

import UIKit
import CoreMedia

protocol PhotoDetailViewDelegate: AnyObject {
    func photoDetailView(_ controller: PhotoDetailViewController, didDisplayAt indexPath: IndexPath)
    
    func photoDetailView(_ controller: PhotoDetailViewController, didDisplay lastIndexPath: IndexPath)
}

class PhotoDetailViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var collectionViewDataSource: UICollectionViewDiffableDataSource<String, UnPhoto>!
    
    var photoStore: [UnPhoto]!
    
    var targetIndexPath: IndexPath?
    weak var delegate: PhotoDetailViewDelegate?
    
    static func create(photoStore: [UnPhoto]) -> PhotoDetailViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let viewController = storyboard.instantiateViewController(withIdentifier: "PhotoDetailViewController") as! PhotoDetailViewController
        viewController.photoStore = photoStore
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionViewLayout()
        configureCollectionViewDataSource()
        
        var snapshot = collectionViewDataSource.snapshot()
        snapshot.appendSections(["main"])
        snapshot.appendItems(photoStore)
        collectionViewDataSource.apply(snapshot, animatingDifferences: true) { [weak self] in
            guard let targetIndexPath = self?.targetIndexPath else {
                return
            }
            self?.collectionView.scrollToItem(at: targetIndexPath, at: .centeredHorizontally, animated: false)
        }
    }
    
    func configureCollectionViewDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<PhotoDetailCell, UnPhoto>(cellNib: PhotoDetailCell.nib) { cell, indexPath, itemIdentifier in
            cell.imageView.kf.setImage(with: URL(string: itemIdentifier.urls.regular))
        }
        
        collectionViewDataSource = .init(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
            return cell
        }
        
    }
    
    func configureCollectionViewLayout() {
        let layoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let layoutItem = NSCollectionLayoutItem(layoutSize: layoutSize)
        let layoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: layoutSize, subitems: [layoutItem])
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        layoutSection.orthogonalScrollingBehavior = .paging
        layoutSection.visibleItemsInvalidationHandler = { [weak self] visibleItems, contentOffset, environment in
            guard let self = self else { return }
            let index = Int(contentOffset.x / environment.container.contentSize.width)
            let photo = self.photoStore[index]
            if let visibleIndexPath = visibleItems.last?.indexPath {
                self.delegate?.photoDetailView(self, didDisplayAt: visibleIndexPath)
                let itemCount = self.collectionView.numberOfItems(inSection: visibleIndexPath.section)
                let lastIndexPath = IndexPath(item: itemCount - 1, section: visibleIndexPath.section)
                if visibleIndexPath == lastIndexPath {
                    self.delegate?.photoDetailView(self, didDisplay: visibleIndexPath)
                }
            }
            self.navigationItem.title = photo.user.name
        }
        collectionView.collectionViewLayout = UICollectionViewCompositionalLayout(section: layoutSection)
    }
    
    func appendItemIdentifiers(photos: [UnPhoto]) {
        photoStore.append(contentsOf: photos)
        var snapshot = collectionViewDataSource.snapshot()
        snapshot.appendItems(photos, toSection: "main")
        collectionViewDataSource.apply(snapshot, animatingDifferences: true, completion: nil)
    }
    
}
