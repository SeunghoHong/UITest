
import UIKit

import RxSwift
import RxCocoa
import SnapKit


class MainCell_TopUser: UICollectionViewCell {

    private var disposeBag = DisposeBag()
    private var reUsableDisposeBag = DisposeBag()


    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.setup()
        self.layout()
        self.bind()
    }
}


extension MainCell_TopUser {

    private func setup() {
        self.backgroundColor = .clear
    }

    private func layout() {
    }

    private func bind() {
    }
}
