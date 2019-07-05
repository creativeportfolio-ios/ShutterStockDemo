

import Foundation
struct ImageAssets : Codable {
	let preview : ImagePreview?
	let preview_1000 : ImagePreview?

	enum CodingKeys: String, CodingKey {

		case preview = "preview"
		case preview_1000 = "preview_1000"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		preview = try values.decodeIfPresent(ImagePreview.self, forKey: .preview)
		preview_1000 = try values.decodeIfPresent(ImagePreview.self, forKey: .preview_1000)
	}

}
