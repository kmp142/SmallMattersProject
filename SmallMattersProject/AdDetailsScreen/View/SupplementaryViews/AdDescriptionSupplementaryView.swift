//
//  AdDescriptionSupplementaryView.swift
//  SmallMattersProject
//
//  Created by Dmitry on 30.04.2024.
//

import Foundation
import UIKit

class AdDescriptionSupplementaryView: UICollectionReusableView {

    lazy var descriptionLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.textColor = .gray
        label.text = "Подробное описание:"
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: .zero)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView() {
        addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension UICollectionReusableView {
    static var reuseIdentifire: String {
        return String(describing: self)
    }
}
