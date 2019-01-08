# LineReader
Swift line reader class for iterating over a file line by line ie.

    let lineReader = try LineReader(file: f)
    
    for line in lineReader {
        print(line)
    }
