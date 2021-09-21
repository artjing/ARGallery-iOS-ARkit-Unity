//
//  HomeViewController.swift
//  ARGallery
//
//  Created by 董静 on 6/30/21.
//

import UIKit

enum BrowseSectionType {
    case newRelease
    case featuredPiece
    case recommendedPiece
}

    // MARK: - Protocal function
class HomeViewController: UIViewController, HomeCollectionViewCellDelegae {
    
    // Conformance to a protocol
    func didSelectVREnter() {
        AppDelegate().initAndShowUnity()
    }
    
    
    // MARK: - Lift Cycle
    private var collectionView : UICollectionView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView?.frame = view.bounds
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationBar()
    }
    
    // MARK: - Private Functions
    func setNavigationBar() {
        
        // add subviews
        addCollectionView()
        
        // setting
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis"), style: .plain, target: nil, action: nil)
        self.navigationItem.rightBarButtonItem?.tintColor = .white
        self.title = "Online Gallery"
        self.navigationItem.titleView?.tintColor = .white
        self.navigationController?.navigationBar.topItem?.title = "Online Gallery"
        self.navigationController?.navigationBar.tintColor = UIColor.white
    }
    
    // add collection view
    func addCollectionView() {
        
        // layout
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: (view.width-4)/3, height: (view.width-4)/3)
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 1.0
        layout.minimumInteritemSpacing = 1.0
        
        // collectionView
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { sectionIndex , _ -> NSCollectionLayoutSection? in
            return self.createSectionLayout(section: sectionIndex)
        }))
        
        // delegate
        collectionView?.delegate = self
        collectionView?.dataSource = self
        
        // register cell
        collectionView?.register(HomeCollectionViewCell.self, forCellWithReuseIdentifier: HomeCollectionViewCell.identifier)
        collectionView?.register(HomeHeaderCollectionViewCell.self, forCellWithReuseIdentifier: HomeHeaderCollectionViewCell.identifier)
        
        guard let collectionView = collectionView else {
            return
        }
        view.addSubview(collectionView)
    }
    
    // create collectionLayoutSection
    private func createSectionLayout(section: Int) -> NSCollectionLayoutSection{
        
        switch section {
        case 1:
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
                                                widthDimension: .fractionalWidth(1.0),
                                                heightDimension: .fractionalWidth(1.0)))
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
            
            let verticalGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(360)),
                subitem: item,
                count: 3
            )
            
            let horizontalGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(360)),
                subitem: verticalGroup,
                count: 1
            )
            
            let section = NSCollectionLayoutSection(group: horizontalGroup)
            section.orthogonalScrollingBehavior = .continuous
            return section
        
        case 2:
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
                                                widthDimension: .absolute(250),
                                                heightDimension: .absolute(500)))
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
            
            let verticalGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .absolute(250),
                    heightDimension: .absolute(500)),
                subitem: item,
                count: 2
            )
            
            let horizontalGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .absolute(250),
                    heightDimension: .absolute(500)),
                subitem: verticalGroup,
                count: 1
            )
            
            let section = NSCollectionLayoutSection(group: horizontalGroup)
            section.orthogonalScrollingBehavior = .continuous
            return section
        
        default:
            
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
                                                widthDimension: .fractionalWidth(1.0),
                                                heightDimension: .fractionalWidth(1.0)))
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
            
            let verticalGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(220)),
                subitem: item,
                count: 1
            )
            
            let horizontalGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(220)),
                subitem: verticalGroup,
                count: 1
            )
            
            let section = NSCollectionLayoutSection(group: horizontalGroup)
            section.orthogonalScrollingBehavior = .continuous
            return section
        }
    }
}

// MARK: - collection protocal function
extension HomeViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout:
                            UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            return CGSize(width: collectionView.width, height: 220)
        }
        
        return CGSize(width: collectionView.width, height: 220)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // VR cell
        if indexPath.section == 0 {
            let header = collectionView.dequeueReusableCell(withReuseIdentifier: HomeHeaderCollectionViewCell.identifier, for: indexPath) as! HomeHeaderCollectionViewCell
            return header
        }
        
        // AR cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCollectionViewCell.identifier, for: indexPath) as! HomeCollectionViewCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: false)
        
        if indexPath.section == 0 {
            didSelectVREnter()
            return
        }
        let story = UIStoryboard(name: "ModelSCNView", bundle: nil)
        let vc = story.instantiateViewController(withIdentifier: "ModelSCNView") as! ViewController
        if indexPath.row < 7 {
            vc.currentNumber = indexPath.row + 1
        }
        navigationController?.pushViewController(vc, animated: true)
        
    }
}
