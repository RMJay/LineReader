// inspired from: stackoverflow.com/a/24648951
import Foundation

public class LineReader  {
    
    let encoding: String.Encoding
    let chunkSize: Int
    var fileHandle: FileHandle
    let delimData: Data
    var buffer: Data
    var atEof: Bool
    
    public init(file: FileHandle, encoding: String.Encoding = .utf8,
         chunkSize: Int = 4096) throws {
        
        let fileHandle = file
        self.encoding = encoding
        self.chunkSize = chunkSize
        self.fileHandle = fileHandle
        self.delimData = "\n".data(using: encoding)!
        self.buffer = Data(capacity: chunkSize)
        self.atEof = false
    }
    
    /// Return next line, or nil on EOF.
    public func nextLine() -> String? {
        // Read data chunks from file until a line delimiter is found:
        while !atEof {
            //get a data from the buffer up to the next delimiter
            if let range = buffer.range(of: delimData) {
                //convert data to a string
                let line = String(data: buffer.subdata(in: 0..<range.lowerBound), encoding: encoding)!
                //remove that data from the buffer
                buffer.removeSubrange(0..<range.upperBound)
                return line
            }
            
            let nextData = fileHandle.readData(ofLength: chunkSize)
            if !nextData.isEmpty {
                buffer.append(nextData)
            } else {
                //End of file or read error
                atEof = true
                if !buffer.isEmpty {
                    // Buffer contains last line in file (not terminated by delimiter).
                    let line = String(data: buffer as Data, encoding: encoding)!
                    return line
                }
            }
        }
        return nil
    }
    
    /// Start reading from the beginning of file.
    public func rewind() -> Void {
        fileHandle.seek(toFileOffset: 0)
        buffer.count = 0
        atEof = false
    }
    
}

extension LineReader: Sequence {
    public func makeIterator() -> AnyIterator<String> {
        return AnyIterator {
            return self.nextLine()
        }
    }
}

