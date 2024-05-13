//
//  AdDescriptionCVCell.swift
//  SmallMattersProject
//
//  Created by Dmitry on 29.04.2024.
//

import UIKit

class AdDescriptionCVCell: UICollectionViewCell {

    //MARK: - Properties

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17)
        label.numberOfLines = 0
        return label
    }()

    //MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: .zero)
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - View configuration

    private func configureCell() {
        contentView.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    func configureCell(with description: String) {
        descriptionLabel.text = description
    }
}
