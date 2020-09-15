//
//  UIImageView+Extension.swift
//  Combine-UIKit
//
//  Created by Emilio Vásquez on 9/13/20.
//  Copyright © 2020 Emilio Vásquez. All rights reserved.
//

import Foundation
import Kingfisher

extension UIImageView {
    func fetchImageCached(from url: String) {
        guard let urlImage = URL(string: url) else {
            self.image = UIImage(named: "avatar")
            return
        }
        let placeholder = UIImage(named: "avatar")
        let imageResource = ImageResource(downloadURL: urlImage)
        self.kf.indicatorType = .activity
        self.kf.setImage(with: imageResource, placeholder: placeholder, options: [.transition(.fade(0.2))]) { [weak self] result in
            switch result {
            case .failure:
                self?.image = UIImage(named: "avatar")
            default:
                return
            }
        }
    }
}
