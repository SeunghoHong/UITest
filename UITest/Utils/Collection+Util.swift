
extension Collection {

    // MARK: out of index crash를 방지하기 위해 [safe: index] 호출을 사용
    subscript (safe index: Index) -> Iterator.Element? {
        return index >= startIndex && index < endIndex ? self[index] : nil
    }
}
