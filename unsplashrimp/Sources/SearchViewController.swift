//
//  SearchViewController.swift
//  unsplashrimp
//
//  Created by HAKKYU KIM on 2022/07/16.
//

import UIKit

class SearchViewController: UIViewController {
    
    var userDefault: UserDefaults {
        UserDefaults.standard
    }
    
    var unsplashService: UnshrimpService {
        UnshrimpService.shared
    }
    
    private var collectionViewDataSource: UICollectionViewDiffableDataSource<String, UnPhoto>!
    private var photoStore: [UnPhoto]!
    private var needPagination: Bool = false
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private lazy var searchResultController: SearchResultViewController = {
        UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(identifier: "SearchResultViewController") { coder in
                let viewController = SearchResultViewController(coder: coder)
                viewController?.delegate = self
                return viewController
            }
    }()
    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: searchResultController)
        searchController.searchBar.placeholder = "Search Photos, Collections, Users"
        searchController.searchBar.tintColor = .label
        searchController.searchResultsUpdater = searchResultController as? UISearchResultsUpdating
        searchController.delegate = self
        searchController.searchBar.delegate = self
        return searchController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.searchController = searchController
        configureCollectionViewLayout()
        configureCollectionViewDataSource()
    }
    
    func configureCollectionViewDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<PhotoCell, UnPhoto>.init(cellNib: PhotoCell.nib) { cell, indexPath, itemIdentifier in
            cell.configureCell(item: itemIdentifier)
        }
        
        collectionViewDataSource = .init(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
            return cell
        })
    }
    
    func configureCollectionViewLayout() {
        collectionView.collectionViewLayout = UICollectionViewCompositionalLayout() { sectionIndex, environment in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(128))
            let itemLayoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
            let groupLayout = NSCollectionLayoutGroup.vertical(layoutSize: itemSize, subitems: [itemLayoutItem])
            let sectionLayout = NSCollectionLayoutSection(group: groupLayout)
            return sectionLayout
        }
    }
    
    private func writeRecentSearchUserDefault() {
        guard let searchText = searchController.searchBar.text else { return }
        
        var recentSearch = userDefault.get(.recentSearch) ?? [String]()
        recentSearch.removeAll(where: { $0 == searchText })
        recentSearch.insert(searchText, at: .zero)
        userDefault.set(.recentSearch, value: recentSearch)
        
        if searchResultController.isViewLoaded {
            searchResultController.invalidateCollectionViewData()
        }
    }
    
    private func fetchSearchResultData() {
        guard let query = searchController.searchBar.text else { return }
        
        unsplashService.requestSearchPhotos(query: query) { [weak self] photos in
            guard let self = self else { return }
            
            self.photoStore = photos
            var snapshot = self.collectionViewDataSource.snapshot()
            snapshot.appendSections(["main"])
            photos.forEach {
                snapshot.appendItems([$0])
            }
            self.collectionViewDataSource.apply(snapshot, animatingDifferences: false)
        }
    }
}

extension SearchViewController: UISearchControllerDelegate {
    func willPresentSearchController(_ searchController: UISearchController) {
        searchController.searchBar.scopeButtonTitles = ["Photos", "Collections", "Users"]
        searchController.searchBar.selectedScopeButtonIndex = .zero
    }
    
    func didDismissSearchController(_ searchController: UISearchController) {
        // if searchController.searchBar.text?.isEmpty =
        searchController.searchBar.scopeButtonTitles = nil
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        if searchBar.searchTextField.hasText {
            var snapshot = collectionViewDataSource.snapshot()
            snapshot.deleteAllItems()
            collectionViewDataSource.apply(snapshot)
            searchController.showsSearchResultsController = true
        } else {
            searchController.showsSearchResultsController = true
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchController.showsSearchResultsController = false
        writeRecentSearchUserDefault()
        fetchSearchResultData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        var snapshot = collectionViewDataSource.snapshot()
        snapshot.deleteAllItems()
        collectionViewDataSource.apply(snapshot)
    }
}

extension SearchViewController: SearchResultDelegate {
    func searchResult(_ viewController: SearchResultViewController, itemIdentifier: String) {
        searchController.showsSearchResultsController = false
        searchController.searchBar.text = itemIdentifier
        searchController.searchBar.resignFirstResponder()
        writeRecentSearchUserDefault()
        fetchSearchResultData()
    }
}

extension SearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let viewController = PhotoDetailViewController.create(photoStore: photoStore)
        viewController.delegate = self
        viewController.targetIndexPath = indexPath
        navigationController?.pushViewController(viewController, animated: true)
    }
}

extension SearchViewController: PhotoDetailViewDelegate {
    func photoDetailView(_ controller: PhotoDetailViewController, didDisplayAt indexPath: IndexPath) {
        collectionView.scrollToItem(at: indexPath, at: .centeredVertically, animated: true)
    }
    
    func photoDetailView(_ controller: PhotoDetailViewController, didDisplay lastIndexPath: IndexPath) {
    }
}


