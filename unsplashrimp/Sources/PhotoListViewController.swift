//
//  PhotoListViewController.swift
//  unsplashrimp
//
//  Created by HAKKYU KIM on 2022/05/28.
//

import UIKit



class PhotoListViewController: UIViewController {
    
    private var unsplashService: UnshrimpService {
        UnshrimpService.shared
    }
    
    private var collectionViewDataSource: UICollectionViewDiffableDataSource<String, UnPhoto>!
    
    private var photoStore = [UnPhoto]()
    var currentTopic: UnTopic!
    var needPagination: Bool = false
    
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    /*
     CollectionView Datasource - cell provider, 데이터 관리, 셀 제공
     CollectionView Layout - 레이아웃 제공
     */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.black.cgColor, UIColor.clear.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = .zero
        gradientLayer.endPoint = CGPoint(x: .zero, y: 1.0)
        gradientLayer.frame = gradientView.bounds
        gradientView.layer.addSublayer(gradientLayer)
        
        collectionView.contentInset.top += 44
        
        configureCollectionViewLayout()
        configureCollectionViewDataSource()
        
        unsplashService.requestTopicPhoto(from: currentTopic, firstPage: true) { [weak self] photos in
            guard let self = self else { return }
            self.photoStore = photos
            self.updateCollectionView()
        } onFailure: { [weak self] unError in
            guard let self = self else { return }
            self.showAlert(title: "Error", message: unError.errors.first)
        }
        
    }
    
    private func updateCollectionView() {
        var snapshot = collectionViewDataSource.snapshot()
        snapshot.appendSections(["main"])
        snapshot.appendItems(photoStore)
        collectionViewDataSource.apply(snapshot, animatingDifferences: true)
    }
    
    private func paginateCollectionView(completion: (([UnPhoto]) -> Void)? = nil) {
        unsplashService.requestTopicPhoto(from: currentTopic) { [weak self] photos in
            guard let self = self else { return }
            self.photoStore.append(contentsOf: photos)
            var snapshot = self.collectionViewDataSource.snapshot()
            snapshot.appendItems(photos)
            self.collectionViewDataSource.apply(snapshot, animatingDifferences: true)
            completion?(photos)
        } onFailure: { [weak self] unError in
            guard let self = self else { return }
            self.showAlert(title: "Error", message: unError.errors.first)
        }
    }
    
    /// Configure collection view data source for registering
    func configureCollectionViewDataSource() {
        
        let photoCellRegistration = UICollectionView.CellRegistration<PhotoCell, UnPhoto>.init(cellNib: PhotoCell.nib) { cell, indexPath, itemIdentifier in
            cell.configureCell(item: itemIdentifier)
        }
        
        collectionViewDataSource = .init(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: photoCellRegistration, for: indexPath, item: itemIdentifier)
            return cell
        }
    }
    
    func configureCollectionViewLayout() {
        
        /*
         absolute - 절대값
         fractional - 부모 뷰를 다쓴다 = 1.0(0 ~ 1)
         estimated - 임의의 값
         */

        collectionView.collectionViewLayout = UICollectionViewCompositionalLayout() { sectionIndex, environment in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(128))
            let itemLayoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
            let groupLayout = NSCollectionLayoutGroup.vertical(layoutSize: itemSize, subitems: [itemLayoutItem])
            let sectionLayout = NSCollectionLayoutSection(group: groupLayout)
            return sectionLayout
        }
    }
}

extension PhotoListViewController: PhotoDetailViewDelegate {
    func photoDetailView(_ controller: PhotoDetailViewController, didDisplayAt indexPath: IndexPath) {
        collectionView.scrollToItem(at: indexPath, at: .centeredVertically, animated: true)
    }
    
    func photoDetailView(_ controller: PhotoDetailViewController, didDisplay lastIndexPath: IndexPath) {
        guard !needPagination else { return }
        
        needPagination = true
        paginateCollectionView { [weak self] photos in
            guard let self = self else { return }
            self.needPagination = false
            controller.appendItemIdentifiers(photos: photos)
        }
    }
}

extension PhotoListViewController: UICollectionViewDelegate {
    
    // collectionView에서 cell이 클릭되었을 때 호출되는 함수
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let viewController = PhotoDetailViewController.create(photoStore: photoStore)
        viewController.targetIndexPath = indexPath
        viewController.delegate = self
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    // collectionView에서 셀이 나타날 때 호출되는 함수
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let sectionItemCount = collectionView.numberOfItems(inSection: indexPath.section)
        if sectionItemCount == indexPath.item + 1 {
            paginateCollectionView()
        }
    }
    
    // 컬렉션뷰에서 셀이 사라질 때 호출되는 함수
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
    }
}
