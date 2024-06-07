//
//  reviewCVCell.swift
//  SmallMattersProject
//
//  Created by Dmitry on 10.04.2024.
//

import Foundation
import UIKit

class ReviewCVCell: UICollectionViewCell {

    //MARK: - Properties

    lazy var adNameWithBountyLabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .darkGray
        return label
    }()


    lazy var reviewTextLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()

    lazy var publicationDateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()

    lazy var starsStackView: UIStackView = {
        let sv = UIStackView()
        for _ in 0...4 {
            sv.addArrangedSubview(UIImageView(image: UIImage(named: "emptyStar")))
        }
        sv.axis = .horizontal
        sv.spacing = 2
        sv.distribution = .fillEqually
        return sv
    }()

    //MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: .zero)
        configureContentView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - View configuration

    private func configureContentView() {
        contentView.addSubview(adNameWithBountyLabel)
        contentView.addSubview(reviewTextLabel)
        contentView.addSubview(publicationDateLabel)
        contentView.addSubview(starsStackView)
        setupConstraints()
    }

    private func setupConstraints() {
        adNameWithBountyLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(4)
            make.left.equalToSuperview().offset(16)
            make.right.equalTo(starsStackView.snp.left).offset(-4)
        }

        reviewTextLabel.snp.makeConstraints { make in
            make.left.equalTo(adNameWithBountyLabel.snp.left)
            make.right.equalToSuperview().offset(-16)
            make.top.equalTo(adNameWithBountyLabel.snp.bottom).offset(8)
        }

        starsStackView.snp.makeConstraints { make in
            make.right.equalTo(contentView.snp.right).offset(-16)
            make.top.equalTo(contentView.snp.top).offset(4)
            make.height.equalTo(16)
            make.width.equalTo(88)
        }

        publicationDateLabel.snp.makeConstraints { make in
            make.top.equalTo(reviewTextLabel.snp.bottom).offset(8)
            make.right.equalTo(contentView.snp.right).offset(-16)
            make.bottom.equalToSuperview().offset(-16)
        }
    }

    func configureCell(with review: Review) {
        adNameWithBountyLabel.text = "\(review.adTitleAndBounty)"
        reviewTextLabel.text = review.text

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        publicationDateLabel.text = dateFormatter.string(from: review.publicationDate)

        starsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        for i in 1...5 {
            let image = UIImage(named: i <= review.value ? "filledStar" : "emptyStar")
            starsStackView.addArrangedSubview(UIImageView(image: image))
        }
    }
}



