//
//  HomeHeaderCollectionViewCell.swift
//  ARGallery
//
//  Created by 董静 on 6/30/21.
//

import UIKit


protocol HomeCollectionViewCellDelegae {
    func didSelectVREnter()
}

class HomeHeaderCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "HomeHeaderCollectionViewCell"
    var delegate: HomeCollectionViewCellDelegae?

    
    private var VRButton : UIButton = {
        let button = UIButton()
        //button.addTarget(self, action: #selector(VRButtonSelected), for: .touchUpInside)
        button.backgroundColor = nil
        return button
    }()
    
    private var vrlabel : UILabel = {
        let label = UILabel()
        label.text = "ENTER VR"
        label.textColor = .black
        label.font = .systemFont(ofSize: 22)
        label.textAlignment = .center
        return label
    }()
    
    private var artImageView: UIImageView = {
        let imageview = UIImageView()
        imageview.clipsToBounds = true
        imageview.contentMode = .scaleAspectFit
        imageview.image = UIImage(named: "3dicon")
        return imageview
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        addSubview(artImageView)
        addSubview(vrlabel)
        // addSubview(VRButton) 
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        vrlabel.frame = CGRect(x: 0, y: 70, width: width, height: 20)
        artImageView.frame = CGRect(x: (width - 120)/2, y: height - 120 , width:  120, height: 120)
        VRButton.frame = artImageView.frame
    }
    
    @objc func VRButtonSelected() {
        delegate?.didSelectVREnter()
    }
}


