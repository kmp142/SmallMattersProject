//
//  ProfileCVCell.swift
//  SmallMattersProject
//
//  Created by Dmitry on 20.04.2024.
//

import Foundation
import UIKit

protocol ProfileCVCellDelegate: AnyObject {
    func userAvatarImageTapped()
}

class ProfileCVCell: UICollectionViewCell {

    //MARK: - Properties

    private lazy var avatarImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "circle")
        iv.isUserInteractionEnabled = true
        iv.layer.cornerRadius = 50
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        return iv
    }()

    private lazy var nicknameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 35, weight: .medium)
        return label
    }()

    private lazy var ratingValueLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22, weight: .medium)
        return label
    }()

    private lazy var ratingStarsStackView: UIStackView = {
        let sv = UIStackView()
        for _ in 0...4 {
            sv.addArrangedSubview(UIImageView(image: UIImage(named: "emptyStar")))
        }
        sv.axis = .horizontal
        sv.distribution = .fillEqually
        sv.spacing = 2
        return sv
    }()

    private lazy var tasksResolvedByUserLabel: UILabel = {
        let label = UILabel()
        label.text = "Вы помогли решить: 10"
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        return label
    }()

    private lazy var tasksResolvedForUserLabel: UILabel = {
        let label = UILabel()
        label.text = "Вам помогли решить: 4"
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        return label
    }()

    private lazy var avatarTapGestureRecognizer = {
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(avatarImageViewTapped))
        return tapGR
    }()

    weak var delegate: ProfileCVCellDelegate?

    //MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: .zero)
        configureContentView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - View configuration

    func configureCell(with user: User) {
        avatarImageView.image = user.image
        avatarImageView.addGestureRecognizer(avatarTapGestureRecognizer)
        nicknameLabel.text = user.name
        ratingValueLabel.text = String(user.rating).prefix(3).replacingOccurrences(of: ".", with: ",")
        ratingStarsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        for i in 1...5 {
            let image = UIImage(named: i <= Int(user.rating) ? "filledStar" : "emptyStar")
            ratingStarsStackView.addArrangedSubview(UIImageView(image: image))
        }
    }

    private func configureContentView() {
        contentView.addSubview(avatarImageView)
        contentView.addSubview(nicknameLabel)
        contentView.addSubview(ratingValueLabel)
        contentView.addSubview(ratingStarsStackView)
        contentView.addSubview(tasksResolvedByUserLabel)
        contentView.addSubview(tasksResolvedForUserLabel)
        setupConstraints()
        avatarImageView.addGestureRecognizer(avatarTapGestureRecognizer)
    }

    private func setupConstraints() {

        avatarImageView.snp.makeConstraints { make in
            make.height.width.equalTo(100)
            make.top.equalToSuperview().offset(16)
            make.left.equalToSuperview()
        }

        nicknameLabel.snp.makeConstraints { make in
            make.left.equalTo(avatarImageView.snp.right).offset(28)
            make.centerY.equalTo(avatarImageView).offset(-16)
        }

        ratingValueLabel.snp.makeConstraints { make in
            make.top.equalTo(avatarImageView.snp.bottom).offset(12)
            make.left.equalTo(avatarImageView.snp.left)
        }

        ratingStarsStackView.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.width.equalTo(108)
            make.left.equalTo(ratingValueLabel.snp.right).offset(16)
            make.centerY.equalTo(ratingValueLabel.snp.centerY)
        }

        tasksResolvedByUserLabel.snp.makeConstraints { make in
            make.left.equalTo(ratingValueLabel.snp.left)
            make.top.equalTo(ratingValueLabel.snp.bottom)
            .offset(12)
        }

        tasksResolvedForUserLabel.snp.makeConstraints { make in
            make.left.equalTo(avatarImageView.snp.left)
            make.top.equalTo(tasksResolvedByUserLabel.snp.bottom).offset(4)
        }
    }

    //MARK: - Objc targets

    @objc private func avatarImageViewTapped() {
        delegate?.userAvatarImageTapped()
    }
}
