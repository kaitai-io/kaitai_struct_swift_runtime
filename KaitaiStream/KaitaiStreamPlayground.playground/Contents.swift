import Foundation
import KaitaiStream

// 0123\n4567\n
let ks = KaitaiStream(path:"/Users/mothlike/Downloads/test.txt")!

ks.readBytes(3)
ks.position
ks.isEOF
ks.readU1()
ks.position
ks.isEOF
ks.seek(1)
ks.readS1()

ks.seek(0)
ks.readStrEos(NSUTF8StringEncoding)
ks.seek(0)
ks.readStrByteLimit(NSUTF8StringEncoding,length: 4)
ks.seek(0)
ks.readStrz(NSUTF8StringEncoding, termination: 10)