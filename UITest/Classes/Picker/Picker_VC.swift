
import UIKit

import RxSwift
import RxCocoa
import SnapKit


final class Picker_VC: UIViewController {

    private let closeButton = UIButton()
    private let loadButton = UIButton()

    private let pickerView = UIPickerView()
    private var pickerViewBottomConstraint: Constraint?

    private var disposeBag = DisposeBag()

    private let items = BehaviorRelay<[Int]>(value: [0, 10, 60, 120])


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


extension Picker_VC {

    private func setup() {
        self.view.backgroundColor = .white

        self.closeButton.setTitle("close", for: .normal)
        self.closeButton.setTitleColor(.black, for: .normal)
        self.view.addSubview(self.closeButton)

        self.loadButton.setTitle("load", for: .normal)
        self.loadButton.setTitleColor(.black, for: .normal)
        self.view.addSubview(self.loadButton)

        self.view.addSubview(self.pickerView)
    }

    private func layout() {
        self.closeButton.snp.makeConstraints { maker in
            maker.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(16.0)
            maker.leading.equalToSuperview().offset(16.0)
        }

        self.loadButton.snp.makeConstraints { maker in
            maker.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(16.0)
            maker.trailing.equalToSuperview().offset(-16.0)
        }

        self.pickerView.snp.makeConstraints { maker in
            maker.leading.trailing.equalToSuperview()
            self.pickerViewBottomConstraint = maker.bottom.equalToSuperview().constraint
            maker.height.equalTo(220.0)
        }
    }

    private func bind() {
        self.closeButton.rx.tap
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .bind { [weak self] _ in
                self?.onClose()
            }
            .disposed(by: self.disposeBag)

        self.loadButton.rx.tap
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .bind { [weak self] _ in
                self?.onLoad()
            }
            .disposed(by: self.disposeBag)

        self.items.asObservable()
            .bind(to: pickerView.rx.itemTitles) { index, element in
                return "\(element)"
            }
            .disposed(by: self.disposeBag)

        self.pickerView.rx.itemSelected
            .bind { indexPath in
                LogD("\(self.items.value[safe: indexPath.row])")
            }
            .disposed(by: self.disposeBag)
    }
}


extension Picker_VC {

    private func onClose() {
        self.dismiss(animated: true, completion: nil)
    }

    private func onLoad() {
        self.items.accept([0, 20, 30, 40, 50, 60])
    }
}
