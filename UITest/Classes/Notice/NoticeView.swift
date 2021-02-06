
import UIKit

import RxSwift
import RxCocoa
import SnapKit


class NotivcView: UIView {

    private var imageView = UIImageView()
    private var linkButton = UIButton()

    private var disposeBag = DisposeBag()


    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.setup()
        self.layout()
        self.bind()
    }
}


extension NotivcView {

    private func setup() {
        self.backgroundColor = .clear

        self.addSubview(self.imageView)
        self.addSubview(self.linkButton)
    }

    private func layout () {
        self.imageView.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }

        self.linkButton.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }
    }

    private func bind() {
        self.linkButton.rx.tap
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .bind { [weak self] _ in
                
            }
            .disposed(by: self.disposeBag)
    }
}
