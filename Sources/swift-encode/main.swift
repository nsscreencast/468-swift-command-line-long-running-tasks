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
            cmd("ffprobe", file.path)
        }
    }
    
    @discardableResult
    func cmd(_ command: String, _ arguments: String...) -> Int32 {
        let stdout = Pipe()
        let stderr = Pipe()
    
        let task = Process()
        task.standardOutput = stdout
        task.standardError = stderr
        task.executableURL = URL(fileURLWithPath: "/usr/bin/env")
        task.arguments = [command] + arguments
        task.launch()
        
        task.waitUntilExit()
        
        func pipeToString(_ pipe: Pipe) -> String {
            let data = pipe.fileHandleForReading.readDataToEndOfFile()
            return String(data: data, encoding: .utf8)!
        }
        
        print("------STDOUT------")
        print(pipeToString(stdout))
        print("------STDERR------")
        print(pipeToString(stderr))
        
        return task.terminationStatus
    }
}

Encode.main()
