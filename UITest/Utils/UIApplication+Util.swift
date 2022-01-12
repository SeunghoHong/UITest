
import UIKit


extension UIApplication {

    static var statusBarHeight: CGFloat {
        let window = UIApplication.shared.windows.filter { $0.isKeyWindow }.first

        return window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0.0
    }
}
