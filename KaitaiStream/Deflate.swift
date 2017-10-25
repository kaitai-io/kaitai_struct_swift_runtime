/*
* DeflateSwift (deflate.swift)
*
* Copyright (C) 2015 ONcast, LLC. All Rights Reserved.
* Created by Josh Baker (joshbaker77@gmail.com)
*
* This software may be modified and distributed under the terms
* of the MIT license.  See the LICENSE file for details.
*
*/

import Foundation

open class ZStream {
    fileprivate struct z_stream {
        fileprivate var next_in : UnsafePointer<UInt8>? = nil
        fileprivate var avail_in : CUnsignedInt = 0
        fileprivate var total_in : CUnsignedLong = 0
        
        fileprivate var next_out : UnsafePointer<UInt8>? = nil
        fileprivate var avail_out : CUnsignedInt = 0
        fileprivate var total_out : CUnsignedLong = 0
        
        fileprivate var msg : UnsafePointer<CChar>? = nil
        fileprivate var state : OpaquePointer? = nil
        
        fileprivate var zalloc : OpaquePointer? = nil
        fileprivate var zfree : OpaquePointer? = nil
        fileprivate var opaque : OpaquePointer? = nil
        
        fileprivate var data_type : CInt = 0
        fileprivate var adler : CUnsignedLong = 0
        fileprivate var reserved : CUnsignedLong = 0
    }
    
    @_silgen_name("zlibVersion") fileprivate static func zlibVersion() -> OpaquePointer
    @_silgen_name("deflateInit2_") fileprivate func deflateInit2(_ strm : UnsafeMutableRawPointer, level : CInt, method : CInt, windowBits : CInt, memLevel : CInt, strategy : CInt, version : OpaquePointer, stream_size : CInt) -> CInt
    @_silgen_name("deflateInit_") fileprivate func deflateInit(_ strm : UnsafeMutableRawPointer, level : CInt, version : OpaquePointer, stream_size : CInt) -> CInt
    @_silgen_name("deflateEnd") fileprivate func deflateEnd(_ strm : UnsafeMutableRawPointer) -> CInt
    @_silgen_name("deflate") fileprivate func deflate(_ strm : UnsafeMutableRawPointer, flush : CInt) -> CInt
    @_silgen_name("inflateInit2_") fileprivate func inflateInit2(_ strm : UnsafeMutableRawPointer, windowBits : CInt, version : OpaquePointer, stream_size : CInt) -> CInt
    @_silgen_name("inflateInit_") fileprivate func inflateInit(_ strm : UnsafeMutableRawPointer, version : OpaquePointer, stream_size : CInt) -> CInt
    @_silgen_name("inflate") fileprivate func inflate(_ strm : UnsafeMutableRawPointer, flush : CInt) -> CInt
    @_silgen_name("inflateEnd") fileprivate func inflateEnd(_ strm : UnsafeMutableRawPointer) -> CInt
    
    fileprivate static var c_version : OpaquePointer = ZStream.zlibVersion()
    fileprivate(set) static var version : String = String(format: "%s", locale: nil, c_version)
    
    fileprivate func makeError(_ res : CInt) -> NSError? {
        var err = ""
        switch res {
        case 0: return nil
        case 1: err = "stream end"
        case 2: err = "need dict"
        case -1: err = "errno"
        case -2: err = "stream error"
        case -3: err = "data error"
        case -4: err = "mem error"
        case -5: err = "buf error"
        case -6: err = "version error"
        default: err = "undefined error"
        }
        return NSError(domain: "deflateswift", code: -1, userInfo: [NSLocalizedDescriptionKey:err])
    }
    
    fileprivate var strm = z_stream()
    fileprivate var deflater = true
    fileprivate var initd = false
    fileprivate var init2 = false
    fileprivate var level = CInt(-1)
    fileprivate var windowBits = CInt(15)
    fileprivate var out = [UInt8](repeating: 0, count: 5000)
    public init() { }
    open func write(_ bytes : inout [UInt8], flush: Bool) -> (bytes: [UInt8], err: NSError?){
        var res : CInt
        if !initd {
            if deflater {
                if init2 {
                    res = deflateInit2(&strm, level: level, method: 8, windowBits: windowBits, memLevel: 8, strategy: 0, version: ZStream.c_version, stream_size: CInt(MemoryLayout<z_stream>.size))
                } else {
                    res = deflateInit(&strm, level: level, version: ZStream.c_version, stream_size: CInt(MemoryLayout<z_stream>.size))
                }
            } else {
                if init2 {
                    res = inflateInit2(&strm, windowBits: windowBits, version: ZStream.c_version, stream_size: CInt(MemoryLayout<z_stream>.size))
                } else {
                    res = inflateInit(&strm, version: ZStream.c_version, stream_size: CInt(MemoryLayout<z_stream>.size))
                }
            }
            if res != 0{
                return ([UInt8](), makeError(res))
            }
            initd = true
        }
        var result = [UInt8]()
        strm.avail_in = CUnsignedInt(bytes.count)
        strm.next_in = &bytes+0
        repeat {
            strm.avail_out = CUnsignedInt(out.count)
            strm.next_out = &out+0
            if deflater {
                res = deflate(&strm, flush: flush ? 1 : 0)
            } else {
                res = inflate(&strm, flush: flush ? 1 : 0)
            }
            if res < 0 {
                return ([UInt8](), makeError(res))
            }
            let have = out.count - Int(strm.avail_out)
            if have > 0 {
                result += Array(out[0...have-1])
            }
        } while (strm.avail_out == 0 && res != 1)
        if strm.avail_in != 0 {
            return ([UInt8](), makeError(-9999))
        }
        return (result, nil)
    }
    deinit{
        if initd{
            if deflater {
                deflateEnd(&strm)
            } else {
                inflateEnd(&strm)
            }
        }
    }
}

open class DeflateStream : ZStream {
    convenience public init(level : Int){
        self.init()
        self.level = CInt(level)
    }
    convenience public init(windowBits: Int){
        self.init()
        self.init2 = true
        self.windowBits = CInt(windowBits)
    }
    convenience public init(level : Int, windowBits: Int){
        self.init()
        self.init2 = true
        self.level = CInt(level)
        self.windowBits = CInt(windowBits)
    }
}

open class InflateStream : ZStream {
    override public init(){
        super.init()
        deflater = false
    }
    convenience public init(windowBits: Int){
        self.init()
        self.init2 = true
        self.windowBits = CInt(windowBits)
    }
}
