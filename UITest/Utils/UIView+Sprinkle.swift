
import UIKit


extension UIView {

    func sprinkle(_ confetti: [UIImage]) {
        if let sublayers = self.layer.sublayers, sublayers.contains(where: { $0.name == "confetti" }) { return }

        let layer = CAEmitterLayer()
        layer.name = "confetti"
        layer.emitterSize = CGSize(width: self.frame.size.width, height: 1.0)
        layer.emitterShape = .line
        layer.emitterPosition = CGPoint(x: self.center.x, y: 0.0)
        layer.emitterCells = confetti.map { emitterCell(with: $0) }

//        self.layer.insertSublayer(layer, at: 0)
        self.layer.addSublayer(layer)
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
