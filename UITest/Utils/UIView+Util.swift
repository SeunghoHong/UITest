import UIKit


// MARK: Layer
extension UIView {

    typealias Border = (width: CGFloat, color: UIColor)


    var circle: Bool {
        get {
            return (self.layer.cornerRadius == 0.0)
        } set (newValue) {
            self.radius = newValue ? (self.frame.size.width / 2) : 0.0
        }
    }

    var ellipse: Bool {
        get {
            return (self.layer.cornerRadius == 0.0)
        } set (newValue) {
            self.radius = newValue ? (self.frame.size.height / 2) : 0.0
        }
    }

    var radius: CGFloat {
        get {
            return self.layer.cornerRadius
        } set (newValue) {
            self.layer.cornerRadius = newValue
            self.layer.masksToBounds = true
            self.clipsToBounds = true
        }
    }

    var border: Border {
        get {
            return (self.layer.borderWidth, UIColor(cgColor: self.layer.borderColor ?? UIColor.clear.cgColor))
        } set (newValue) {
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


// MARK: Frame
extension UIView {

    var x: CGFloat {
        get {
            return self.frame.origin.x
        } set (newX) {
            var rect = self.frame
            rect.origin.x = newX
            self.frame = rect
        }
    }

    var y: CGFloat {
        get {
            return self.frame.origin.y
        } set (newY) {
            var rect = self.frame
            rect.origin.y = newY
            self.frame = rect
        }
    }

    var width: CGFloat {
        get {
            return self.frame.size.width
        } set (newWidth) {
            var rect = self.frame
            rect.size.width = newWidth
            self.frame = rect
        }
    }

    var height: CGFloat {
        get {
            return self.frame.size.height
        } set (newHeight) {
            var rect = self.frame
            rect.size.height = newHeight
            self.frame = rect
        }
    }
}
