
import UIKit

import RxCocoa
import RxSwift


extension RxSwift.Reactive where Base: UIView {
    
    public var layoutSubviews: Observable<Void> {
        return methodInvoked(#selector(UIView.layoutSubviews))
            .map { _ in return }
    }
}
