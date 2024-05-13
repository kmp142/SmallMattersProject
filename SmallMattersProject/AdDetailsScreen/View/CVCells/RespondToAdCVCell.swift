//
//  RespondToAdCVCell.swift
//  SmallMattersProject
//
//  Created by Dmitry on 01.05.2024.
//

import Foundation
import UIKit

protocol RespondToAdCVCellDelegate {

}

class RespondToAdCVCell: UICollectionViewCell {

    private lazy var respondView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0, green: 0.813554883, blue: 1, alpha: 1)
        view.layer.cornerRadius = 10
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
}
