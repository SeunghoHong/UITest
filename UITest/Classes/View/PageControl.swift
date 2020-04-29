
import UIKit

import RxSwift
import RxCocoa


class PageControl: UIView {

    private var stackView = UIStackView()

    var numberOfPages = BehaviorRelay<Int>(value: 0)
    var currentPage = BehaviorRelay<Int>(value: 0)

    var pageIndicatorTintColor: UIColor = .gray
    var currentPageIndicatorTintColor: UIColor = .red

    private var disposeBag = DisposeBag()


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

        self.stackView.axis = .horizontal
        stackView.spacing = 6.0
        self.addSubview(self.stackView)
    }

    private func layout() {
        self.stackView.snp.makeConstraints { maker in
            maker.center.equalToSuperview()
        }
    }

    private func bind() {
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

        (0 ..< count).forEach { offset in
            let view = UIView()
            self.updateDotView(view, isCurrent: (offset == 0))
            self.stackView.addArrangedSubview(view)
        }
    }

    private func onCurrentPage(_ index: Int) {
        self.stackView.arrangedSubviews.enumerated().forEach { offset, view in
            self.updateDotView(view, isCurrent: (index == offset))
        }
    }

    private func updateDotView(_ dotView: UIView, isCurrent: Bool) {
        dotView.backgroundColor = isCurrent ? self.currentPageIndicatorTintColor : self.pageIndicatorTintColor
        dotView.snp.remakeConstraints { maker in
            maker.width.equalTo(isCurrent ? 12.0 : 6.0)
            maker.height.equalTo(6.0)
        }
    }
}
