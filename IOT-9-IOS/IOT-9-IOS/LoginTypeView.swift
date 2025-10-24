//
//  LoginTypeView.swift
//  IOT-9
//
//  Created by Thuận Nguyễn on 17/10/25.
//

import UIKit

class LoginTypeView: UIView {
    
    private let iconImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        // Config bo tròn
        self.layer.masksToBounds = true
        
        // Config UIImageView
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(iconImageView)
        
        // AutoLayout cho icon nằm giữa phía trên
        NSLayoutConstraint.activate([
            iconImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            iconImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 13),
            iconImageView.widthAnchor.constraint(equalToConstant: 24),
            iconImageView.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // Bo hết (hình pill/oval)
        self.layer.cornerRadius = min(self.frame.width, self.frame.height) / 2
    }
    
    // Public method để set icon từ ngoài
    func setIcon(_ image: UIImage?) {
        iconImageView.image = image
    }
}
