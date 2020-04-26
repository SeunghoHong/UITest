
import UIKit

import RxSwift
import RxCocoa
import SnapKit


protocol UserCellBindable {
    var nickname: BehaviorRelay<String> { get }
}

class UserCell: UICollectionViewCell {

    private var baseView = UIView()
    private var imageView = UIImageView()
    private var nicknameLabel = UILabel()

    private var disposeBag = DisposeBag()
    private var reUsableDisposeBag = DisposeBag()

    private var viewModel: UserCellBindable?


    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.setup()
        self.layout()
        self.bind()
    }
}


extension UserCell {

    private func setup() {
        self.backgroundColor = .clear

        self.baseView.backgroundColor = .red
        self.addSubview(self.baseView)

        self.imageView.backgroundColor = .gray
        self.baseView.addSubview(self.imageView)

        self.nicknameLabel.backgroundColor = .blue
        self.nicknameLabel.font = UIFont.systemFont(ofSize: 12.0)
        self.nicknameLabel.textColor = .black
        self.nicknameLabel.textAlignment = .center
        self.addSubview(self.nicknameLabel)
    }

    private func layout() {
        self.baseView.snp.makeConstraints { maker in
            maker.leading.trailing.top.equalToSuperview()
            maker.height.equalTo(self.snp.width)
        }

        self.imageView.snp.makeConstraints { maker in
            maker.leading.top.equalToSuperview().offset(3.0)
            maker.trailing.bottom.equalToSuperview().offset(-3.0)
        }

        self.nicknameLabel.snp.makeConstraints { maker in
            maker.leading.trailing.equalToSuperview()
//            maker.top.equalTo(self.baseView.snp.bottom).offset(10.0)
            maker.bottom.equalToSuperview()
        }
    }

    private func bind() {
        
    }
}


extension UserCell {

    func bind(_ viewModel: UserCellBindable) {
        self.viewModel = viewModel
        self.reUsableDisposeBag = DisposeBag()

        viewModel.nickname.asDriver()
            .drive(self.nicknameLabel.rx.text)
            .disposed(by: self.reUsableDisposeBag)
    }
}
