
import Foundation
struct PhotosDetails : Codable {
    
	let id : String?
	let aspect : Double?
	let assets : ImageAssets?
	let description : String?
	let image_type : String?
	let has_model_release : Bool?
	let media_type : String?

	enum CodingKeys: String, CodingKey {

		case id = "id"
		case aspect = "aspect"
		case assets = "assets"
		case description = "description"
		case image_type = "image_type"
		case has_model_release = "has_model_release"
		case media_type = "media_type"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try values.decodeIfPresent(String.self, forKey: .id)
		aspect = try values.decodeIfPresent(Double.self, forKey: .aspect)
		assets = try values.decodeIfPresent(ImageAssets.self, forKey: .assets)
		description = try values.decodeIfPresent(String.self, forKey: .description)
		image_type = try values.decodeIfPresent(String.self, forKey: .image_type)
		has_model_release = try values.decodeIfPresent(Bool.self, forKey: .has_model_release)
		media_type = try values.decodeIfPresent(String.self, forKey: .media_type)
	}

}
