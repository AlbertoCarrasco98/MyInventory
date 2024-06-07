import Foundation

struct ColorModel {
    let red: CGFloat
    let green: CGFloat
    let blue: CGFloat
}

extension ColorModel: Codable {

    enum CodingKeys: String, CodingKey {
        case red
        case green
        case blue
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        red = CGFloat(try values.decode(Int.self, forKey: .red))
        green = CGFloat(try values.decode(Int.self, forKey: .green))
        blue = CGFloat(try values.decode(Int.self, forKey: .blue))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(red, forKey: .red)
        try container.encode(green, forKey: .green)
        try container.encode(blue, forKey: .blue)
    }
}
