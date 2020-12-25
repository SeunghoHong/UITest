
import UIKit


extension UIViewController {

    func fallParticles(_ particles: [UIImage]) {
        if let sublayers = self.view.layer.sublayers, sublayers.contains(where: { $0.name == "particle" }) { return }

        let layer = CAEmitterLayer()
        layer.name = "particle"
        layer.emitterSize = CGSize(width: self.view.frame.size.width, height: 1.0)
        layer.emitterShape = .line
        layer.emitterPosition = CGPoint(x: self.view.center.x, y: 0.0)
        layer.emitterCells = particles.map { emitterCell(with: $0) }

        self.view.layer.addSublayer(layer)
    }

    private func emitterCell(with image: UIImage) -> CAEmitterCell {
        let cell = CAEmitterCell()
        cell.contents = image.cgImage
        cell.birthRate = 3.0
        cell.lifetime = 12.0
        cell.lifetimeRange = 4.0
        cell.scale = 0.1
        cell.scaleRange = 0.1
        cell.velocity = 100.0
        cell.velocityRange = 10.0
        cell.emissionLongitude = .pi
        cell.emissionRange = 0.5
        cell.spin = 2.0
        cell.spinRange = 1.0
        cell.alphaSpeed = -0.1
        cell.alphaRange = 0.0
        return cell
    }
}
  

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
