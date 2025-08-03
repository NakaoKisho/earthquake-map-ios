//
//  ViewController.swift
//  earthquake-map
//
//  Created by 中尾 希翔 on 2025/07/27.
//

import GoogleMaps
import UIKit

class MapViewController: UIViewController, GMSMapViewDelegate {
    let map = GMSMapView(frame: .zero)
    
    override func loadView() {
        self.view = map
    }
}
