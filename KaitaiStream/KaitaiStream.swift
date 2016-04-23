//
//  KaitaiStream.swift
//  KaitaiStream
//
//  Created by Dmitry Marochko on 22.04.16.
//
//

import Foundation

private struct AssociatedKeys {
    static var kaitaiStream = "kaitaiStream"
}

// #pragma mark - KaitaiStream
public protocol KaitaiStreamProtocol {
    var kaitaiStream:KaitaiStream? { get }
}

extension String: KaitaiStreamProtocol {
    public private(set) var kaitaiStream:KaitaiStream? {
        get {
            guard let stream = objc_getAssociatedObject(self, &AssociatedKeys.kaitaiStream) as? KaitaiStream else {
                return nil
            }

            return stream
        }
        
        set(value) {
            objc_setAssociatedObject(self,&AssociatedKeys.kaitaiStream,value,objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    public init?(kaitaiStream:KaitaiStream, encoding:NSStringEncoding) {
        guard let string = kaitaiStream.readStrEos(encoding) else {
            return nil
        }

        self = string
        self.kaitaiStream = kaitaiStream
    }

    public init?(kaitaiStream:KaitaiStream, length:Int, encoding:NSStringEncoding) {
        guard let string = kaitaiStream.readStrByteLimit(length,encoding: encoding) else {
            return nil
        }

        self = string
        self.kaitaiStream = kaitaiStream
    }

    public init?(kaitaiStream:KaitaiStream, termination:UInt8, encoding:NSStringEncoding, includeTermination:Bool=false,consumeTermination:Bool=true) {
        guard let string = kaitaiStream.readStrz(termination, encoding: encoding, includeTermination: includeTermination, consumeTermination: consumeTermination) else {
            return nil
        }

        self = string
        self.kaitaiStream = kaitaiStream
    }
}

public class KaitaiStream {
    private var stream:KaitaiSeekableStreamProtocol

    public var position:Int {
        return stream.position
    }
    public var isEOF:Bool {
        return stream.isEOF
    }

    public init(bytes:[UInt8]) {
        stream = BytesSeekableStream(bytes: bytes)
    }

    public init(data:NSData) {
        stream = NSDataSeekableStream(data: data);
    }

    public init?(path:String) {
        guard let filestream = NSFileHandleSeekableStream(path: path) else {
            return nil
        }

        stream = filestream
    }

    public init?(url:NSURL) {
        guard let filestream = NSFileHandleSeekableStream(url: url) else {
            return nil
        }

        stream = filestream
    }

    // methods
    public func seek(position:Int) {
        stream.seek(position)
    }

    public func readS1() -> Int8? {
        guard let value = stream.read() else {
            return nil
        }

        let valueInt = Int8(bitPattern: value)

        return valueInt
    }

    public func readU1() -> UInt8? {
        guard let value = stream.read() else {
            return nil
        }

        return value
    }

    public func readU2le() -> UInt? {
        guard let value1 = stream.read() else {
            return nil
        }

        guard let value2 = stream.read() else {
            return nil
        }

        let value1Int = UInt(value1)
        let value2Int = UInt(value2)

        return (value2Int << 8) + (value1Int << 0)
    }

    public func readU2be() -> UInt? {
        guard let value1 = stream.read() else {
            return nil
        }

        guard let value2 = stream.read() else {
            return nil
        }

        let value1Int = UInt(value1)
        let value2Int = UInt(value2)

        return (value1Int << 8) + (value2Int << 0)
    }

    public func readS2le() -> Int? {
        guard let value1 = stream.read() else {
            return nil
        }

        guard let value2 = stream.read() else {
            return nil
        }

        let value1Int = Int(bitPattern:UInt(value1))
        let value2Int = Int(bitPattern:UInt(value2))

        return (value2Int << 8) + (value1Int << 0)
    }

    public func readS2be() -> Int? {
        guard let value1 = stream.read() else {
            return nil
        }

        guard let value2 = stream.read() else {
            return nil
        }

        let value1Int = Int(bitPattern:UInt(value1))
        let value2Int = Int(bitPattern:UInt(value2))

        return (value1Int << 8) + (value2Int << 0)
    }

    public func readU4le() -> UInt? {
        guard let value1 = stream.read() else {
            return nil
        }

        guard let value2 = stream.read() else {
            return nil
        }

        guard let value3 = stream.read() else {
            return nil
        }

        guard let value4 = stream.read() else {
            return nil
        }

        let value1Int = UInt(value1)
        let value2Int = UInt(value2)
        let value3Int = UInt(value3)
        let value4Int = UInt(value4)

        return (value4Int << 24) + (value3Int << 16) + (value2Int << 8) + (value1Int << 0)
    }

    public func readU4be() -> UInt? {
        guard let value1 = stream.read() else {
            return nil
        }

        guard let value2 = stream.read() else {
            return nil
        }

        guard let value3 = stream.read() else {
            return nil
        }

        guard let value4 = stream.read() else {
            return nil
        }

        let value1Int = UInt(value1)
        let value2Int = UInt(value2)
        let value3Int = UInt(value3)
        let value4Int = UInt(value4)

        return (value4Int << 24) + (value3Int << 16) + (value2Int << 8) + (value1Int << 0)
    }

    public func readS4le() -> Int? {
        guard let value1 = stream.read() else {
            return nil
        }

        guard let value2 = stream.read() else {
            return nil
        }

        guard let value3 = stream.read() else {
            return nil
        }

        guard let value4 = stream.read() else {
            return nil
        }

        let value1Int = Int(bitPattern:UInt(value1))
        let value2Int = Int(bitPattern:UInt(value2))
        let value3Int = Int(bitPattern:UInt(value3))
        let value4Int = Int(bitPattern:UInt(value4))

        return (value4Int << 24) + (value3Int << 16) + (value2Int << 8) + (value1Int << 0)
    }

    public func readS4be() -> Int? {
        guard let value1 = stream.read() else {
            return nil
        }

        guard let value2 = stream.read() else {
            return nil
        }

        guard let value3 = stream.read() else {
            return nil
        }

        guard let value4 = stream.read() else {
            return nil
        }

        let value1Int = Int(bitPattern:UInt(value1))
        let value2Int = Int(bitPattern:UInt(value2))
        let value3Int = Int(bitPattern:UInt(value3))
        let value4Int = Int(bitPattern:UInt(value4))

        return (value1Int << 24) + (value2Int << 16) + (value3Int << 8) + (value4Int << 0)
    }

    public func readU8le() -> UInt? {
        guard let value1 = readU4le() else {
            return nil
        }

        guard let value2 = readU4le() else {
            return nil
        }

        return (value2 << 32) + (value1 << 0)
    }

    public func readU8be() -> UInt? {
        guard let value1 = readU4le() else {
            return nil
        }

        guard let value2 = readU4le() else {
            return nil
        }

        return (value1 << 32) + (value2 << 0)
    }

    public func readS8le() -> Int? {
        guard let value1 = readS4le() else {
            return nil
        }

        guard let value2 = readS4le() else {
            return nil
        }

        return (value2 << 32) + (value1 << 0)
    }

    public func readS8be() -> Int? {
        guard let value1 = readS4le() else {
            return nil
        }

        guard let value2 = readS4le() else {
            return nil
        }

        return (value1 << 32) + (value2 << 0)
    }

    public func readBytes(length:Int) -> [UInt8]? {
        guard let bytes = stream.read(length) else {
            return nil
        }

        return bytes
    }

    public func readBytesFull() -> [UInt8]? {
        guard let bytes = stream.read(stream.size - position) else {
            return nil
        }

        return bytes
    }

    public func ensureFixedContents(length:Int,bytes:[UInt8]) -> [UInt8]? {
        guard let actualBytes = readBytes(length) else {
            return nil
        }

        guard bytes == actualBytes else {
            return nil
        }

        return actualBytes
    }

    public func readStrEos(encoding: NSStringEncoding) -> String? {
        guard let bytes = readBytesFull() else {
            return nil
        }

        var string = String(bytes: bytes, encoding: encoding)
        string?.kaitaiStream = self

        return string
    }

    public func readStrByteLimit(length:Int, encoding: NSStringEncoding) -> String? {
        guard let bytes = readBytes(length) else {
            return nil
        }

        var string = String(bytes: bytes, encoding: encoding)
        string?.kaitaiStream = self

        return string
    }

    public func readStrz(termination:UInt8, encoding:NSStringEncoding, includeTermination:Bool=false,consumeTermination:Bool=true) -> String? {
        var buffer = [UInt8]()

        while true {
            guard let byte = stream.read() else {
                return nil
            }

            if byte == termination {
                if includeTermination {
                    buffer.append(byte)
                }

                if !consumeTermination {
                    stream.seek(stream.position - 1)
                }

                var string = String(bytes: buffer, encoding: encoding)
                string?.kaitaiStream = self

                return string
            }

            buffer.append(byte)
        }
    }

    public func processZlib(bytes:[UInt8]) -> [UInt8]? {
        let inflater = InflateStream()

        var buffer = Array(bytes)
        let (inflated,err) = inflater.write(&buffer, flush: true)

        guard err == nil else {
            return nil
        }

        return inflated
    }

    public func processRotateLeft(bytes:[UInt8],amount:UInt,groupSize:Int=1) -> [UInt8]? {
        var r = [UInt8](count:0, repeatedValue:0)

        switch groupSize {
        case 1:
            for i in 0..<bytes.count {
                let byte = UInt(bytes[i])

                r[i] = UInt8((((byte & 0xff) << amount) | ((byte & 0xff) >> (8 - amount))));
            }
        default:
            return nil
        }

        return r
    }

    public func byteArrayToHex(bytes:[UInt8]) -> String {
        var string = "";

        for i in 0..<bytes.count {
            if i > 0 {
                string += " "
            }

            string += String(format:"%02x", bytes[i])
        }

        return string
    }
}

// #pragma mark - Streams
private protocol KaitaiSeekableStreamProtocol {
    var position:Int { get }
    var size:Int { get }
    var isEOF:Bool { get }

    func seek(position:Int)
    func read() -> UInt8?
    func read(length:Int) -> [UInt8]?
}

private class BytesSeekableStream:KaitaiSeekableStreamProtocol {
    private let bytes:[UInt8]

    private(set) var position:Int = 0

    let size:Int

    var isEOF:Bool {
        return !(position < size)
    }

    init(bytes:[UInt8]) {
        self.bytes = bytes
        self.size = bytes.count
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

        guard position + length <= size else {
            return nil
        }

        let range = Array(bytes[position..<position + length])

        position += length

        return range
    }
}

private class NSDataSeekableStream:KaitaiSeekableStreamProtocol {
    private let data:NSData

    private(set) var position:Int = 0

    let size:Int

    var isEOF:Bool {
        return !(position < size)
    }

    init(data:NSData) {
        self.data = data
        self.size = data.length
    }

    func seek(position: Int) {
        self.position = position
    }

    func read() -> UInt8? {
        guard !isEOF else {
            return nil
        }

        var buffer = [UInt8](count: 1, repeatedValue: 0)

        data.getBytes(&buffer, length: 1)

        position += 1

        return buffer[0]
    }

    func read(length: Int) -> [UInt8]? {
        guard !isEOF else {
            return nil
        }

        guard position + length <= size else {
            return nil
        }

        var buffer = [UInt8](count: length, repeatedValue: 0)

        if position == 0 {
            data.getBytes(&buffer, length: length)
        } else {
            let range = NSRange(location: position, length: length)
            data.getBytes(&buffer, range: range)
        }

        position += length

        return buffer
    }
}

private class NSFileHandleSeekableStream:KaitaiSeekableStreamProtocol {
    private let file:NSFileHandle

    private(set) var position:Int = 0

    let size:Int

    var isEOF:Bool {
        return !(position < size)
    }

    init?(path:String) {
        guard let file = NSFileHandle(forReadingAtPath: path) else {
            return nil
        }

        self.file = file
        self.size = Int(file.seekToEndOfFile())

        self.file.seekToFileOffset(0)
    }

    init?(url:NSURL) {
        guard let file = try? NSFileHandle(forReadingFromURL:url) else {
            return nil
        }

        self.file = file
        self.size = Int(file.seekToEndOfFile())

        self.file.seekToFileOffset(0)
    }

    deinit {
        file.closeFile()
    }

    func seek(position: Int) {
        self.position = position
        file.seekToFileOffset(UInt64(position))
    }

    func read() -> UInt8? {
        guard !isEOF else {
            return nil
        }

        let data = file.readDataOfLength(1)

        var buffer = [UInt8](count: 1, repeatedValue: 0)
        data.getBytes(&buffer, length: 1)

        position += 1

        return buffer[0]
    }

    func read(length: Int) -> [UInt8]? {
        guard !isEOF else {
            return nil
        }

        guard position + length <= size else {
            return nil
        }

        let data = file.readDataOfLength(length)

        var buffer = [UInt8](count: length, repeatedValue: 0)
        data.getBytes(&buffer, length: length)

        position += length
        
        return buffer
    }
}
