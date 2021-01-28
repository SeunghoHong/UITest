
import UIKit

import RxSwift
import RxCocoa
import SnapKit


class Notice_VC: UIViewController {

    private var viewModel: Notice_VM?


    override func viewDidLoad() {
        super.viewDidLoad()
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
        
    }

    private func layout() {
        
    }

    private func bind() {
        
    }
}


extension Notice_VC {

    func bind(_ viewModel: Notice_VM) {
        self.viewModel = viewModel
    }
}
