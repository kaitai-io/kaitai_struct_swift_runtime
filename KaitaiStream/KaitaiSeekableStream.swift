//
//  KaitaiSeekableStream.swift
//  KaitaiStream
//
//  Created by Mothlike on 25.04.16.
//  Copyright © 2016 Dmitry Marochko. All rights reserved.
//

import Foundation

protocol KaitaiSeekableStream {
    var position:Int { get }
    var isEOF:Bool { get }

    func seek(_ position:Int)
    func read() -> UInt8?
    func read(_ length:Int) -> [UInt8]?
}

class ByteArraySeekableStream : KaitaiSeekableStream {
    fileprivate let bytes:[UInt8];

    fileprivate(set) var position:Int = 0;

    var isEOF:Bool {
        return !(position < bytes.count)
    }

    init(bytes:[UInt8]) {
        self.bytes = bytes
    }

    func seek(_ position: Int) {
        self.position = position
    }

    func read() -> UInt8? {
        guard !isEOF else {
            return nil
        }

        let value = bytes[position]

        position += 1

        return value
    }

    func read(_ length: Int) -> [UInt8]? {
        guard !isEOF else {
            return nil
        }

        guard position + length <= bytes.count else {
            return nil
        }

        let range = Array(bytes[position..<position + length])

        position += length

        return range
    }
}

class NSDataSeekableStream:KaitaiSeekableStream {
    fileprivate let data:Data

    fileprivate(set) var position:Int = 0

    var isEOF:Bool {
        return !(position < data.count)
    }

    init(data:Data) {
        self.data = data
    }

    func seek(_ position: Int) {
        self.position = position
    }

    func read() -> UInt8? {
        guard !isEOF else {
            return nil
        }

        var bytes = [UInt8](repeating: 0, count: 1)

        (data as NSData).getBytes(&bytes, length: 1)

        position += 1

        return bytes[0]
    }

    func read(_ length: Int) -> [UInt8]? {
        guard !isEOF else {
            return nil
        }

        guard position + length <= data.count else {
            return nil
        }

        var bytes = [UInt8](repeating: 0, count: length)

        if position == 0 {
            (data as NSData).getBytes(&bytes, length: length)
        } else {
            let range = NSRange(location: position, length: length)
            (data as NSData).getBytes(&bytes, range: range)
        }

        position += length

        return bytes
    }
}

class NSFileHandleSeekableStream:KaitaiSeekableStream {
    fileprivate let file:FileHandle

    fileprivate(set) var position:Int = 0

    var isEOF:Bool {
        let byte = read()

        if byte != nil {
            seek(position-1)
        }

        return byte == nil
    }

    init?(path:String) {
        guard let file = FileHandle(forReadingAtPath: path) else {
            return nil
        }

        self.file = file
    }

    init?(url:URL) {
        guard let file = try? FileHandle(forReadingFrom:url) else {
            return nil
        }

        self.file = file
    }

    deinit {
        file.closeFile()
    }

    func seek(_ position: Int) {
        self.position = position
        file.seek(toFileOffset: UInt64(position))
    }

    func read() -> UInt8? {
        let data = file.readData(ofLength: 1)

        guard data.count == 1 else {
            seek(position)

            return nil
        }

        var bytes = [UInt8](repeating: 0, count: 1)
        (data as NSData).getBytes(&bytes, length: 1)

        position += 1

        return bytes[0]
    }

    func read(_ length: Int) -> [UInt8]? {
        let data = file.readData(ofLength: length)

        guard data.count == length else {
            seek(position)

            return nil
        }
        
        var bytes = [UInt8](repeating: 0, count: length)
        (data as NSData).getBytes(&bytes, length: length)
        
        position += length
        
        return bytes
    }
}
