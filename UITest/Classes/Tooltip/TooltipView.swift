
import UIKit

import RxSwift
import RxCocoa
import SnapKit


class TooltipView: UIView {

    private var stackView = UIStackView()
    private var guideView = UIView()
    private var textLabel = UILabel()
    private var arrowImageView = UIImageView()

    private var disposeBag = DisposeBag()


    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.setup()
        self.layout()
    }
}


extension TooltipView {

    private func setup() {
        self.backgroundColor = .clear

        self.stackView.alignment = .center
        self.stackView.spacing = 0.0
        self.stackView.axis = .horizontal
        self.addSubview(self.stackView)

        self.guideView.backgroundColor = .white
        self.stackView.addArrangedSubview(self.guideView)

        self.textLabel.text = "This is a test tooltip."
        self.guideView.addSubview(self.textLabel)

        self.arrowImageView.image = R.image.ic_tooltip()?.rotate(radians: (.pi / -2.0))
        self.stackView.addArrangedSubview(self.arrowImageView)
    }

    private func layout () {
        self.stackView.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }

        self.textLabel.snp.makeConstraints { maker in
            maker.edges.equalToSuperview().inset(8.0)
        }
    }
}



extension UIImage {

    func rotate(radians: Float) -> UIImage? {
        var size = CGRect(origin: CGPoint.zero, size: self.size).applying(CGAffineTransform(rotationAngle: CGFloat(radians))).size
        size.width = floor(size.width)
        size.height = floor(size.height)

        UIGraphicsBeginImageContextWithOptions(size, false, self.scale)
        defer {
            UIGraphicsEndImageContext()
        }

        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }

        context.translateBy(x: (size.width / 2.0), y: (size.height / 2.0))
        context.rotate(by: CGFloat(radians))
        self.draw(in: CGRect(x: -(self.size.width / 2.0), y: -(self.size.height / 2.0), width: self.size.width, height: self.size.height))

        guard let image = UIGraphicsGetImageFromCurrentImageContext() else {
            return nil
        }
        return image
    }

    func flipImage() -> UIImage? {
        guard let cgImage = self.cgImage else {
            return nil
        }
        let rect = CGRect(x: 0.0, y: 0.0, width: self.size.width, height: self.size.height)
        UIGraphicsBeginImageContextWithOptions(self.size, false, 0.0)
        defer {
            UIGraphicsEndImageContext()
        }
        
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        context.scaleBy(x: -1.0, y: -1.0)
        context.translateBy(x: -rect.size.width, y: -rect.size.height)
        context.draw(cgImage, in: rect)
        
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else {
            return nil
        }
        return image
    }
}
