//
//  ComplaintImagesView.swift
//  Profix
//
//  Created by Haneen on 28/12/2025.
//

import UIKit

class ComplaintImagesView: UIView {
    
    //MARK: - Outlets -
    
    @IBOutlet weak var imageUploadView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var title: UILabel!
    
    //MARK: - Properties -

    var maxImages: Int = 0  // 0 = unlimited
    var imagesList: [ComplaintImageItem] = []
    var presetUrls: [String] = []
    var onImagePicked: ((Data) -> Void)?
    
    @IBInspectable var titleTxt : String = "" {
        didSet {
            title.text = titleTxt.localized
        }
    }
   
    //MARK: - Initializer -
   
    override init(frame:CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureView()
    }
    
    //MARK: - Nib file configuration -
    
    func loadViewFromNib(nibName:String) -> UIView {
        let nib = UINib(nibName: nibName, bundle: nil)
        return nib.instantiate(withOwner: self, options: nil).first as! UIView
    }
    
    func configureView(){
        let view = loadViewFromNib(nibName: "ComplaintImagesView")
        view.frame = self.bounds
        self.addSubview(view)
        initialConfigurations()
    }
    
    func initialConfigurations(){
        configureCollectionView()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(onUploadViewTapped))
        imageUploadView.addGestureRecognizer(tap)
    }
    
    //MARK: - Actions -
    
    @objc func onUploadViewTapped(){
        guard maxImages == 0 || imagesList.count < maxImages else { return }
        let picker = ImagePicker()
        if maxImages == 1 {
            picker.pickImage { [weak self] image, data in
                guard let self, let data else { return }
                self.imagesList = [ComplaintImageItem(image: image, data: data)]
                self.collectionView.reloadData()
                self.updateUploadViewVisibility()
                self.onImagePicked?(data)
            }
        } else {
            picker.pickImages { [weak self] image, imageData in
                guard let self else { return }
                let newItem = zip(image, imageData).map {
                    ComplaintImageItem(image: $0.0, data: $0.1)
                }
                self.imagesList.append(contentsOf: newItem)
                self.collectionView.reloadData()
                self.updateUploadViewVisibility()
            }
        }
    }

    func setImage(url: String) {
        presetUrls = [url]
        collectionView.reloadData()
        updateUploadViewVisibility()
    }

    private func updateUploadViewVisibility() {
        guard maxImages > 0 else { return }
        imageUploadView.isHidden = (presetUrls.count + imagesList.count) >= maxImages
    }
}

//MARK: - CollectionView Configuration -

extension ComplaintImagesView : UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func configureCollectionView(){
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(cellType: ComplaintImageCell.self)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presetUrls.count + imagesList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(with: ComplaintImageCell.self, for: indexPath)
        cell.delegate = self
        if indexPath.row < presetUrls.count {
            cell.setupCell(url: presetUrls[indexPath.row], index: indexPath.row)
        } else {
            let item = imagesList[indexPath.row - presetUrls.count]
            cell.setupCell(image: item.image, index: indexPath.row)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 60, height: 60)
    }
}

//MARK: - Delelgation -

extension ComplaintImagesView: ComplaintImageCellProtocol {
    func didTapRemove(at index: Int) {
        if index < presetUrls.count {
            presetUrls.remove(at: index)
        } else {
            imagesList.remove(at: index - presetUrls.count)
        }
        collectionView.reloadData()
        updateUploadViewVisibility()
    }
}
