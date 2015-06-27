// Generated from /Users/brent/Desktop/Projects/WebResponder/WebResponderCore/WebResponderCore/http-status-codes-1.csv by /Users/brent/Desktop/Projects/WebResponder/WebResponderCore/WebResponderCore/codes2swift.swift

public extension HTTPStatus {
    static let Continue = HTTPStatus(code: 100)
    static let SwitchingProtocols = HTTPStatus(code: 101)
    static let Processing = HTTPStatus(code: 102)
    static let OK = HTTPStatus(code: 200)
    static let Created = HTTPStatus(code: 201)
    static let Accepted = HTTPStatus(code: 202)
    static let NonAuthoritativeInformation = HTTPStatus(code: 203)
    static let NoContent = HTTPStatus(code: 204)
    static let ResetContent = HTTPStatus(code: 205)
    static let PartialContent = HTTPStatus(code: 206)
    static let MultiStatus = HTTPStatus(code: 207)
    static let AlreadyReported = HTTPStatus(code: 208)
    static let IMUsed = HTTPStatus(code: 226)
    static let MultipleChoices = HTTPStatus(code: 300)
    static let MovedPermanently = HTTPStatus(code: 301)
    static let Found = HTTPStatus(code: 302)
    static let SeeOther = HTTPStatus(code: 303)
    static let NotModified = HTTPStatus(code: 304)
    static let UseProxy = HTTPStatus(code: 305)
    static let Unused = HTTPStatus(code: 306)
    static let TemporaryRedirect = HTTPStatus(code: 307)
    static let PermanentRedirect = HTTPStatus(code: 308)
    static let BadRequest = HTTPStatus(code: 400)
    static let Unauthorized = HTTPStatus(code: 401)
    static let PaymentRequired = HTTPStatus(code: 402)
    static let Forbidden = HTTPStatus(code: 403)
    static let NotFound = HTTPStatus(code: 404)
    static let MethodNotAllowed = HTTPStatus(code: 405)
    static let NotAcceptable = HTTPStatus(code: 406)
    static let ProxyAuthenticationRequired = HTTPStatus(code: 407)
    static let RequestTimeout = HTTPStatus(code: 408)
    static let Conflict = HTTPStatus(code: 409)
    static let Gone = HTTPStatus(code: 410)
    static let LengthRequired = HTTPStatus(code: 411)
    static let PreconditionFailed = HTTPStatus(code: 412)
    static let PayloadTooLarge = HTTPStatus(code: 413)
    static let URITooLong = HTTPStatus(code: 414)
    static let UnsupportedMediaType = HTTPStatus(code: 415)
    static let RangeNotSatisfiable = HTTPStatus(code: 416)
    static let ExpectationFailed = HTTPStatus(code: 417)
    static let MisdirectedRequest = HTTPStatus(code: 421)
    static let UnprocessableEntity = HTTPStatus(code: 422)
    static let Locked = HTTPStatus(code: 423)
    static let FailedDependency = HTTPStatus(code: 424)
    static let UpgradeRequired = HTTPStatus(code: 426)
    static let PreconditionRequired = HTTPStatus(code: 428)
    static let TooManyRequests = HTTPStatus(code: 429)
    static let RequestHeaderFieldsTooLarge = HTTPStatus(code: 431)
    static let InternalServerError = HTTPStatus(code: 500)
    static let NotImplemented = HTTPStatus(code: 501)
    static let BadGateway = HTTPStatus(code: 502)
    static let ServiceUnavailable = HTTPStatus(code: 503)
    static let GatewayTimeout = HTTPStatus(code: 504)
    static let HTTPVersionNotSupported = HTTPStatus(code: 505)
    static let VariantAlsoNegotiates = HTTPStatus(code: 506)
    static let InsufficientStorage = HTTPStatus(code: 507)
    static let LoopDetected = HTTPStatus(code: 508)
    static let NotExtended = HTTPStatus(code: 510)
    static let NetworkAuthenticationRequired = HTTPStatus(code: 511)
    
    static var messages: [HTTPStatus: String] = [
        100: "Continue",
        101: "Switching Protocols",
        102: "Processing",
        200: "OK",
        201: "Created",
        202: "Accepted",
        203: "Non-Authoritative Information",
        204: "No Content",
        205: "Reset Content",
        206: "Partial Content",
        207: "Multi-Status",
        208: "Already Reported",
        226: "IM Used",
        300: "Multiple Choices",
        301: "Moved Permanently",
        302: "Found",
        303: "See Other",
        304: "Not Modified",
        305: "Use Proxy",
        306: "(Unused)",
        307: "Temporary Redirect",
        308: "Permanent Redirect",
        400: "Bad Request",
        401: "Unauthorized",
        402: "Payment Required",
        403: "Forbidden",
        404: "Not Found",
        405: "Method Not Allowed",
        406: "Not Acceptable",
        407: "Proxy Authentication Required",
        408: "Request Timeout",
        409: "Conflict",
        410: "Gone",
        411: "Length Required",
        412: "Precondition Failed",
        413: "Payload Too Large",
        414: "URI Too Long",
        415: "Unsupported Media Type",
        416: "Range Not Satisfiable",
        417: "Expectation Failed",
        421: "Misdirected Request",
        422: "Unprocessable Entity",
        423: "Locked",
        424: "Failed Dependency",
        426: "Upgrade Required",
        428: "Precondition Required",
        429: "Too Many Requests",
        431: "Request Header Fields Too Large",
        500: "Internal Server Error",
        501: "Not Implemented",
        502: "Bad Gateway",
        503: "Service Unavailable",
        504: "Gateway Timeout",
        505: "HTTP Version Not Supported",
        506: "Variant Also Negotiates",
        507: "Insufficient Storage",
        508: "Loop Detected",
        510: "Not Extended",
        511: "Network Authentication Required",
    ]
}
