
import UIKit

import RxSwift
import RxCocoa
import SnapKit


class Visualizer: UIView {

    enum VerticalAligh {
        case top
        case center
        case bottom
    }

    private var stackView = UIStackView()

    private var disposeBag = DisposeBag()

    var align: UIStackView.Alignment = .bottom
    var spacing: CGFloat = 2.0
    var max: CGFloat = 64.0
    var min: CGFloat = 26.0

    var interval = 300


    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.rx.layoutSubviews
            .take(1)
            .bind { [weak self] _ in
                guard let self = self else { return }
                self.setup()
                self.layout()
                self.bind()
            }
            .disposed(by: self.disposeBag)
    }
}


extension Visualizer {

    private func setup() {
        self.backgroundColor = .darkGray

        self.stackView.axis = .horizontal
        self.stackView.alignment = self.align
        self.stackView.distribution = .fillEqually
        self.stackView.spacing = 2.0
        self.addSubview(self.stackView)

        (0...9).forEach { index in
            LogD("\(index)")
            let view = UIView()
            view.backgroundColor = .white
            self.stackView.addArrangedSubview(view)
        }
    }

    private func layout() {
        self.stackView.snp.makeConstraints { maker in
            maker.leading.trailing.equalToSuperview()
            maker.centerX.equalToSuperview()
            switch self.align {
            case .top:      maker.top.equalToSuperview()
            case .center:   maker.centerY.equalToSuperview()
            default:        maker.bottom.equalToSuperview()
            }
        }

        self.stackView.arrangedSubviews.forEach { view in
            view.snp.remakeConstraints { maker in
                maker.height.equalTo(self.min)
            }
        }
    }

    private func bind() {
        
    }
}


extension Visualizer {

    func start() {
        self.disposeBag = DisposeBag()

        Observable<Int>.interval(.milliseconds(300), scheduler: MainScheduler.instance)
            .bind { [weak self] _ in
                guard let self = self else { return }

                self.stackView.arrangedSubviews.forEach { view in
                    view.snp.remakeConstraints { maker in
                        maker.height.equalTo(CGFloat.random(in: self.min..<self.max))
                    }

                    UIView.animate(withDuration: 0.3) {
                        self.layoutIfNeeded()
                    }
                }
            }
            .disposed(by: self.disposeBag)
    }

    func stop() {
        self.disposeBag = DisposeBag()

        self.stackView.arrangedSubviews.forEach { view in
            view.snp.remakeConstraints { maker in
                maker.height.equalTo(self.min)
            }

            UIView.animate(withDuration: 0.3) {
                self.layoutIfNeeded()
            }
        }
    }
}

