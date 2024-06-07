//
//  RespondToAdCVCell.swift
//  SmallMattersProject
//
//  Created by Dmitry on 01.05.2024.
//

import Foundation
import UIKit

protocol RespondToAdCVCellDelegate {
    func respondViewTapped()
}

class RespondToAdCVCell: UICollectionViewCell {

    private lazy var respondView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0, green: 0.813554883, blue: 1, alpha: 1)
        view.layer.cornerRadius = 10
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(respondViewTapped))
        view.addGestureRecognizer(tapGR)
        return view
    }()

    private lazy var respondLabel: UILabel = {
        let label = UILabel()
        label.text = "Откликнуться"
        label.textColor = .white
        label.font = .systemFont(ofSize: 25, weight: .semibold)
        return label
    }()

    private var delegate: RespondToAdCVCellDelegate?

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
        contentView.addSubview(respondView)
        respondView.addSubview(respondLabel)
        setupConstraints()
    }

    private func setupConstraints() {
        respondView.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
        }

        respondLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }

    func setupDelegate(_ delegate: RespondToAdCVCellDelegate) {
        self.delegate = delegate
    }

    func configureCell(ad: Ad) {
        switch ad.state {
        case "active":
            respondLabel.text = "Откликнуться | \(Int(ad.bounty))"
        case "executing":
            respondLabel.text = "Подтвердить | \(Int(ad.bounty))"
            respondView.backgroundColor = #colorLiteral(red: 1, green: 0.399265945, blue: 0.4059134126, alpha: 1)
        case "executed":
            respondLabel.text = "Выполнено | \(Int(ad.bounty))"
            respondView.alpha = 0.5
        case "deleted":
            respondLabel.text = "Удалено | \(Int(ad.bounty))"
        default:
            respondView.isHidden = true
        }

    }

    //MARK: - Objc targets

    @objc private func respondViewTapped() {
        delegate?.respondViewTapped()
    }
}
