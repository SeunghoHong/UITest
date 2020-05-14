
import UIKit

import RxSwift
import RxCocoa
import SnapKit


class ViewController: UIViewController {

    private var bannerVCButton = UIButton()
    private var userVCButton = UIButton()
    private var mainVCButton = UIButton()
    private var profileVCButton = UIButton()
    private var pageVCButton = UIButton()

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

        self.mainVCButton.setTitle("MainVC", for: .normal)
        self.mainVCButton.setTitleColor(.black, for: .normal)
        self.view.addSubview(self.mainVCButton)

        self.profileVCButton.setTitle("ProfileVC", for: .normal)
        self.profileVCButton.setTitleColor(.black, for: .normal)
        self.view.addSubview(self.profileVCButton)

        self.pageVCButton.setTitle("PageVCButton", for: .normal)
        self.pageVCButton.setTitleColor(.black, for: .normal)
        self.view.addSubview(self.pageVCButton)
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

        self.mainVCButton.snp.makeConstraints { maker in
            maker.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(16.0)
            maker.leading.equalTo(self.userVCButton.snp.trailing).offset(16.0)
        }

        self.profileVCButton.snp.makeConstraints { maker in
            maker.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(16.0)
            maker.leading.equalTo(self.mainVCButton.snp.trailing).offset(16.0)
        }

        self.pageVCButton.snp.makeConstraints { maker in
            maker.top.equalTo(self.bannerVCButton.snp.bottom).offset(16.0)
            maker.leading.equalToSuperview().offset(16.0)
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

        self.mainVCButton.rx.tap
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .bind { [weak self] _ in
                self?.onMainVC()
            }
            .disposed(by: self.disposeBag)

        self.profileVCButton.rx.tap
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .bind { [weak self] _ in
                self?.onProfileVC()
            }
            .disposed(by: self.disposeBag)

        self.pageVCButton.rx.tap
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .bind { [weak self] _ in
                self?.onPageVCButton()
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

    private func onMainVC() {
        let vc = Main_VC()
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true, completion: nil)
    }

    private func onProfileVC() {
        let vc = Profile_VC()
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true, completion: nil)
    }

    private func onPageVCButton() {
        let vc = Page_VC()
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true, completion: nil)
    }
}


