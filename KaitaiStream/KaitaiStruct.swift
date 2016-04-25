//
//  KaitaiStruct.swift
//  KaitaiStream
//
//  Created by Mothlike on 25.04.16.
//  Copyright © 2016 Dmitry Marochko. All rights reserved.
//

import Foundation

public protocol KaitaiStruct {
    var _io:KaitaiStream { get }
    var _root:KaitaiStruct? { get }
    var _parent:KaitaiStruct? { get }
}
