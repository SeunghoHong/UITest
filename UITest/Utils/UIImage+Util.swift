
import UIKit


extension UIImage {

    convenience init?(color: UIColor, size: CGSize = CGSize(width: 1.0, height: 1.0)) {
        UIGraphicsBeginImageContext(size)
        defer { UIGraphicsEndImageContext() }

        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        context.setFillColor(color.cgColor)
        context.fill(CGRect(origin: .zero, size: size))

        guard let cgImage = UIGraphicsGetImageFromCurrentImageContext()?.cgImage else { return nil }

        self.init(cgImage: cgImage)
    }

    func alpha(_ alpha: CGFloat) -> UIImage? {
        guard let cgImage = self.cgImage else { return nil }
        let rect = CGRect(x: 0.0, y: 0.0, width: self.size.width, height: self.size.height)
        UIGraphicsBeginImageContextWithOptions(self.size, false, 0.0)
        defer { UIGraphicsEndImageContext() }

        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        context.scaleBy(x: 1.0, y: -1.0)
        context.translateBy(x: 0.0, y: -rect.size.height)

        context.setBlendMode(.multiply)
        context.setAlpha(alpha)
        context.draw(cgImage, in: rect)

        guard let image = UIGraphicsGetImageFromCurrentImageContext() else { return nil }

        return image
    }
}
