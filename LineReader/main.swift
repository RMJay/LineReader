import Foundation

do {
    let fm = FileManager.default
    //reads from ~/scratch/shakespeare.txt
    let url = fm.homeDirectoryForCurrentUser
        .appendingPathComponent("scratch")
        .appendingPathComponent("Shakespeare")
        .appendingPathExtension("txt")
    let f = try FileHandle(forReadingFrom: url)
    defer {
        f.closeFile()
    }
    let lineReader = try LineReader(file: f)
    
    for line in lineReader {
        print(line)
    }
} catch let error {
    print(error)
}
