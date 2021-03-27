
import UIKit

import RxSwift
import RxCocoa
import SnapKit


class SlotCell: UICollectionViewCell {

    static let WIDTH: CGFloat = 56.0
    static let HEIGHT: CGFloat = 76.0

    private let effectView = UIView()
    private let borderView = UIView()
    private let imageView = UIImageView()
    private let nicknameLabel = UILabel()

    private var disposeBag = DisposeBag()
    private var reUsableDisposeBag = DisposeBag()


    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.setup()
        self.layout()
        self.bind()
    }
}

extension SlotCell {

    private func setup() {
//        self.effectView.backgroundColor = .blue
//        self.contentView.addSubview(self.effectView)

        self.borderView.backgroundColor = .clear
        self.borderView.layer.borderWidth = 2.0
        self.borderView.layer.borderColor = UIColor.black.cgColor
        self.contentView.addSubview(self.borderView)

        self.imageView.backgroundColor = .clear
        self.contentView.addSubview(self.imageView)

        self.nicknameLabel.backgroundColor = .clear
        self.nicknameLabel.layer.borderWidth = 1.0
        self.nicknameLabel.layer.borderColor = UIColor.black.cgColor
        self.nicknameLabel.textColor = .black
        self.nicknameLabel.textAlignment = .center
        self.nicknameLabel.font = UIFont.systemFont(ofSize: 12.0)
        self.contentView.addSubview(self.nicknameLabel)
    }

    private func layout() {
//        self.effectView.snp.makeConstraints { maker in
//            maker.center.equalTo(self.imageView.snp.center)
//            maker.width.height.equalTo(56.0)
//        }

        self.borderView.snp.makeConstraints { maker in
            maker.center.equalTo(self.imageView.snp.center)
            maker.width.height.equalTo(56.0)
        }

        self.imageView.snp.makeConstraints { maker in
            maker.top.equalToSuperview().offset(2.0)
            maker.centerX.equalToSuperview()
            maker.width.height.equalTo(52.0)
        }

        self.nicknameLabel.snp.makeConstraints { maker in
            maker.leading.trailing.bottom.equalToSuperview()
            maker.height.equalTo(12.0)
        }
    }

    private func bind() {
//        self.effectView.rx.layoutSubviews
//            .take(1)
//            .bind { [weak self] _ in
//                guard let self = self else { return }
//
//                self.effectView.circle = true
//                self.effectAnimation(with: 1.0)
//            }
//            .disposed(by: self.disposeBag)

        self.borderView.rx.layoutSubviews
            .take(1)
            .bind { [weak self] _ in
                guard let self = self else { return }

                self.borderView.circle = true
            }
            .disposed(by: self.disposeBag)

        self.imageView.rx.layoutSubviews
            .take(1)
            .bind { [weak self] _ in
                guard let self = self else { return }

                self.imageView.circle = true
            }
            .disposed(by: self.disposeBag)

        self.nicknameLabel.rx.layoutSubviews
            .take(1)
            .bind { [weak self] _ in
                guard let self = self else { return }

                self.nicknameLabel.ellipse = true
            }
            .disposed(by: self.disposeBag)
    }
}


extension SlotCell {

    private func effectAnimation(with volume: CGFloat) {
        let scale = 1.0 + (volume / 10.0)
        UIView.animate(withDuration: 0.5, delay: 1.0, options: [.autoreverse, .repeat]) {
            self.effectView.transform = CGAffineTransform(scaleX: scale, y: scale)
        } completion: { _ in
            self.effectView.transform = .identity
        }
    }
}
