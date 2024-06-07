//
//  AdCommunicationWithAuthorCVCell.swift
//  SmallMattersProject
//
//  Created by Dmitry on 01.05.2024.
//

import Foundation
import UIKit

protocol AdCommunicationWithAuthorCVCellDelegate {
    func callPressed()
    func messagePressed()
}

class AdCommunicationWithAuthorCVCell: UICollectionViewCell {

    //MARK: - Properties

    private lazy var callView: UIView = {
        let view = UIView()
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(callViewTapped))
        view.addGestureRecognizer(tapGR)
        view.layer.cornerRadius = 10
        view.backgroundColor = #colorLiteral(red: 0, green: 1, blue: 0.07778935879, alpha: 1)
        return view
    }()

    private lazy var callLabel: UILabel = {
        let label = UILabel()
        label.text = "Позвонить"
        label.textColor = .white
        label.font = .systemFont(ofSize: 25, weight: .semibold)
        return label
    }()

    private lazy var messageView: UIView = {
        let view = UIView()
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(messageViewTapped))
        view.addGestureRecognizer(tapGR)
        view.layer.cornerRadius = 10
        view.backgroundColor = #colorLiteral(red: 0.7130681276, green: 0, blue: 1, alpha: 1)
        return view
    }()

    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.text = "Написать"
        label.textColor = .white
        label.font = .systemFont(ofSize: 25, weight: .semibold)
        return label
    }()

    private var authorPhoneNumber: String?
    private var authorTelegramNameId: String?

    private var delegate: AdCommunicationWithAuthorCVCellDelegate?

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
        contentView.addSubview(callView)
        contentView.addSubview(messageView)
        callView.addSubview(callLabel)
        messageView.addSubview(messageLabel)
        setupConstraints()
    }

    private func setupConstraints() {
        callView.snp.makeConstraints { make in
            make.left.top.bottom.equalToSuperview()
            make.height.equalTo(52)
            make.right.equalTo(contentView.snp.centerX).offset(-4)
        }

        callLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }

        messageView.snp.makeConstraints { make in
            make.top.bottom.right.equalToSuperview()
            make.height.equalTo(52)
            make.left.equalTo(contentView.snp.centerX).offset(4)
        }

        messageLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }

    func setupDelegate(_ delegate: AdCommunicationWithAuthorCVCellDelegate) {
        self.delegate = delegate
    }

    func setCredentials(user: User) {
        authorPhoneNumber = user.phoneNumber
        authorTelegramNameId = user.telegramNameId
    }


    //MARK: - Objc targets

    @objc private func callViewTapped() {
        delegate?.callPressed()
    }

    @objc private func messageViewTapped() {
        delegate?.messagePressed()
    }
}
