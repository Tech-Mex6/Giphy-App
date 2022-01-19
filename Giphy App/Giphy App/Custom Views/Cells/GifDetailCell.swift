//
//  GifDetailCell.swift
//  Giphy App
//
//  Created by meekam okeke on 1/16/22.
//

import UIKit
import SnapKit

class GifDetailCell: UITableViewCell {
    
    var trending: TrendingData?
    var search: SearchData?
    var gifImageView  = UIImageView()
    var gifTitleLabel = GATitleLabel(textAlignment: .left, fontSize: 16)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(gifImageView)
        addSubview(gifTitleLabel)
        
        configureImageView()
        setImageViewConstraints()
        setTitleLabelConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setCellForTrendingData(trending: TrendingData) {
        self.trending      = trending
        downloadTrendingGif()
        gifTitleLabel.text = trending.title
    }
    
    func setCellForSearchData(search: SearchData) {
        self.search        = search
        downloadSearchedGIF()
        gifTitleLabel.text = search.title
    }
    
    func downloadTrendingGif() {
        guard let imageUrl = trending?.images.fixedHeightSmall.url else { return }
        NetworkManager.shared.downloadImage(from: imageUrl) { [weak self] image in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.gifImageView.image = image
            }
        }
    }
    
    func downloadSearchedGIF() {
        guard let imageUrl = search?.images.fixedHeightSmall.url else { return }
        NetworkManager.shared.downloadImage(from: imageUrl) { [weak self] image in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.gifImageView.image = image
            }
        }
    }
    
    func configureImageView() {
        gifImageView.layer.cornerRadius = 10
        gifImageView.clipsToBounds      = true
    }
    
    func setImageViewConstraints() {
        gifImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(10)
            make.height.equalTo(100)
            make.width.equalTo(100)
        }
    }
    
    func setTitleLabelConstraints() {
        gifTitleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(gifImageView.snp.centerY)
            make.leading.equalTo(gifImageView.snp.trailing).offset(10)
            make.height.equalTo(20)
            make.trailing.equalToSuperview().offset(-10)
        }
    }
    
}
