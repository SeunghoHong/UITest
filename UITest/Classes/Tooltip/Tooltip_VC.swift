
import UIKit

import RxSwift
import RxCocoa
import SnapKit


final class Tooltip_VC: UIViewController {

    private let closeButton = UIButton()
    private let randomButton = UIButton()
    private let tooltipView = TooltipView()
    
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


extension Tooltip_VC {

    private func setup() {
        self.view.backgroundColor = .lightGray

        self.closeButton.setTitle("close", for: .normal)
        self.closeButton.setTitleColor(.black, for: .normal)
        self.view.addSubview(self.closeButton)

        self.randomButton.backgroundColor = .systemBlue
        self.view.addSubview(self.randomButton)

        self.view.addSubview(self.tooltipView)
    }

    private func layout() {
        self.closeButton.snp.makeConstraints { maker in
            maker.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(16.0)
            maker.leading.equalToSuperview().offset(16.0)
        }

        self.randomButton.snp.makeConstraints { maker in
            maker.bottom.equalToSuperview().offset(-128.0)
            maker.trailing.equalToSuperview().offset(-16.0)
            maker.width.height.equalTo(72.0)
        }

        self.tooltipView.snp.makeConstraints { maker in
            maker.trailing.equalTo(self.randomButton.snp.leading).offset(-8.0)
            maker.centerY.equalTo(self.randomButton.snp.centerY)
        }
    }

    private func bind() {
        self.closeButton.rx.tap
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .bind { [weak self] _ in
                self?.onClose()
            }
            .disposed(by: self.disposeBag)

        self.randomButton.rx.tap
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .bind { [weak self] _ in
                if let image = UIImage(named: "img_round"),
                   let alpha = image.alpha(0.5) {
                    self?.fallParticles([image, alpha])
                }
            }
            .disposed(by: self.disposeBag)
    }
}


extension Tooltip_VC {

    private func onClose() {
        self.dismiss(animated: true, completion: nil)
    }
}

