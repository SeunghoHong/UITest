
import UIKit

import RxSwift
import RxCocoa


class PageControl: UIView {

    private var view = UIView()
    private var totalLabel = UILabel()
    private var currentLabel = UILabel()

    private var stackView = UIStackView()

    private var disposeBag = DisposeBag()

    var numberOfPages = BehaviorRelay<Int>(value: 0)
    var currentPage = BehaviorRelay<Int>(value: 0)


    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.setup()
        self.layout()
        self.bind()
    }
}


extension PageControl {

    private func setup() {
        self.backgroundColor = .clear

        self.addSubview(self.view)
        self.totalLabel.textColor = .black
        self.totalLabel.font = UIFont.systemFont(ofSize: 12.0)
        self.view.addSubview(self.totalLabel)
        self.currentLabel.textColor = .black
        self.currentLabel.font = UIFont.systemFont(ofSize: 12.0)
        self.view.addSubview(self.currentLabel)

        self.stackView.axis = .horizontal
        stackView.spacing = 6.0
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.stackView)
    }

    private func layout() {
        self.view.snp.makeConstraints { maker in
            maker.leading.equalToSuperview()
            maker.centerY.equalToSuperview()
        }

        self.totalLabel.snp.makeConstraints { maker in
            maker.leading.equalToSuperview()
            maker.centerY.equalToSuperview()
        }

        self.currentLabel.snp.makeConstraints { maker in
            maker.leading.equalTo(self.totalLabel.snp.trailing).offset(16.0)
            maker.centerY.equalToSuperview()
            maker.trailing.equalToSuperview()
        }

        self.stackView.snp.makeConstraints { maker in
//            maker.center.equalToSuperview()
            maker.trailing.top.bottom.equalToSuperview()
            maker.width.equalTo(256.0)
//            maker.width.lessThanOrEqualToSuperview()
//            maker.height.lessThanOrEqualToSuperview()
//            maker.edges.equalToSuperview()
        }
    }

    private func bind() {
        self.numberOfPages.asDriver()
            .map { "\($0)" }
            .drive(self.totalLabel.rx.text)
            .disposed(by: self.disposeBag)

        self.currentPage.asDriver()
            .map { "\($0)" }
            .drive(self.currentLabel.rx.text)
            .disposed(by: self.disposeBag)

        self.numberOfPages.asDriver()
            .filter { $0 != 0 }
            .drive(onNext: { [weak self] count in
                self?.onNumberOfPages(count)
            })
            .disposed(by: self.disposeBag)

        self.currentPage.asDriver()
            .drive(onNext: { [weak self] index in
                self?.onCurrentPage(index)
            })
            .disposed(by: self.disposeBag)
    }
}


extension PageControl {

    private func onNumberOfPages(_ count: Int) {
        self.stackView.arrangedSubviews.forEach { view in
            self.stackView.removeArrangedSubview(view)
        }

        (0 ..< count).forEach { _ in
            let view = UIView()
            view.frame = CGRect(x: 0.0, y: 0.0, width: 6.0, height: 6.0)
            view.backgroundColor = .black
            self.stackView.addArrangedSubview(view)
        }
    }

    private func onCurrentPage(_ index: Int) {

    }
}
