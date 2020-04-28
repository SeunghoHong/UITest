
import Foundation

import RxSwift
import RxCocoa
import RxDataSources


class Main_VM: MainBindable {

    var sections = BehaviorRelay<[MainSection]>(value: [])

    private var disposeBag = DisposeBag()
}


extension Main_VM {

    func loadSections() {
        var sections: [MainSection] = []
        self.sections.accept(sections)
    }
}
