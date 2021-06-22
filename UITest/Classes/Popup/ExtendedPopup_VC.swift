
import UIKit

import RxSwift
import RxCocoa
import RxGesture
import SnapKit


internal class EntendedPopup_VC: UIViewController {

    private let dimmedView = UIView()
    private let contentView = UIView()

    private var contentViewTopConstraint: Constraint?

    private var maxHeight: CGFloat = UIScreen.main.bounds.height
    private var defaultHeight: CGFloat = 300.0
    private var currentHeight: CGFloat = 300.0

    private var disposeBag = DisposeBag()


    override func viewDidLoad() {
        super.viewDidLoad()

        self.setup()
        self.layout()
        self.bind()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        self.showAnimation()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
}


extension EntendedPopup_VC {

    private func setup() {
        self.view.backgroundColor = .clear

        self.dimmedView.backgroundColor = .black
        self.dimmedView.alpha = 0.0
        self.view.addSubview(self.dimmedView)

        self.contentView.backgroundColor = .yellow
        self.view.addSubview(self.contentView)
    }

    private func layout() {
        self.dimmedView.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }

        self.contentView.snp.makeConstraints { maker in
            maker.leading.trailing.equalToSuperview()
            maker.height.equalToSuperview()
            self.contentViewTopConstraint = maker.top.equalTo(self.view.snp.bottom).constraint
        }
    }

    private func bind() {
        self.contentView.rx.layoutSubviews
            .take(1)
            .bind { [weak self] _ in
                self?.contentView.radius([.topLeft, .topRight], radius: 12.0)
            }
            .disposed(by: self.disposeBag)

        self.contentView.rx.panGesture()
            .bind { [weak self] gesture in
                guard let self = self else { return }

                let velocity = gesture.velocity(in: self.view)
                let isDraggingDown = velocity.y > 0

                let translation = gesture.translation(in: self.view)
                let newHeight = self.currentHeight - translation.y

                switch gesture.state {
                case .changed:
                    if newHeight < self.maxHeight {
                        self.contentViewTopConstraint?.update(offset: -newHeight)
                        self.view.layoutIfNeeded()
                    }
                case .ended:
                    if newHeight < self.defaultHeight {
                        if isDraggingDown {
                            self.dismissAnimation()
                        } else {
                            self.animateHeight(self.defaultHeight)
                        }
                    } else if newHeight < self.maxHeight && isDraggingDown {
                        self.animateHeight(self.defaultHeight)
                    } else if newHeight > self.defaultHeight && !isDraggingDown {
                        self.animateHeight(self.maxHeight)
                    }
                default:
                    break
                }
            }
            .disposed(by: self.disposeBag)

        self.dimmedView.rx.anyGesture(.tap(), .swipe(direction: .down))
            .bind { [weak self] _ in
                guard let self = self,
                      self.dimmedView.alpha >= 0.6
                else { return }

                self.dismissAnimation()
            }
            .disposed(by: self.disposeBag)
    }
}


extension EntendedPopup_VC {

    private func showAnimation() {
        UIView.animate(withDuration: 0.3) {
            self.dimmedView.alpha = 0.6
            self.contentViewTopConstraint?.update(offset: -self.defaultHeight)

            self.view.layoutIfNeeded()
        }
    }

    private func dismissAnimation() {
        UIView.animate(withDuration: 0.3) {
            self.dimmedView.alpha = 0.0
            self.contentViewTopConstraint?.update(offset: 0.0)

            self.view.layoutIfNeeded()
        } completion: { _ in
            self.dismiss(animated: false, completion: nil)
        }
    }

    private func animateHeight(_ height: CGFloat) {
        UIView.animate(withDuration: 0.3) {
            self.contentViewTopConstraint?.update(offset: -height)
            
            self.view.layoutIfNeeded()
        }

        self.currentHeight = height
    }
}
