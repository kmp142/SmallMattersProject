//
//  AdSpecificationsCVCell.swift
//  SmallMattersProject
//
//  Created by Dmitry on 30.04.2024.
//

import Foundation
import UIKit

protocol AdSpecificationsCVCellDelegate {
    func showAdOnMap()
}

class AdSpecificationsCVCell: UICollectionViewCell {

    //MARK: - Properties

    private lazy var addressLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17)
        return label
    }()

    private lazy var deadlineLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17)
        return label
    }()

    private lazy var minimalExecutorRaitingLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17)
        return label
    }()

    private lazy var showAdOnMapLabel: UILabel = {
        let label = UILabel()
        label.text = "Показать на карте"
        label.textColor = #colorLiteral(red: 0, green: 0.7505201697, blue: 1, alpha: 1)
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(showAdOnMapLabelTapped))
        label.addGestureRecognizer(tapGR)
        label.isUserInteractionEnabled = true
        return label
    }()

    private var delegate: AdSpecificationsCVCellDelegate?

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
        addSubview(addressLabel)
        addSubview(deadlineLabel)
        addSubview(minimalExecutorRaitingLabel)
        addSubview(showAdOnMapLabel)
        setupConstraints()
    }

    private func setupConstraints() {
        addressLabel.snp.makeConstraints { make in
            make.left.top.equalToSuperview()
        }

        deadlineLabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalTo(addressLabel.snp.bottom).offset(4)
        }

        minimalExecutorRaitingLabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalTo(deadlineLabel.snp.bottom).offset(4)
        }

        showAdOnMapLabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalTo(minimalExecutorRaitingLabel.snp.bottom).offset(4)
        }
    }

    func configureCell(with ad: Ad) {
        addressLabel.text = "Адрес: ул. Ленина 24"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy HH:mm"
        deadlineLabel.text = "Срок исполнения: \(dateFormatter.string(from: ad.deadline))"
        minimalExecutorRaitingLabel.text = "Рейтинг исполнителя от \(ad.minimalExecutorRating)"
    }

    func setupDelegate(_ delegate: AdSpecificationsCVCellDelegate) {
        self.delegate = delegate
    }

    //MARK: - Objc targets

    @objc private func showAdOnMapLabelTapped() {
        delegate?.showAdOnMap()
    }
}
