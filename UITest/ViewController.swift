
import UIKit

import RxSwift
import RxCocoa
import SnapKit


class ViewController: UIViewController {

    private var bannerVCButton = UIButton()
    private var userVCButton = UIButton()

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


extension ViewController {

    private func setup() {
        self.view.backgroundColor = .white

        self.bannerVCButton.setTitle("BannerVC", for: .normal)
        self.bannerVCButton.setTitleColor(.black, for: .normal)
        self.view.addSubview(self.bannerVCButton)

        self.userVCButton.setTitle("UserVC", for: .normal)
        self.userVCButton.setTitleColor(.black, for: .normal)
        self.view.addSubview(self.userVCButton)
    }

    private func layout() {
        self.bannerVCButton.snp.makeConstraints { maker in
            maker.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(16.0)
            maker.leading.equalToSuperview().offset(16.0)
        }

        self.userVCButton.snp.makeConstraints { maker in
            maker.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(16.0)
            maker.leading.equalTo(self.bannerVCButton.snp.trailing).offset(16.0)
        }
    }

    private func bind() {
        self.bannerVCButton.rx.tap
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .bind { [weak self] _ in
                self?.onBannerVC()
            }
            .disposed(by: self.disposeBag)

        self.userVCButton.rx.tap
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .bind { [weak self] _ in
                self?.onUserVC()
            }
            .disposed(by: self.disposeBag)
    }
}


extension ViewController {

    private func onBannerVC() {
        let vc = Banner_VC()
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true, completion: nil)
    }

    private func onUserVC() {
        let vc = User_VC()
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true, completion: nil)
    }
}


