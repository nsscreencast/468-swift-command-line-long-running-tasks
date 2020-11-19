import ArgumentParser
import Files
import Foundation

// swift-encode <input_file> -o output
struct Encode: ParsableCommand {
    @Argument(help: "The input movie file to encode")
    var inputFile: String
    
    @Option(name: [.short, .customLong("out")], help: "The output directory in which to place the encoded files.")
    var outputDirectory: String = "output"

    func run() throws {    
        print("Running swift-encode...")
        print("Input file: \(inputFile, color: .cyan)")
        print("Output dir: \(outputDirectory, color: .cyan)")
        
            
        try ANSIColor.with(.yellow) {
            let file = try File(path: inputFile)
            _ = try Folder.current.createSubfolderIfNeeded(withName: outputDirectory)
            let video = Video(file: file)
            print("Frames: \(try video.totalFrames())")
            let encoder = Encoder(video: video)
            try encoder.encode()
            print("Done!")
        }
    }
}

Encode.main()
