
import UIKit

import RxSwift
import RxCocoa
import SnapKit


class Notice_VC: UIViewController {

    private var bannerView = BannerView()
    private var closeButton = UIButton()

    private var viewModel: Notice_VM?
    private var disposeBag = DisposeBag()


    override func viewDidLoad() {
        super.viewDidLoad()

        self.setup()
        self.layout()
        self.bind()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
}


extension Notice_VC {

    private func setup() {
        self.view.backgroundColor = .white

        self.bannerView.backgroundColor = .lightGray
        self.view.addSubview(self.bannerView)

        self.closeButton.setTitle("close", for: .normal)
        self.closeButton.setTitleColor(.black, for: .normal)
        self.view.addSubview(self.closeButton)
    }

    private func layout() {
        self.bannerView.snp.makeConstraints { maker in
            maker.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(16.0)
            maker.bottom.leading.trailing.equalToSuperview()
        }

        self.closeButton.snp.makeConstraints { maker in
            maker.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(16.0)
            maker.leading.equalToSuperview().offset(16.0)
        }
    }

    private func bind() {
        self.closeButton.rx.tap
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .bind { [weak self] _ in
                self?.onClose()
            }
            .disposed(by: self.disposeBag)
    }
}


extension Notice_VC {

    func bind(_ viewModel: Notice_VM) {
        self.viewModel = viewModel
    }
}


extension Notice_VC {

    private func onClose() {
        self.dismiss(animated: true, completion: nil)
    }
}
