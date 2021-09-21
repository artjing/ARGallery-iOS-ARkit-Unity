//
//  HomeCollectionViewCell.swift
//  ARGallery
//
//  Created by 董静 on 6/30/21.
//

import UIKit

class HomeCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "homeCollectionViewCell"
    
    // MARK: - VIEWS

    
    private var artImageView: UIImageView = {
        let imageview = UIImageView()
        imageview.clipsToBounds = true
        imageview.contentMode = .scaleToFill
        imageview.image = UIImage(named: "2")
        return imageview
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .secondarySystemBackground
        contentView.addSubview(artImageView)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        artImageView.frame = contentView.bounds
    }

}
