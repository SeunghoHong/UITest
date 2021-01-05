
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
    private var messageVCButton = UIButton()
    private var recorderVCButton = UIButton()
    private var pickerVCButton = UIButton()
    private var tooltipVCButton = UIButton()

    private var disposeBag = DisposeBag()


    override func viewDidLoad() {
        super.viewDidLoad()

        self.setup()
        self.layout()
        self.bind()

        self.test()
        self.checkLogin()
        self.checkLogin2()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
}


extension ViewController {

    enum UserError: Error {
        case errNo(Int)
        var localizedDescription: String {
            switch self {
            case .errNo(let status): return "error status \(status)"
            }
        }
    }

    enum LiveError: Error {
        case errNo(Int)
        var localizedDescription: String {
            switch self {
            case .errNo(let status): return "error status \(status)"
            }
        }
    }

    private func test() {
        Data.request(with: URL(string: "http://test.com/data")!)
            .retryWhen { e in
                e.enumerated().flatMap { (retry, error) -> Observable<Int> in
                    guard retry < 3 else { return Observable.never() }
                    return Observable<Int>.timer(.milliseconds(1000), scheduler: MainScheduler.instance)
                }
            }
            .bind { data in
                
            }
            .disposed(by: self.disposeBag)
    }

    private func login2(_ flag: Bool = true) throws {
        throw UserError.errNo(-1)
    }

    private func liveItem2(_ flag: Bool = true) throws -> String {
        throw LiveError.errNo(-2)
    }

    private func aaaa(_ bbbb: String) {

    }

    private func checkLogin2() {
        do {
            try self.login2()
            let _ = try self.liveItem2()
            self.aaaa(try self.liveItem2())
        } catch UserError.errNo(let code) {
            print("UserError \(code)")
        } catch LiveError.errNo(let code) {
            print("LiveError \(code)")
        } catch let e {
            print("\(e)")
        }
    }

    private func login(_ flag: Bool = true) -> Observable<Void> {
        return Observable<Void>.create { observer -> Disposable in
            if flag {
                observer.onNext(())
                observer.onCompleted()
            } else {
                observer.onError(NSError(domain: "", code: -1, userInfo: nil))
            }

            return Disposables.create()
        }
    }

    private func liveItem(_ flag: Bool = true) -> Observable<String> {
        return Observable<String>.create { observer -> Disposable in
            if flag {
                observer.onNext("12345")
                observer.onCompleted()
            } else {
                observer.onError(NSError(domain: "", code: -2, userInfo: nil))
            }

            return Disposables.create()
        }
    }

    private func checkLogin() {
        Observable.just(false)
            .flatMap { self.login($0) }
            .flatMap { self.liveItem() }
            .subscribe(onNext: { `id` in
                print("\(id)")
            }, onError: { error in
                guard let error = error as? NSError else { return }
                print("\(error.code)")
            })
            .disposed(by: self.disposeBag)
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

        self.pageVCButton.setTitle("PageVC", for: .normal)
        self.pageVCButton.setTitleColor(.black, for: .normal)
        self.view.addSubview(self.pageVCButton)

        self.messageVCButton.setTitle("MessageVC", for: .normal)
        self.messageVCButton.setTitleColor(.black, for: .normal)
        self.view.addSubview(self.messageVCButton)

        self.recorderVCButton.setTitle("RecorderVC", for: .normal)
        self.recorderVCButton.setTitleColor(.black, for: .normal)
        self.view.addSubview(self.recorderVCButton)

        self.pickerVCButton.setTitle("PickerVC", for: .normal)
        self.pickerVCButton.setTitleColor(.black, for: .normal)
        self.view.addSubview(self.pickerVCButton)

        self.tooltipVCButton.setTitle("TooltipVC", for: .normal)
        self.tooltipVCButton.setTitleColor(.black, for: .normal)
        self.view.addSubview(self.tooltipVCButton)
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

        self.messageVCButton.snp.makeConstraints { maker in
            maker.leading.equalTo(self.pageVCButton.snp.trailing).offset(16.0)
            maker.centerY.equalTo(self.pageVCButton.snp.centerY)
        }

        self.recorderVCButton.snp.makeConstraints { maker in
            maker.leading.equalTo(self.messageVCButton.snp.trailing).offset(16.0)
            maker.centerY.equalTo(self.pageVCButton.snp.centerY)
        }

        self.pickerVCButton.snp.makeConstraints { maker in
            maker.top.equalTo(self.pageVCButton.snp.bottom).offset(16.0)
            maker.leading.equalToSuperview().offset(16.0)
        }

        self.tooltipVCButton.snp.makeConstraints { maker in
            maker.leading.equalTo(self.pickerVCButton.snp.trailing).offset(16.0)
            maker.centerY.equalTo(self.pickerVCButton.snp.centerY)
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
                self?.onPageVC()
            }
            .disposed(by: self.disposeBag)

        self.messageVCButton.rx.tap
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .bind { [weak self] _ in
                self?.onMessageVC()
            }
            .disposed(by: self.disposeBag)

        self.recorderVCButton.rx.tap
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .bind { [weak self] _ in
                self?.onRecorderVC()
            }
            .disposed(by: self.disposeBag)

        self.pickerVCButton.rx.tap
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .bind { [weak self] _ in
                self?.onPickerVC()
            }
            .disposed(by: self.disposeBag)

        self.tooltipVCButton.rx.tap
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .bind { [weak self] _ in
                self?.onTooltipVC()
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

    private func onPageVC() {
        let vc = Page_VC()
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true, completion: nil)
    }

    private func onMessageVC() {
        let vc = Message_VC()
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true, completion: nil)
    }

    private func onRecorderVC() {
        let vc = Recorder_VC()
        vc.bind(Recorder_VM())
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true, completion: nil)
    }

    private func onPickerVC() {
        let vc = Picker_VC()
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true, completion: nil)
    }

    private func onTooltipVC() {
        let vc = Tooltip_VC()
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true, completion: nil)
    }
}


