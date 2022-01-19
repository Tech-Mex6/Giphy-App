//
//  GASecondaryTitleLabel.swift
//  Giphy App
//
//  Created by meekam okeke on 1/16/22.
//

import UIKit

class GASecondaryTitleLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(textAlignment: NSTextAlignment, fontSize: CGFloat) {
        self.init(frame: .zero)
        self.textAlignment = textAlignment
        self.font          = UIFont.systemFont(ofSize: fontSize, weight: .medium)
        configure()
    }
    
    private func configure() {
        textColor                         = .secondaryLabel
        adjustsFontSizeToFitWidth         = true
        adjustsFontForContentSizeCategory = true
        minimumScaleFactor                = 0.75
        numberOfLines                     = 0
        lineBreakMode                     = .byWordWrapping
        translatesAutoresizingMaskIntoConstraints = false
    }
}
