// Whirlpool hash function.

var whirlpool = {}

// Computes the Whirlpool hash.
// Examples of use:
//
//	whirlpool.hash('abc')
//	whirlpool.hash([0x61, 0x62, 0x63])
//	whirlpool.hash(function(i) { return (i*i) & 0xff }, 1000)
//
// Returns a 64-byte array of bytes.

whirlpool.hash = function(bytes, length)
{
    var n = whirlpool.dim

    // pipeline: src byte :> reader :> hub :> comp

    var comp = new whirlpool.compressor(whirlpool.initvector)
    var hub = new whirlpool.hub(n*n, function(a) { comp.push(a) })
    var reader = new whirlpool.reader(n*n/2, function(a) { hub.push(a) })

    var push = function(b)
    {
        if (typeof b == 'number' && Math.floor(b) == b && b >= 0 && b <= 255)
        {
            reader.push(b)
            return true
        }
    }

    switch (typeof bytes)
    {
    case 'object':
        for (var i = 0; i < (length || bytes.length); i++)
            if (!push(bytes[i]))
                return
        break

    case 'string':
        for (var i = 0; i < (length || bytes.length); i++)
            if (!push(bytes.charCodeAt(i)))
                return
        break

    case 'function':
        for (var i = 0; i < length; i++)
            if (!push(bytes(i)))
                return
        break

    default:
        return
    }

    reader.finish()

    return whirlpool.output(comp.state)
}

// This function is called automatically.

whirlpool.initialise = function()
{
    whirlpool.diffuserow	= [1, 1, 4, 1, 8, 5, 2, 9]
    whirlpool.rbox			= [7, 12, 11, 13, 14, 4, 9, 15, 6, 3, 8, 10, 2, 5, 1, 0]
    whirlpool.dim			= 8
    whirlpool.rounds		= 10
    whirlpool.initvector	= whirlpool.vector(whirlpool.dim*whirlpool.dim, 0)
}

// Algorithm-specific functions.

whirlpool.ebox = function(i)
{
    var mul = whirlpool.gf4mul
    var ebox = whirlpool.ebox

    switch(i)
    {
    case 0:		return 1
    case 0xf:	return 0
    default:	return mul(ebox(i - 1), 0xb)
    }
}

whirlpool.invebox = function(i)
{
    for (var j = 0; j < 16; j++)
        if (whirlpool.ebox(j) == i)
            return j
}

whirlpool.sbox = function(i)
{
    var v = i & 0xf
    var u = i >> 4

    var e = whirlpool.ebox
    var ie = whirlpool.invebox

    var a = whirlpool.rbox[e(u) ^ ie(v)]
    var u = e(e(u) ^ a)
    var v = ie(ie(v) ^ a)

    return (u << 4) ^ v
}

whirlpool.input = function(row)
{
    var n = whirlpool.sqrt(row.length)
    var m = whirlpool.matrix(n, n)

    for (var i = 0; i < n; i++)
        for (var j = 0; j < n; j++)
            m[i][j] = row[i*n + j]

    return m
}

whirlpool.output = function(matrix)
{
    var n = matrix.length
    var row = new Array(n)

    for (var i = 0; i < n; i++)
        for (var j = 0; j < n; j++)
            row[i*n + j] = matrix[i][j]

    return row
}

whirlpool.apply = function(a)
{
    var n = a.length
    var b = whirlpool.matrix(n, n)

    for (var i = 0; i < n; i++)
        for (var j = 0; j < n; j++)
            b[i][j] = whirlpool.sbox(a[i][j])

    return b
}

whirlpool.rotate = function(a)
{
    var n = a.length
    var b = whirlpool.matrix(n, n)

    for (var j = 0; j < n; j++)
        for (var i = 0; i < n; i++)
            b[i][j] = a[(i + n - j) % n][j]

    return b
}

whirlpool.diffuse = function(a)
{
    var n = whirlpool.dim
    var b = whirlpool.matrix(n, n, 0)

    var mul	= whirlpool.gf8mul
    var row = whirlpool.diffuserow

    for (var i = 0; i < n; i++)
        for (var j = 0; j < n; j++)
            for (var k = 0; k < n; k++)
                b[i][j] ^= mul(a[i][k], row[(j - k + n) % n])

    return b
}

whirlpool.rfun = function(k, a)
{
    a = whirlpool.apply(a)
    a = whirlpool.rotate(a)
    a = whirlpool.diffuse(a)
    a = whirlpool.add(a, k)

    return a
}

whirlpool.cipher = function(key, text)
{
    var n = whirlpool.dim
    var w = whirlpool.add(key, text)
    var rcon = whirlpool.matrix(n, n, 0)

    for (var r = 1; r <= whirlpool.rounds; r++)
    {
        for (var i = 0; i < n; i++)
            rcon[0][i] = whirlpool.sbox(n*(r - 1) + i)

        key = whirlpool.rfun(rcon, key)
        w = whirlpool.rfun(key, w)
    }

    return w
}

// Finite fields.

whirlpool.gf4mul = function(a, b)
{
    var c = 0

    while (b != 0)
    {
        if (b & 1)
            c ^= a

        b = b >> 1
        a = a << 1

        if (a & 0x10)
            a ^= 0x13
    }

    return c
}

whirlpool.gf8mul = function(a, b)
{
    var c = 0

    while (b != 0)
    {
        if (b & 1)
            c ^= a

        b = b >> 1
        a = a << 1

        if (a & 0x100)
            a ^= 0x11d
    }

    return c
}

// Creates a reader-object that reads bytes and returns chunks of 32 bytes.

whirlpool.reader = function(size, handler)
{
    this.pop = handler
    this.length = 0
    this.chunk = new Array(size)
}

whirlpool.reader.prototype.push = function(byte)
{
    var c = this.chunk
    var n = this.length % c.length

    c[n] = byte
    this.length++

    if (n + 1 == c.length)
        this.pop(c)
}

whirlpool.reader.prototype.finish = function()
{
    var len = this.length * 8 // number of bits
    var c = this.chunk

    this.push(0x80)

    while (this.length % c.length != 0 || (this.length / c.length) % 2 == 0)
        this.push(0)

    for (var i = 0; i < c.length; i++)
    {
        c[c.length - 1 - i] = len & 0xff
        len >>= 8
    }

    this.pop(c)
}

// Creates a compressor of 32-byte blocks.

whirlpool.compressor = function(initstate)
{
    this.state = whirlpool.input(initstate)
}

whirlpool.compressor.prototype.push = function(block)
{
    var h = this.state
    var m = whirlpool.input(block)
    var c = whirlpool.cipher(h, m)

    var n = whirlpool.dim

    for (var i = 0; i < n; i++)
        for (var j = 0; j < n; j++)
            h[i][j] ^= c[i][j] ^ m[i][j]
}

// Creates a hub that accepts a sequence of bytes and returns blocks of needed size.

whirlpool.hub = function(size, handler)
{
    this.pop = handler
    this.cache = new Array(size)
    this.length = 0
}

whirlpool.hub.prototype.pushbyte = function(byte)
{
    var cache = this.cache
    var i = this.length % cache.length

    cache[i] = byte
    this.length++

    if (i + 1 == cache.length)
        this.pop(this.cache)
}

whirlpool.hub.prototype.push = function(data)
{
    for (var i in data)
        this.pushbyte(data[i])
}

// Miscellaneous functions.

whirlpool.matrix = function(rows, cols, init)
{
    var m = new Array(rows)

    for (var i = 0; i < rows; i++)
        m[i] = new Array(cols)

    for (var i = 0; i < rows; i++)
        for (var j = 0; j < cols; j++)
            m[i][j] = init || 0

    return m
}

whirlpool.vector = function(n, init)
{
    var res = new Array(n)

    for (var i = 0; i < n; i++)
        res[i] = init || 0

    return res
}

whirlpool.sqrt = function(n)
{
    for (var i = 0; i < n; i++)
        if (i*i == n)
            return i
}

whirlpool.add = function(a, b)
{
    var n = a.length
    var c = whirlpool.matrix(n, n)

    for (var i = 0; i < n; i++)
        for (var j = 0; j < n; j++)
            c[i][j] = a[i][j] ^ b[i][j]

    return c
}

// Initialisation.

whirlpool.initialise()

// Optimisations.

whirlpool.cached = function(f)
{
    var a = {}

    return function(x)
    {
        if (a[x] !== undefined)
            return a[x]

        a[x] = f(x)
        return a[x]
    }
}

whirlpool.sbox = whirlpool.cached(whirlpool.sbox)


// Utility
// Provides a various functions

var charset = {}

charset.range = function(min, max)
{
    var min_v = min.charCodeAt(0);
    var max_v = max.charCodeAt(0);

    var list = [];

    for (var i = min_v; i <= max_v; i++)
        list.push(i);

    return list;
}
charset.digits 		= charset.range('0', '9');
charset.lowerCase 	= charset.range('a', 'z');
charset.upperCase 	= charset.range('A', 'Z');
charset.letters 	= [].concat(charset.lowerCase, charset.upperCase);
charset.alphaNumeric	= [].concat(charset.letters, charset.digits);
charset.apply = function(list, cs) {
    var res = [];

    for (var i = 0; i < list.length; i++)
        res.push(cs[list[i] % cs.length]);

    return res;
}

//function getPasswordCS(str, key) {
//    var h = whirlpool.hash(str + whirlpool.hash(key));
//    var pass = charset.apply(h, charset.alphaNumeric);
//    return String.fromCharCode.apply(this, pass);
//}


function sign(x) {
    return typeof x === 'number' ? x ? x < 0 ? -1 : 1 : x === x ? 0 : NaN : NaN;
}

function getsign(num) {
    return sign(num/255.0 - 0.5);
}

function getVars(str, key) {
    var h = whirlpool.hash(str + whirlpool.hash(key));
    var pass = charset.apply(h, charset.alphaNumeric);
    pass = String.fromCharCode.apply(this, pass);

    var tuple = {};

    tuple.color = h[0]*0xFFFF + h[1]*0xFF +h[2];
    var color_inverse = 0xFFFFFF - color;
    tuple.rotate = ((h[0] / 255.0) - (h[1] / 255.0) + (h[2] / 255.0)) / 2 * 90 * getsign(h[3]);
    tuple.pass = pass;

    return tuple;
}

