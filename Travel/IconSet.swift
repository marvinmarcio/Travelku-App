//
//  IconSet.swift
//  Travel
//
//  Created by Marvin Marcio on 25/04/21.
//

import Foundation

import UIKit

extension FloatingLabelInputDark {
func setIcon(_ image: UIImage) {
   let iconView = UIImageView(frame:
                  CGRect(x: 10, y: 2, width: 25, height: 25))
   iconView.image = #imageLiteral(resourceName: "onlylogo")
   let iconContainerView: UIView = UIView(frame:
                  CGRect(x: 20, y: 0, width: 30, height: 30))
   iconContainerView.addSubview(iconView)
   rightView = iconContainerView
   rightViewMode = .always
}
}
