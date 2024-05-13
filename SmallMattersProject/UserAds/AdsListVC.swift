
import Foundation
import UIKit

protocol ClassifiedsStorageViewControllerInterface {}

class AdsListViewController: UIViewController {

    //MARK: - Properties

    private lazy var addAdView: UIView = {
        let view = UIView()
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(addAdViewTapped))
        view.addGestureRecognizer(tapGR)
        view.backgroundColor = .systemCyan
        view.layer.cornerRadius = 10
        return view
    }()

    private lazy var addAdLabel: UILabel = {
        let label = UILabel()
        label.text = "Новое объявление"
        label.textColor = .white
        label.font = .systemFont(ofSize: 25, weight: .semibold)
        return label
    }()

    //MARK: - Initialization

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }

    //MARK: - View configuration

    private func configureView() {
        view.backgroundColor = .white
        view.addSubview(addAdView)
        addAdView.addSubview(addAdLabel)
        setupConstraints()
    }

    private func setupConstraints() {
        addAdView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(52)
            make.bottom.equalToSuperview().offset(-100)
        }

        addAdLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }

    @objc private func addAdViewTapped() {
        let addAdVC = AddAdVC()
        addAdVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(addAdVC, animated: true)
    }
}
