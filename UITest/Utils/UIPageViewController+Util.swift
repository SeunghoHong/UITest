
import UIKit


extension UIPageViewController {

    var scrollView: UIScrollView? {
        return view.subviews.first(where: { $0 is UIScrollView }) as? UIScrollView
    }

    var isScrollEnabled: Bool {
        get {
            return self.scrollView?.isScrollEnabled ?? false
        } set {
            self.scrollView?.isScrollEnabled = newValue
        }
    }
}
