
import UIKit

import RxSwift
import RxCocoa
import RxGesture
import SnapKit


internal class EntendedPopup_VC: UIViewController {

    private let dimmedView = UIView()
    private let contentView = UIView()

    private let infoView = UIView()
    private let titleLabel = UILabel()

    private let tableView = UITableView()

    private var contentViewTopConstraint: Constraint?

    private var maxHeight: CGFloat = UIScreen.main.bounds.height - 64.0
    private var defaultHeight: CGFloat = 300.0
    private var currentHeight: CGFloat = 300.0
    private var locationY: CGFloat = 0.0

    private var newHeight = PublishRelay<CGFloat>()

    private var disposeBag = DisposeBag()

    private var data: [Int] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()

        (1..<30).forEach {
            self.data.append($0)
        }

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

        self.infoView.backgroundColor = .lightGray
        self.contentView.addSubview(self.infoView)

        self.titleLabel.text = "Extendable Popup"
        self.infoView.addSubview(self.titleLabel)

        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        self.tableView.height = 44.0
        self.tableView.bounces = false
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.contentView.addSubview(self.tableView)
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

        self.infoView.snp.makeConstraints { maker in
            maker.top.leading.trailing.equalToSuperview()
            maker.height.equalTo(64.0)
        }

        self.titleLabel.snp.makeConstraints { maker in
            maker.center.equalToSuperview()
        }

        self.tableView.snp.makeConstraints { maker in
            maker.top.equalTo(self.infoView.snp.bottom)
            maker.bottom.leading.trailing.equalToSuperview()
        }
    }

    private func bind() {
        self.contentView.rx.layoutSubviews
            .take(1)
            .bind { [weak self] _ in
                self?.contentView.radius([.topLeft, .topRight], radius: 12.0)
            }
            .disposed(by: self.disposeBag)

        self.newHeight.asDriver(onErrorJustReturn: self.defaultHeight)
            .distinctUntilChanged()
            .drive() {
                self.contentViewTopConstraint?.update(offset: -$0)
                self.view.layoutIfNeeded()
            }
            .disposed(by: self.disposeBag)

        self.contentView.rx.panGesture()
            .bind { [weak self] gesture in
                guard let self = self else { return }

                let velocity = gesture.velocity(in: self.view)
                let isDraggingDown = velocity.y > 0

                let location = gesture.location(in: self.view)

                defer {
                    self.locationY = location.y
                }

                switch gesture.state {
                case .changed:
                    guard self.tableView.contentOffset.y == 0.0 else { return }

                    self.currentHeight += (self.locationY - location.y)
                    self.currentHeight = min(self.maxHeight, self.currentHeight)
                    self.newHeight.accept(self.currentHeight)
                case .ended:
                    if self.currentHeight < self.defaultHeight {
                        if isDraggingDown {
                            self.dismissAnimation()
                        } else {
                            self.animateHeight(self.defaultHeight)
                        }
                    } else if self.currentHeight < self.maxHeight && isDraggingDown {
                        self.animateHeight(self.defaultHeight)
                    } else if self.currentHeight > self.defaultHeight && !isDraggingDown {
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


extension EntendedPopup_VC: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        cell.textLabel?.text = "\(self.data[indexPath.row])"

        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let constant = self.contentViewTopConstraint?.layoutConstraints.first?.constant, -constant < self.maxHeight {
            self.tableView.contentOffset = .zero
        }
    }
}
