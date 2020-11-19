import Foundation

enum CodecType: String, Codable {
    case audio
    case video
}

struct FFProbeStream: Codable {
    let codecType: CodecType
    let width: Int?
    let height: Int?
    let duration: String
    let nbFrames: String
    let avgFrameRate: String
}

struct FFProbeOutput: Codable {
    let streams: [FFProbeStream]
}