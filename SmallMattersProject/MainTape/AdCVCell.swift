//
//  ClassfieldCVCell.swift
//  SmallMattersProject
//
//  Created by Dmitry on 20.03.2024.
//

import UIKit

class AdCVCell: UICollectionViewCell {

    private lazy var adNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 25, weight: .semibold)
//        label.backgroundColor = .lightGray
        return label
    }()

    private lazy var bountyAmountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 25, weight: .semibold)
        label.textAlignment = .right
//        label.backgroundColor = .blue
        return label
    }()

    private lazy var distanceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
//        label.backgroundColor = .orange
        return label
    }()

    private lazy var deadlineLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
//        label.backgroundColor = .systemGreen
        return label
    }()

    private lazy var deadlineIndicatorImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = iv.image?.withRenderingMode(.alwaysTemplate)
        return iv
    }()

    let leftIndent = DeviceScreenParams.screenWidth * 0.05

    private func setupConstraints() {
        adNameLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(leftIndent)
            make.right.equalToSuperview().inset(DeviceScreenParams.screenWidth * 0.25)
            make.top.equalToSuperview().inset(16)
            make.height.equalTo(40)
        }

        bountyAmountLabel.snp.makeConstraints { make in
            make.height.equalTo(DeviceScreenParams.screenWidth * 0.3)
            make.centerY.equalToSuperview()
            make.left.equalTo(adNameLabel.snp.right)
            make.right.equalToSuperview().offset(-leftIndent)
        }

        distanceLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(leftIndent)
            make.right.equalTo(bountyAmountLabel.snp.left)
            make.top.equalTo(adNameLabel.snp.bottom).offset(0)
        }

        deadlineLabel.snp.makeConstraints { make in
            make.top.equalTo(distanceLabel.snp.bottom)
            make.left.equalToSuperview().offset(leftIndent)
        }

        deadlineIndicatorImageView.snp.makeConstraints { make in
            make.centerY.equalTo(deadlineLabel.snp.centerY)
            make.left.equalTo(deadlineLabel.snp.right).offset(2)
            make.width.height.equalTo(12)
        }
    }

    func configureCell(with: Ad) {
        adNameLabel.text = with.name
        bountyAmountLabel.text = "\(Int(with.cost)) р"
        deadlineLabel.text = "Срок исполнения: "
        distanceLabel.text = "300 м. от вас"
        deadlineIndicatorImageView.image = DeadlineIndicator.getImageByDeadline(date: with.deadline)
    }

    override init(frame: CGRect) {
        super.init(frame: .zero)
        addSubviews(subviews: adNameLabel, bountyAmountLabel, distanceLabel, deadlineLabel, deadlineIndicatorImageView)
        setupConstraints()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.deadlineIndicatorImageView.layer.cornerRadius = self.deadlineIndicatorImageView.bounds.width / 2
        self.deadlineIndicatorImageView.clipsToBounds = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
