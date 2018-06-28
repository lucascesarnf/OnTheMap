//
//  LocationTableViewCell.swift
//  OnTheMap
//
//  Created by Lucas César  Nogueira Fonseca on 26/06/2018.
//  Copyright © 2018 Lucas César  Nogueira Fonseca. All rights reserved.
//

import UIKit

class LocationTableViewCell: UITableViewCell {
    static let identifier = "LocationTableViewCell"

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    func config(_ info: StudentInformation) {
        titleLabel.text = (info.firstName ?? "") + " " + (info.lastName ?? "")
        subtitleLabel.text = info.mediaURL
    }
}
