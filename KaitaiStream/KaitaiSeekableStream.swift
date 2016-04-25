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

    func seek(position:Int)
    func read() -> UInt8?
    func read(length:Int) -> [UInt8]?
}

class ByteArraySeekableStream:KaitaiSeekableStream {
    private let bytes:[UInt8]

    private(set) var position:Int = 0

    var isEOF:Bool {
        return !(position < bytes.count)
    }

    init(bytes:[UInt8]) {
        self.bytes = bytes
    }

    func seek(position: Int) {
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

    func read(length: Int) -> [UInt8]? {
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
    private let data:NSData

    private(set) var position:Int = 0

    var isEOF:Bool {
        return !(position < data.length)
    }

    init(data:NSData) {
        self.data = data
    }

    func seek(position: Int) {
        self.position = position
    }

    func read() -> UInt8? {
        guard !isEOF else {
            return nil
        }

        var bytes = [UInt8](count: 1, repeatedValue: 0)

        data.getBytes(&bytes, length: 1)

        position += 1

        return bytes[0]
    }

    func read(length: Int) -> [UInt8]? {
        guard !isEOF else {
            return nil
        }

        guard position + length <= data.length else {
            return nil
        }

        var bytes = [UInt8](count: length, repeatedValue: 0)

        if position == 0 {
            data.getBytes(&bytes, length: length)
        } else {
            let range = NSRange(location: position, length: length)
            data.getBytes(&bytes, range: range)
        }

        position += length

        return bytes
    }
}

class NSFileHandleSeekableStream:KaitaiSeekableStream {
    private let file:NSFileHandle

    private(set) var position:Int = 0

    var isEOF:Bool {
        let byte = read()

        if byte != nil {
            seek(position-1)
        }

        return byte == nil
    }

    init?(path:String) {
        guard let file = NSFileHandle(forReadingAtPath: path) else {
            return nil
        }

        self.file = file
    }

    init?(url:NSURL) {
        guard let file = try? NSFileHandle(forReadingFromURL:url) else {
            return nil
        }

        self.file = file
    }

    deinit {
        file.closeFile()
    }

    func seek(position: Int) {
        self.position = position
        file.seekToFileOffset(UInt64(position))
    }

    func read() -> UInt8? {
        let data = file.readDataOfLength(1)

        guard data.length == 1 else {
            seek(position)

            return nil
        }

        var bytes = [UInt8](count: 1, repeatedValue: 0)
        data.getBytes(&bytes, length: 1)

        position += 1

        return bytes[0]
    }

    func read(length: Int) -> [UInt8]? {
        let data = file.readDataOfLength(length)

        guard data.length == length else {
            seek(position)

            return nil
        }
        
        var bytes = [UInt8](count: length, repeatedValue: 0)
        data.getBytes(&bytes, length: length)
        
        position += length
        
        return bytes
    }
}