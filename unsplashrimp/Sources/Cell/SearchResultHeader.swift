//
//  SearchResultHeader.swift
//  unsplashrimp
//
//  Created by HAKKYU KIM on 2022/07/23.
//

import UIKit

class SearchResultHeader: UICollectionReusableView {
    
    var rightButtonAction: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func didTapRightButton(_ sender: Any) {
        rightButtonAction?()
    }
    
}
