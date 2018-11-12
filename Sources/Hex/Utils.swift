/******************************************************************************
 *                                                                            *
 * Tris Foundation disclaims copyright to this source code.                   *
 * In place of a legal notice, here is a blessing:                            *
 *                                                                            *
 *     May you do good and not evil.                                          *
 *     May you find forgiveness for yourself and forgive others.              *
 *     May you share freely, never taking more than you give.                 *
 *                                                                            *
 ******************************************************************************/
 
extension BinaryInteger {
    var isEven: Bool {
        @inline(__always) 
        get { return self & 1 == 0 }
    }

    var twice: Self {
        @inline(__always) 
        get { return self << 1 }
    }

    var half: Self {
        @inline(__always) 
        get { return self >> 1 }
    }
}
