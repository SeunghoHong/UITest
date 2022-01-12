import UIKit


// MARK: Layer
extension UIView {
    typealias Border = (width: CGFloat, color: UIColor)


    var circle: Bool {
        get {
            return (self.layer.cornerRadius == 0.0)
        }
        set {
            self.radius = newValue ? (self.frame.size.width / 2) : 0.0
        }
    }

    var ellipse: Bool {
        get {
            return (self.layer.cornerRadius == 0.0)
        }
        set {
            self.radius = newValue ? (self.frame.size.height / 2) : 0.0
        }
    }

    var radius: CGFloat {
        get {
            return self.layer.cornerRadius
        }
        set {
            self.layer.cornerRadius = newValue
            self.layer.masksToBounds = true
            self.clipsToBounds = true
        }
    }

    var border: Border {
        get {
            return (self.layer.borderWidth, UIColor(cgColor: self.layer.borderColor ?? UIColor.clear.cgColor))
        }
        set {
            self.layer.borderWidth = newValue.width
            self.layer.borderColor = newValue.color.cgColor
        }
    }

    // MARK: 특정 부분에 radius 적용
    //   ex. self.controlView.radius([.topLeft, .topRight], radius: 4.0)
    func radius(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
}


// MARK: Shadow
extension UIView {

    func shadow(color: UIColor = .black, opacity: Float = 0.3, radius: CGFloat = 0.6) {
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowRadius = radius
        self.layer.shadowOffset = CGSize(width: 0, height: 0)

        self.layer.masksToBounds = false
    }
}


// MARK: Frame
extension UIView {

    var width: CGFloat {
        get {
            return self.frame.size.width
        }
        set {
            var rect = self.frame
            rect.size.width = newValue
            self.frame = rect
        }
    }

    var height: CGFloat {
        get {
            return self.frame.size.height
        }
        set {
            var rect = self.frame
            rect.size.height = newValue
            self.frame = rect
        }
    }
}
