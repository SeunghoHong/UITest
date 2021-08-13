
import UIKit

import RxSwift
import RxCocoa
import PinLayout
import FlexLayout


final class FlexPin_VC: UIViewController {

    private let closeButton = UIButton()
    private let titleLabel = UILabel()

    private let tableView = UITableView()

    private let disposeBag = DisposeBag()

    private let texts = [
        "The JSON Formatter was created to help folks with debugging.",
        "JSON data is often output without line breaks to save space, it can be extremely difficult to actually read and make sense of it.",
        "This tool hoped to solve the problem by formatting and beautifying the JSON data so that it is easy to read and debug by human beings.",
        "To further expand the debugging capabilities, advanced JSON validation was soon added following the description set out by Douglas Crockford of json.org in RFC 4627.",
        "It has since been updated to allow validation of multiple JSON standards, including both current specifications RFC 8259 and ECMA-404.",
        "Most recently, the capability to fix common JSON errors was added.",
        "If enabled, it will replace incorrect quotes, add missing quotes, correct numeric keys, lowercase literals, escape unescaped characters, and remove comments and trailing commas."
    ]


    override func viewDidLoad() {
        super.viewDidLoad()

        self.setup()
        self.bind()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        self.layout()
    }
}


extension FlexPin_VC {

    private func setup() {
        self.view.backgroundColor = .white

        self.closeButton.backgroundColor = .black
        self.closeButton.setTitle("close", for: .normal)
        self.closeButton.contentEdgeInsets = UIEdgeInsets(top: 4.0, left: 8.0, bottom: 4.0, right: 8.0)
        self.view.addSubview(self.closeButton)

        self.titleLabel.textColor = .black
        self.titleLabel.text = "title label"
        self.titleLabel.textAlignment = .center
        self.view.addSubview(self.titleLabel)

        self.tableView.separatorColor = .clear
        self.tableView.backgroundColor = .blue
        self.tableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "UITableViewHeaderFooterView")
//        self.tableView.register(TestPinCell.self, forCellReuseIdentifier: "TestPinCell")
        self.tableView.register(TestFlexCell.self, forCellReuseIdentifier: "TestFlexCell")
        self.tableView.dataSource = self
        self.tableView.sectionHeaderHeight = 38.0
        self.view.addSubview(self.tableView)
    }

    private func layout() {
        self.closeButton.pin
            .top(self.view.pin.safeArea).left(16.0)
            .marginTop(16.0)
            .sizeToFit()

        self.titleLabel.pin
            .after(of: self.closeButton, aligned: .center)
            .end(16.0)
            .height(32.0)
            .marginLeft(16.0)

        self.tableView.pin
            .below(of: self.closeButton)
            .bottom().left().right()
            .marginTop(12.0)
    }

    private func bind() {
        self.closeButton.rx.tap.asDriver()
            .throttle(.milliseconds(500))
            .drive { [weak self] _ in
                self?.dismiss(animated: true, completion: nil)
            }
            .disposed(by: self.disposeBag)
    }
}


extension FlexPin_VC: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.texts.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "\(section)"
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TestFlexCell", for: indexPath)

        if let cell = cell as? TestFlexCell {
            cell.notice = self.texts[indexPath.row]
        }

        return cell
    }
}
