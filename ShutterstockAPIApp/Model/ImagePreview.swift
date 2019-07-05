import UIKit

struct ImagePreview: Codable {
	let height : Int?
	let url : String?
	let width : Int?

	enum CodingKeys: String, CodingKey {

		case height = "height"
		case url = "url"
		case width = "width"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		height = try values.decodeIfPresent(Int.self, forKey: .height)
		url = try values.decodeIfPresent(String.self, forKey: .url)
		width = try values.decodeIfPresent(Int.self, forKey: .width)
	}
    
    func height(forWidth width: CGFloat) -> CGFloat {
        let previewHeight = CGFloat(self.height ?? 0)
        let previewWidth = CGFloat(self.width ?? 0)
        
        return (previewHeight * width) / previewWidth
    }
}
