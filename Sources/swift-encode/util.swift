import Foundation

@discardableResult
func makeTask(command: String, arguments: [String], stdout: Pipe, stderr: Pipe) -> Process {
    let task = Process()
    task.standardOutput = stdout
    task.standardError = stderr
    task.executableURL = URL(fileURLWithPath: "/usr/bin/env")
    task.arguments = [command] + arguments
    
    return task
}
