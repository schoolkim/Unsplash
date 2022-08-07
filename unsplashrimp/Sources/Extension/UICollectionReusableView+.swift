//
//  UICollectionReusableView+.swift
//  unsplashrimp
//
//  Created by HAKKYU KIM on 2022/07/23.
//

import Foundation
import UIKit

extension UICollectionReusableView {
    class var nib: UINib {
        UINib(nibName: String(describing: Self.self), bundle: .main)
    }
}
