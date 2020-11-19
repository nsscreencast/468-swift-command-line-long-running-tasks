import Files
import Foundation
import Subprocess

class Encoder {
    let video: Video
    
    init(video: Video) {
        self.video = video
    }
    
    func encode() throws {
        let command = [
            "/usr/bin/env",
            "ffmpeg",
            "-i", video.file.path,
            "-c:v", "libx264",
            "-crf", "22",
            "-c:a", "aac",
            "-b:a", "256k",
            "-y",
            "out.mp4"
        ]
        
        let process = Subprocess(command)
        let group = DispatchGroup()
        group.enter()
        try process.launch(outputHandler: { data in 
            print("OUT: \(String(data: data, encoding: .utf8) ?? "")")
        }, errorHandler: { data in 
            print("ERR: \(String(data: data, encoding: .utf8) ?? "")")
        }, terminationHandler: { _ in 
            print("Process terminated")
            group.leave()
        })
        
        group.wait()
    }
}