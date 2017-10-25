//
//  KaitaiStream.swift
//  KaitaiStream
//
//  Created by Dmitry Marochko on 22.04.16.
//
//

import Foundation

// #pragma mark - KaitaiStream
open class KaitaiStream {
    fileprivate var stream:KaitaiSeekableStream

    open var position:Int {
        return stream.position
    }
    
    open var isEOF:Bool {
        return stream.isEOF
    }

    public init(bytes:[UInt8]) {
        stream = ByteArraySeekableStream(bytes: bytes)
    }

    public init(data:Data) {
        stream = NSDataSeekableStream(data: data);
    }

    public init?(path:String) {
        guard let filestream = NSFileHandleSeekableStream(path: path) else {
            return nil
        }

        stream = filestream
    }

    public init?(url:URL) {
        guard let filestream = NSFileHandleSeekableStream(url: url) else {
            return nil
        }

        stream = filestream
    }

    // methods
    open func pos() -> Int {
        return position
    }
    
    open func isEof() -> Bool {
        return isEOF
    }

    open func seek(_ position:Int) {
        stream.seek(position)
    }

    open func readS1() -> Int8? {
        guard let value = stream.read() else {
            return nil
        }

        let valueInt = Int8(bitPattern: value)

        return valueInt
    }

    open func readU1() -> UInt8? {
        guard let value = stream.read() else {
            return nil
        }

        return value
    }

    open func readU2le() -> UInt? {
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

    open func readU2be() -> UInt? {
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

    open func readS2le() -> Int? {
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

    open func readS2be() -> Int? {
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

    open func readU4le() -> UInt? {
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

    open func readU4be() -> UInt? {
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

    open func readS4le() -> Int? {
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

    open func readS4be() -> Int? {
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

    open func readU8le() -> UInt? {
        guard let value1 = readU4le() else {
            return nil
        }

        guard let value2 = readU4le() else {
            return nil
        }

        return (value2 << 32) + (value1 << 0)
    }

    open func readU8be() -> UInt? {
        guard let value1 = readU4le() else {
            return nil
        }

        guard let value2 = readU4le() else {
            return nil
        }

        return (value1 << 32) + (value2 << 0)
    }

    open func readS8le() -> Int? {
        guard let value1 = readS4le() else {
            return nil
        }

        guard let value2 = readS4le() else {
            return nil
        }

        return (value2 << 32) + (value1 << 0)
    }

    open func readS8be() -> Int? {
        guard let value1 = readS4le() else {
            return nil
        }

        guard let value2 = readS4le() else {
            return nil
        }

        return (value1 << 32) + (value2 << 0)
    }

    open func readBytes(_ length:Int) -> [UInt8]? {
        guard let bytes = stream.read(length) else {
            return nil
        }

        return bytes
    }

    open func readBytesFull() -> [UInt8]? {
        var bytes = [UInt8]()

        while let byte = stream.read() {
            bytes.append(byte)
        }

        guard bytes.count > 0 else {
            return nil
        }

        return bytes
    }

    open func ensureFixedContents(_ length:Int,bytes:[UInt8]) -> [UInt8]? {
        guard let actualBytes = readBytes(length) else {
            return nil
        }

        guard bytes == actualBytes else {
            return nil
        }

        return actualBytes
    }

    open func readStrEos(_ encoding: String.Encoding) -> String? {
        guard let bytes = readBytesFull() else {
            return nil
        }

        let string = String(bytes: bytes, encoding: encoding)

        return string
    }

    open func readStrByteLimit(_ length:Int, encoding: String.Encoding) -> String? {
        guard let bytes = readBytes(length) else {
            return nil
        }

        let string = String(bytes: bytes, encoding: encoding)

        return string
    }

    open func readStrz(_ encoding:String.Encoding, termination:UInt8, includeTermination:Bool=false,consumeTermination:Bool=true) -> String? {
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

    open func processZlib(_ bytes:[UInt8]) -> [UInt8]? {
        let inflater = InflateStream()

        var bytes = Array(bytes)
        let (inflated,err) = inflater.write(&bytes, flush: true)

        guard err == nil else {
            return nil
        }

        return inflated
    }

    open func processRotateLeft(_ bytes:[UInt8],amount:UInt,groupSize:Int=1) -> [UInt8]? {
        var r = [UInt8](repeating: 0, count: 0)

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

    open func byteArrayToHex(_ bytes:[UInt8]) -> String {
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
