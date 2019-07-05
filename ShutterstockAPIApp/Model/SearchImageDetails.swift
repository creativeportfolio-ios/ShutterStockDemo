

import Foundation
public struct SearchImageDetails : Decodable {
	let page : Int?
	let per_page : Int?
	let total_count : Int?
	let search_id : String?
	let data : [PhotosDetails]?

	enum CodingKeys: String, CodingKey {

		case page = "page"
		case per_page = "per_page"
		case total_count = "total_count"
		case search_id = "search_id"
		case data = "data"
	}

    public init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		page = try values.decodeIfPresent(Int.self, forKey: .page)
		per_page = try values.decodeIfPresent(Int.self, forKey: .per_page)
		total_count = try values.decodeIfPresent(Int.self, forKey: .total_count)
		search_id = try values.decodeIfPresent(String.self, forKey: .search_id)
		data = try values.decodeIfPresent([PhotosDetails].self, forKey: .data)
	}

}
