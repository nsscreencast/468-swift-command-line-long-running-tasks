import Files
import Foundation

class Video {
    let file: File
    
    init(file: File) {
        self.file = file
    }
    
    func totalFrames() throws -> Int {
        guard let stream = try ffprobe().streams.first(where: { $0.codecType == .video })
         else { return 0 }
        return Int(stream.nbFrames) ?? 0
    }
    
    private var _ffprobeOutput: FFProbeOutput? = nil
    func ffprobe() throws -> FFProbeOutput {
        guard _ffprobeOutput == nil else {
            return _ffprobeOutput!
        }
        let stdout = Pipe()
        let stderr = Pipe()
        let task = makeTask(command: "ffprobe", arguments: [
            file.path,
            "-print_format", "json",
            "-v", "quiet",
            "-show_streams"
        ], stdout: stdout, stderr: stderr)
        task.launch()
        task.waitUntilExit()
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let json = stdout.fileHandleForReading.readDataToEndOfFile()
        // print("ffprobe output:\n--------------------------------------")
        // print(String(data: json, encoding: .utf8)!)
        // print("--------------------------------------")
        _ffprobeOutput = try decoder.decode(FFProbeOutput.self, from: json)
        return _ffprobeOutput!
    }
}