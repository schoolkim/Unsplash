//
//  SearchResultViewController.swift
//  unsplashrimp
//
//  Created by HAKKYU KIM on 2022/07/16.
//

import UIKit

protocol SearchResultDelegate: AnyObject {
    func searchResult(_ viewController: SearchResultViewController, itemIdentifier: String)
}

class SearchResultViewController: UIViewController {
    typealias ListCellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, String>
    typealias HeaderRegistration = UICollectionView.SupplementaryRegistration<SearchResultHeader>
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var collectionViewDataSource: UICollectionViewDiffableDataSource<String, String>!
    
    weak var delegate: SearchResultDelegate?
    
    var userDefault: UserDefaults {
        UserDefaults.standard
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCollectionViewLayout()
        configureCollectionViewDataSource()
        invalidateCollectionViewData()
    }
    
    private func configureCollectionViewDataSource() {
        let listCellRegistration: ListCellRegistration = .init { cell, indexPath, itemIdentifier in
            var configuration = cell.defaultContentConfiguration()
            configuration.text = itemIdentifier
            cell.contentConfiguration = configuration
        }
        
        let headerElementKind = UICollectionView.elementKindSectionHeader
        let headerRegistration: HeaderRegistration = .init(supplementaryNib: SearchResultHeader.nib, elementKind: headerElementKind) { supplementaryView, elementKind, indexPath in
            
        }
        
        collectionViewDataSource = .init(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            collectionView.dequeueConfiguredReusableCell(using: listCellRegistration, for: indexPath, item: itemIdentifier)
        })
        
        collectionViewDataSource.supplementaryViewProvider = { collectionView, elementKind, indexPath in
            
            let header = collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: indexPath)
            header.rightButtonAction = { [weak self] in
                guard let self = self else { return }
            
                self.userDefault.set(.recentSearch, value: nil)
                self.invalidateCollectionViewData()
            }
            return header
        }
    }
    
    private func configureCollectionViewLayout() {
        var listConfiguration = UICollectionLayoutListConfiguration(appearance: .grouped)
        listConfiguration.headerMode = .supplementary
        collectionView.collectionViewLayout = UICollectionViewCompositionalLayout.list(using: listConfiguration)
    }
    
    func invalidateCollectionViewData() {
        let recentSearch = userDefault.get(.recentSearch) ?? [String]()
        var snapshot = NSDiffableDataSourceSnapshot<String, String>()
        snapshot.appendSections(["main"])
        snapshot.appendItems(recentSearch)
        collectionViewDataSource.apply(snapshot, animatingDifferences: true, completion: nil)
    }
}

extension SearchResultViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let itemIdentifier = collectionViewDataSource.itemIdentifier(for: indexPath) else { return }
        
        collectionView.deselectItem(at: indexPath, animated: true)
        delegate?.searchResult(self, itemIdentifier: itemIdentifier)
    }
}
