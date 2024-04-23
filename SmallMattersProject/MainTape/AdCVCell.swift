//
//  ClassfieldCVCell.swift
//  SmallMattersProject
//
//  Created by Dmitry on 20.03.2024.
//

import UIKit

class AdCVCell: UICollectionViewCell {

    //MARK: - Properties

    private lazy var adNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        return label
    }()

    private lazy var bountyAmountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 25, weight: .semibold)
        label.textAlignment = .right
        return label
    }()

    private lazy var distanceToAdLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        return label
    }()

    private lazy var deadlineLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        return label
    }()

    private lazy var deadlineIndicatorImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = iv.image?.withRenderingMode(.alwaysTemplate)
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 6
        return iv
    }()

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
        addSubviews(subviews: adNameLabel, bountyAmountLabel, distanceToAdLabel, deadlineLabel, deadlineIndicatorImageView)
        setupConstraints()
    }

    private func setupConstraints() {
        adNameLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(16)
            make.right.equalToSuperview().inset(DeviceScreenParams.screenWidth * 0.25)
            make.top.equalToSuperview().inset(16)
        }

        distanceToAdLabel.snp.makeConstraints { make in
            make.left.equalTo(adNameLabel.snp.left)
            make.right.equalTo(bountyAmountLabel.snp.left)
            make.top.equalTo(adNameLabel.snp.bottom).offset(4)
        }

        deadlineLabel.snp.makeConstraints { make in
            make.top.equalTo(distanceToAdLabel.snp.bottom)
            make.left.equalTo(adNameLabel.snp.left)
        }

        deadlineIndicatorImageView.snp.makeConstraints { make in
            make.centerY.equalTo(deadlineLabel.snp.centerY).offset(1)
            make.left.equalTo(deadlineLabel.snp.right).offset(2)
            make.width.height.equalTo(12)
        }

        bountyAmountLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-16)
            make.width.equalTo(92)
        }
    }

    func configureCell(with ad: Ad) {
        adNameLabel.text = ad.name
        bountyAmountLabel.text = "\(Int(ad.bounty)) р"
        deadlineLabel.text = "Срок исполнения: "
        deadlineIndicatorImageView.image = DeadlineIndicator.getImageByDeadline(date: ad.deadline)
        distanceToAdLabel.text = "300м. от вас"
        if let distanceToUser = ad.distanceToUser {
            switch distanceToUser {
            case 0...9999:
                distanceToAdLabel.text = "\(Int(distanceToUser)) м. от вас"
            default:
                distanceToAdLabel.text = "\(Int(distanceToUser / 1000)) км. от вас"
            }
        }
    }

    private func addSubviews(subviews: UIView...) {
        subviews.forEach { contentView.addSubview($0)}
    }
}


extension UICollectionViewCell {
    static var reuseIdentifier: String {
            return String(describing: self)
    }
}
