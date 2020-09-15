//
//  CharactersTableViewCell.swift
//  Combine-UIKit
//
//  Created by Emilio Vásquez on 9/13/20.
//  Copyright © 2020 Emilio Vásquez. All rights reserved.
//

import UIKit
import Kingfisher

class CharactersTableViewCell: UITableViewCell {
    @IBOutlet weak var characterImage: UIImageView!
    @IBOutlet weak var characterNameLabel: UILabel!
    @IBOutlet weak var characterOcupationLabel: UILabel!
    @IBOutlet weak var portrayedLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!

    func configureCell(imageURL: String?, name: String?, ocupation: String?, portrayed: String?, status: String?) {
        characterNameLabel.text = name
        characterOcupationLabel.text = ocupation
        portrayedLabel.text = portrayed
        statusLabel.text = status
        characterImage.fetchImageCached(from: imageURL ?? "")
    }
}
