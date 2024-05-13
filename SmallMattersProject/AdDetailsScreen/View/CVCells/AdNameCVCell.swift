//
//  AdNameCVCell.swift
//  SmallMattersProject
//
//  Created by Dmitry on 29.04.2024.
//

import UIKit

class AdNameCVCell: UICollectionViewCell {

    //MARK: - Properties

    private lazy var adNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 25, weight: .semibold)
        label.textAlignment = .left
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
        contentView.addSubview(adNameLabel)
        adNameLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    func configureCell(with adName: String) {
        adNameLabel.text = adName
    }
}
