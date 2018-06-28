//
//  LocationListViewController.swift
//  OnTheMap
//
//  Created by Lucas César  Nogueira Fonseca on 26/06/2018.
//  Copyright © 2018 Lucas César  Nogueira Fonseca. All rights reserved.
//

import UIKit

class LocationListViewController: GenericViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension LocationListViewController:UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  UdacityUtils.shared.getStudents().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LocationTableViewCell.identifier, for: indexPath) as! LocationTableViewCell
        cell.config( UdacityUtils.shared.getStudents()[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let location =  UdacityUtils.shared.getStudents()[indexPath.row]
        openWithSafari(location.mediaURL ?? "")
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
}

extension LocationListViewController:GenericViewDelegate {
    func didUpdate() {
        tableView.reloadData()
    }
    
    
}
