// Generated from /Users/brent/Desktop/Projects/WebResponder/WebResponderCore/http-status-codes-1.csv by /Users/brent/Desktop/Projects/WebResponder/WebResponderCore/codes2swift.swift

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
    
    var message: String {
        switch self {
            case 100: return "Continue"
            case 101: return "Switching Protocols"
            case 102: return "Processing"
            case 200: return "OK"
            case 201: return "Created"
            case 202: return "Accepted"
            case 203: return "Non-Authoritative Information"
            case 204: return "No Content"
            case 205: return "Reset Content"
            case 206: return "Partial Content"
            case 207: return "Multi-Status"
            case 208: return "Already Reported"
            case 226: return "IM Used"
            case 300: return "Multiple Choices"
            case 301: return "Moved Permanently"
            case 302: return "Found"
            case 303: return "See Other"
            case 304: return "Not Modified"
            case 305: return "Use Proxy"
            case 306: return "(Unused)"
            case 307: return "Temporary Redirect"
            case 308: return "Permanent Redirect"
            case 400: return "Bad Request"
            case 401: return "Unauthorized"
            case 402: return "Payment Required"
            case 403: return "Forbidden"
            case 404: return "Not Found"
            case 405: return "Method Not Allowed"
            case 406: return "Not Acceptable"
            case 407: return "Proxy Authentication Required"
            case 408: return "Request Timeout"
            case 409: return "Conflict"
            case 410: return "Gone"
            case 411: return "Length Required"
            case 412: return "Precondition Failed"
            case 413: return "Payload Too Large"
            case 414: return "URI Too Long"
            case 415: return "Unsupported Media Type"
            case 416: return "Range Not Satisfiable"
            case 417: return "Expectation Failed"
            case 421: return "Misdirected Request"
            case 422: return "Unprocessable Entity"
            case 423: return "Locked"
            case 424: return "Failed Dependency"
            case 426: return "Upgrade Required"
            case 428: return "Precondition Required"
            case 429: return "Too Many Requests"
            case 431: return "Request Header Fields Too Large"
            case 500: return "Internal Server Error"
            case 501: return "Not Implemented"
            case 502: return "Bad Gateway"
            case 503: return "Service Unavailable"
            case 504: return "Gateway Timeout"
            case 505: return "HTTP Version Not Supported"
            case 506: return "Variant Also Negotiates"
            case 507: return "Insufficient Storage"
            case 508: return "Loop Detected"
            case 510: return "Not Extended"
            case 511: return "Network Authentication Required"
            default: return "Unassigned"
        }
    }
}
