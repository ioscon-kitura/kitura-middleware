import Kitura
import LoggerAPI
import Foundation

public class ResponseTime: RouterMiddleware {

    let precision: Int
    let includeSuffix: Bool

    public init(precision: Int = 3, includeSuffix: Bool = true) {
        self.precision = precision
        self.includeSuffix = includeSuffix
    }

    public func handle(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) throws {
        let startTime = NSDate()
        var previousOnEndInvoked = {}
        previousOnEndInvoked = response.setOnEndInvoked() { [unowned self] in
            let timeElapsed = startTime.timeIntervalSinceNow

            let formatter = NumberFormatter()
            formatter.maximumFractionDigits = self.precision
            
            let millisecondOutput = formatter.string(from: NSNumber(value: abs(timeElapsed) * 1000))
            if let millisecondOutput = millisecondOutput {
                let value = self.includeSuffix ? millisecondOutput + "ms" : millisecondOutput
                Log.info("Response time = \(value)")
            }
            previousOnEndInvoked()
        }
        next()
    }
}

