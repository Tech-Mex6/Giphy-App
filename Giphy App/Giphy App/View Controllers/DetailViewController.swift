//
//  DetailViewController.swift
//  Giphy App
//
//  Created by meekam okeke on 1/18/22.
//

import UIKit
import SnapKit

class DetailViewController: UIViewController {
    var ID: String            = ""
    var gif: SearchData!
    var gifByID: [SearchData] = []
    
    var imageView        = UIImageView()
    var imageTitleLabel  = GATitleLabel(textAlignment: .center, fontSize: 18)
    var imageSourceLabel = GASecondaryTitleLabel(textAlignment: .center, fontSize: 16)
    var imageRatingLabel = GASecondaryTitleLabel(textAlignment: .center, fontSize: 16)
    
    init(ID: String) {
        super.init(nibName: nil, bundle: nil)
        self.ID = ID
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Gif Info Details"
        
        configureImageView()
        layoutUI()
        setImageViewConstraints()
        setTitleLabelConstraints()
        setSourceLabelConstraints()
        setRatingLabelConstraints()
        fetchGIFByID()
    }
    
    func configureImageView() {
        imageView.layer.cornerRadius = 15
        imageView.clipsToBounds = true
    }
    
    private func layoutUI() {
        view.addSubview(imageView)
        view.addSubview(imageTitleLabel)
        view.addSubview(imageSourceLabel)
        view.addSubview(imageRatingLabel)
        view.backgroundColor = .systemBackground
    }
    
    func setImageViewConstraints() {
        imageView.snp.makeConstraints { make in
            make.top.equalTo(view.layoutMarginsGuide).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(300)
        }
    }
    
    func setTitleLabelConstraints() {
        imageTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(10)
            make.centerX.equalTo(imageView.snp.centerX)
            make.leading.trailing.equalToSuperview().inset(20)
            
        }
    }
    
    func setSourceLabelConstraints() {
        imageSourceLabel.snp.makeConstraints { make in
            make.top.equalTo(imageTitleLabel.snp.bottom).offset(10)
            make.centerX.equalTo(imageView.snp.centerX)
            make.leading.trailing.equalToSuperview().inset(20)
        }
    }
    
    func setRatingLabelConstraints() {
        imageRatingLabel.snp.makeConstraints { make in
            make.top.equalTo(imageSourceLabel.snp.bottom).offset(10)
            make.centerX.equalTo(imageView.snp.centerX)
            make.leading.trailing.equalToSuperview().inset(20)
        }
    }
    
    func fetchGIFByID() {
        NetworkManager.shared.getDataByID(ID: ID) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case.success(let gifByID):
                self.gif = gifByID.data
                self.downloadGIF()
                DispatchQueue.main.async {
                    self.imageTitleLabel.text  = "Title: \(self.gif.title)"
                    self.imageSourceLabel.text = "Source: \(self.gif.sourceTld)"
                    self.imageRatingLabel.text = "Rating: \(self.gif.rating)"
                }
            case .failure(.invalidData):
                print("Invalid data")
            case .failure(.unableToComplete):
                print("Unable to complete")
            case .failure(.invalidResponse):
                print("Invalid response")
            }
        }
    }
    
    func downloadGIF() {
        guard let imageUrl = self.gif?.images.downsized.url else { return }
        NetworkManager.shared.downloadImage(from: imageUrl) { [weak self] image in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.imageView.image = image
            }
        }
    }
}
