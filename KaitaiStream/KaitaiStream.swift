//
//  KaitaiStream.swift
//  KaitaiStream
//
//  Created by Dmitry Marochko on 22.04.16.
//
//

import Foundation

// #pragma mark - KaitaiStream
public class KaitaiStream {
    private var stream:KaitaiSeekableStream

    public var position:Int {
        return stream.position
    }
    
    public var isEOF:Bool {
        return stream.isEOF
    }

    public init(bytes:[UInt8]) {
        stream = ByteArraySeekableStream(bytes: bytes)
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
    public func pos() -> Int {
        return position
    }
    
    public func isEof() -> Bool {
        return isEOF
    }

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
        var bytes = [UInt8]()

        while let byte = stream.read() {
            bytes.append(byte)
        }

        guard bytes.count > 0 else {
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

        let string = String(bytes: bytes, encoding: encoding)

        return string
    }

    public func readStrByteLimit(length:Int, encoding: NSStringEncoding) -> String? {
        guard let bytes = readBytes(length) else {
            return nil
        }

        let string = String(bytes: bytes, encoding: encoding)

        return string
    }

    public func readStrz(encoding:NSStringEncoding, termination:UInt8, includeTermination:Bool=false,consumeTermination:Bool=true) -> String? {
        var bytes = [UInt8]()

        while true {
            guard let byte = stream.read() else {
                return nil
            }

            if byte == termination {
                if includeTermination {
                    bytes.append(byte)
                }

                if !consumeTermination {
                    stream.seek(stream.position - 1)
                }

                let string = String(bytes: bytes, encoding: encoding)

                return string
            }

            bytes.append(byte)
        }
    }

    public func processZlib(bytes:[UInt8]) -> [UInt8]? {
        let inflater = InflateStream()

        var bytes = Array(bytes)
        let (inflated,err) = inflater.write(&bytes, flush: true)

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
