
import UIKit

import RxSwift
import RxCocoa
import SnapKit


class ViewController: UIViewController {

    private let contentView = UIScrollView()
    private let baseView = UIView()
    private let bannerVCButton = UIButton()
    private let profileVCButton = UIButton()
    private let pageVCButton = UIButton()
    private let messageVCButton = UIButton()
    private let recorderVCButton = UIButton()
    private let playerVCButton = UIButton()
    private let pickerVCButton = UIButton()
    private let tooltipVCButton = UIButton()
    private let webVCButton = UIButton()
    private let noticeVCButton = UIButton()
    private let slotVCButton = UIButton()
    private let extendablePopupVCButton = UIButton()
    private let scheduleVCButton = UIButton()
    private let flexPinVCButton = UIButton()
    private let stretchVCButton = UIButton()

    private var disposeBag = DisposeBag()


    override func viewDidLoad() {
        super.viewDidLoad()

        self.setup()
        self.setupFlex()
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

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        self.layout()
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
            LogE("UserError \(code)")
        } catch LiveError.errNo(let code) {
            LogE("LiveError \(code)")
        } catch let e {
            LogE("\(e)")
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
                LogD("\(id)")
            }, onError: { error in
                guard let error = error as? NSError else { return }
                LogE("\(error.code)")
            })
            .disposed(by: self.disposeBag)
    }
}


extension ViewController {
    
    private func setup() {
        self.view.backgroundColor = .white

        self.view.addSubview(self.contentView)
        self.contentView.addSubview(self.baseView)

        self.bannerVCButton.setTitle("BannerVC", for: .normal)
        self.bannerVCButton.setTitleColor(.black, for: .normal)

        self.profileVCButton.setTitle("ProfileVC", for: .normal)
        self.profileVCButton.setTitleColor(.black, for: .normal)

        self.pageVCButton.setTitle("PageVC", for: .normal)
        self.pageVCButton.setTitleColor(.black, for: .normal)

        self.messageVCButton.setTitle("MessageVC", for: .normal)
        self.messageVCButton.setTitleColor(.black, for: .normal)

        self.recorderVCButton.setTitle("RecorderVC", for: .normal)
        self.recorderVCButton.setTitleColor(.black, for: .normal)

        self.playerVCButton.setTitle("PlayerVC", for: .normal)
        self.playerVCButton.setTitleColor(.black, for: .normal)

        self.pickerVCButton.setTitle("PickerVC", for: .normal)
        self.pickerVCButton.setTitleColor(.black, for: .normal)

        self.tooltipVCButton.setTitle("TooltipVC", for: .normal)
        self.tooltipVCButton.setTitleColor(.black, for: .normal)

        self.webVCButton.setTitle("WebVC", for: .normal)
        self.webVCButton.setTitleColor(.black, for: .normal)

        self.noticeVCButton.setTitle("NoticeVC", for: .normal)
        self.noticeVCButton.setTitleColor(.black, for: .normal)

        self.slotVCButton.setTitle("SlotVC", for: .normal)
        self.slotVCButton.setTitleColor(.black, for: .normal)

        self.extendablePopupVCButton.setTitle("ExtendablePopupVC", for: .normal)
        self.extendablePopupVCButton.setTitleColor(.black, for: .normal)

        self.scheduleVCButton.setTitle("scheduleVC", for: .normal)
        self.scheduleVCButton.setTitleColor(.black, for: .normal)

        self.flexPinVCButton.setTitle("FlexPinVC", for: .normal)
        self.flexPinVCButton.setTitleColor(.black, for: .normal)
    }

    private func setupFlex() {
        self.baseView.flex.direction(.column)
            .define { flex in
                flex.addItem(self.bannerVCButton)
                flex.addItem(self.profileVCButton)
                flex.addItem(self.pageVCButton)
                flex.addItem(self.messageVCButton)
                flex.addItem(self.recorderVCButton)
                flex.addItem(self.playerVCButton)
                flex.addItem(self.pickerVCButton)
                flex.addItem(self.tooltipVCButton)
                flex.addItem(self.webVCButton)
                flex.addItem(self.noticeVCButton)
                flex.addItem(self.slotVCButton)
                flex.addItem(self.extendablePopupVCButton)
                flex.addItem(self.scheduleVCButton)
                flex.addItem(self.flexPinVCButton)
                flex.addItem(self.stretchVCButton)
            }
    }
    
    private func layout() {
        self.contentView.pin
            .all(self.view.pin.safeArea)

        self.baseView.pin
            .top()
            .horizontally()

        self.baseView.flex
            .layout(mode: .adjustHeight)

        self.contentView.contentSize = self.baseView.frame.size
    }

    private func bind() {
        self.bannerVCButton.rx.tap
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .bind { [weak self] _ in
                self?.onBannerVC()
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

        self.playerVCButton.rx.tap
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .bind { [weak self] _ in
                self?.onPlayerVC()
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

        self.webVCButton.rx.tap
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .bind { [weak self] _ in
                self?.onWebVC()
            }
            .disposed(by: self.disposeBag)

        self.noticeVCButton.rx.tap
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .bind { [weak self] _ in
                self?.onNoticeVC()
            }
            .disposed(by: self.disposeBag)

        self.slotVCButton.rx.tap
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .bind { [weak self] _ in
                self?.onSlotVC()
            }
            .disposed(by: self.disposeBag)

        self.extendablePopupVCButton.rx.tap
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .bind { [weak self] _ in
                self?.onExtendablePopupVC()
            }
            .disposed(by: self.disposeBag)

        self.scheduleVCButton.rx.tap
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .bind { [weak self] _ in
                self?.onScheduleVC()
            }
            .disposed(by: self.disposeBag)

        self.flexPinVCButton.rx.tap
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .bind { [weak self] _ in
                self?.onFlexPinVC()
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

    private func onPlayerVC() {
        let vc = Player_VC()
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

    private func onWebVC() {
        let vc = Web_VC()
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true, completion: nil)
    }

    private func onNoticeVC() {
        let vc = Notice_VC()
        vc.bind(Notice_VM())
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true, completion: nil)
    }

    private func onSlotVC() {
        let vc = Slot_VC()
        vc.bind(Slot_VM())
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true, completion: nil)
    }

    private func onExtendablePopupVC() {
        let vc = EntendablePopup_VC()
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: false, completion: nil)
    }

    private func onScheduleVC() {
        let vc = Schedule_VC()
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true, completion: nil)
    }

    private func onFlexPinVC() {
        let vc = FlexPin_VC()
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true, completion: nil)
    }
}
