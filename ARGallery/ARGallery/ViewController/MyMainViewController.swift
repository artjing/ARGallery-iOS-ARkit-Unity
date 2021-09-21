//
//  MainNavigationViewController.swift
//  ARGallery
//
//  Created by 董静 on 6/30/21.
//

import UIKit


class MyMainViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "NFT AR Gallery"
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 64))
        label.text = "NFT AR Gallery"
        navigationItem.titleView = label
        navigationController?.navigationBar.topItem?.titleView = label
        let vc = HomeViewController()
        self.addChild(vc)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationBar.backgroundColor = .black
    }
    
}

