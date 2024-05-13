//
//  AdAuthorProfileCVCell.swift
//  SmallMattersProject
//
//  Created by Dmitry on 30.04.2024.
//

import Foundation
import UIKit

protocol AdAuthorProfileCVCellDelegate {
    func pressedOnProfileView()
}

class AdAuthorProfileCVCell: UICollectionViewCell {

    //MARK: - Properties

    private lazy var authorAvatarImageView: UIImageView = {
        let iv = UIImageView()
        return iv
    }()

    private lazy var authorNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 30, weight: .semibold)
        return label
    }()

    private lazy var authorRatingValueLabel: UILabel = {
        let label = UILabel()

        return label
    }()

    private lazy var authorRatingStarsStackView: UIStackView = {
        let sv = UIStackView()
        for _ in 0...4 {
            sv.addArrangedSubview(UIImageView(image: UIImage(named: "emptyStar")))
        }
        sv.axis = .horizontal
        sv.distribution = .fillEqually
        sv.spacing = 2
        return sv
    }()

    private var delegate: AdAuthorProfileCVCellDelegate?

    //MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: .zero)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - View configuration

    private func configureView() {
        contentView.addSubview(authorAvatarImageView)
        contentView.addSubview(authorNameLabel)
        contentView.addSubview(authorRatingValueLabel)
        contentView.addSubview(authorRatingStarsStackView)
        contentView.backgroundColor = .systemGray6
        contentView.layer.cornerRadius = 20
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(didTapContentView))
        contentView.addGestureRecognizer(tapGR)
        setupConstraints()
    }

    func configureCell(user: User) {
        authorAvatarImageView.image = UIImage(named: "bluePin")
        authorNameLabel.text = user.name
        authorRatingValueLabel.text = String(user.rating).prefix(3).replacingOccurrences(of: ".", with: ",")
        authorRatingStarsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        for i in 1...5 {
            let image = UIImage(named: i <= Int(user.rating) ? "filledStar" : "emptyStar")
            authorRatingStarsStackView.addArrangedSubview(UIImageView(image: image))
        }
    }

    private func setupConstraints() {
        authorAvatarImageView.snp.makeConstraints { make in
            make.height.width.equalTo(80)
            make.left.top.equalToSuperview().offset(16)
        }

        authorNameLabel.snp.makeConstraints { make in
            make.left.equalTo(authorAvatarImageView.snp.right).offset(16)
            make.centerY.equalTo(authorAvatarImageView.snp.centerY)
        }

        authorRatingValueLabel.snp.makeConstraints { make in
            make.top.equalTo(authorAvatarImageView.snp.bottom).offset(8)
            make.left.equalToSuperview().offset(12)
        }

        authorRatingStarsStackView.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.width.equalTo(108)
            make.left.equalTo(authorRatingValueLabel.snp.right).offset(16)
            make.bottom.equalTo(authorRatingValueLabel.snp.bottom)
        }
    }

    func setupDelegate(_ delegate: AdAuthorProfileCVCellDelegate) {
        self.delegate = delegate
    }

    //MARK: - Objc targets

    @objc private func didTapContentView() {
        delegate?.pressedOnProfileView()
    }
}
