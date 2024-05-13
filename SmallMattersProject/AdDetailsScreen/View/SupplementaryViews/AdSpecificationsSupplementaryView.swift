//
//  AdSpecificationsSupplementaryView.swift
//  SmallMattersProject
//
//  Created by Dmitry on 30.04.2024.
//

import Foundation
import UIKit

class AdSpecificationsSupplementaryView: UICollectionReusableView {

    private lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.text = "Параметры объявления:"
        label.font = .systemFont(ofSize: 20, weight: .semibold)
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
        addSubview(headerLabel)
        headerLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
