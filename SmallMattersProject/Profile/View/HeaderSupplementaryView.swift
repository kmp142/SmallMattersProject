//
//  HeaderSupplementaryView.swift
//  SmallMattersProject
//
//  Created by Dmitry on 21.04.2024.
//

import Foundation
import UIKit

class HeaderSupplementaryView: UICollectionReusableView {

    //MARK: - Properties

    lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.text = "Отзывы"
        label.font = UIFont.systemFont(ofSize: 30)
        label.textColor = .black
        return label
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
        addSubview(headerLabel)
        headerLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(16)
        }
    }

    func configureView(headerName: String) {
        headerLabel.text = headerName
    }
}
