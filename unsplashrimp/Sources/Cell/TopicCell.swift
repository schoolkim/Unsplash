//
//  TopicCell.swift
//  unsplashrimp
//
//  Created by HAKKYU KIM on 2022/05/21.
//

import UIKit

class TopicCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var selectionView: UIView!
    
    // 옵저빙중 바뀔때 didSet 실행
    override var isSelected: Bool {
        didSet {
            invalidateCell()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        invalidateCell()
    }
    
    func configureCell(itemIdentifier: UnTopic) {
        titleLabel.text = itemIdentifier.title
    }
    
    func invalidateCell() {
        selectionView.isHidden = !isSelected
        
        
    }

}
