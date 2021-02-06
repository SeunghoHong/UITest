
import Foundation


struct Notice: Codable {
    var `id`: Int
    var title: String
    var contents_popup: String
    var contents_popup_url: String
    var contents_banner_url: String?
    var external_link: String
    var internal_link: String
    var order: Int
    var created: String
}
