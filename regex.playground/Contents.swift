import Foundation

/// https://nshipster.com/swift-regular-expressions/

/// Regex without NSRegularExpression
func respond(to invitation: String) {
    if let range = invitation.range(of: "\\bClue(do)?™?\\b",
        options: .regularExpression) {
        switch invitation[range] {
        case "Cluedo":
            print("I'd be delighted to play!")
        case "Clue":
            print("Did you mean Cluedo? If so, then yes!")
        default:
            fatalError("(Wait... did I mess up my regular expression?)")
        }
    } else {
        print("Still waiting for an invitation to play Cluedo.")
    }
}

let instructions = """
The object is to solve by means of elimination and deduction
the problem of the mysterious murder of Dr. Black.
"""

let replacedStr = instructions.replacingOccurrences(
    of: "(Dr\\.|Doctor) Black",
    with: "Mr. Boddy",
    options: .regularExpression
)

/// Regex with NSRegularExpression
// You’ll need to use NSRegularExpression if you want to match a pattern more
// than once in a string or extract values from capture groups.

let description = """
Cluedo is a game of skill for 2-6 players.
"""

let pattern = "(\\d+)[ \\p{Pd}](\\d+) players"
let regex = try NSRegularExpression(pattern: pattern, options: [])

var playerRange: ClosedRange<Int>?

let nsrange = NSRange(description.startIndex..<description.endIndex, in: description)

regex.enumerateMatches(in: description, options: [], range: nsrange) { (match, _, stop) in
                        guard let match = match else { return }
                        
                        if match.numberOfRanges == 3,
                            let firstCaptureRange = Range(match.range(at: 1),
                                                          in: description),
                            let secondCaptureRange = Range(match.range(at: 2),
                                                           in: description),
                            let lowerBound = Int(description[firstCaptureRange]),
                            let upperBound = Int(description[secondCaptureRange]),
                            lowerBound > 0 && lowerBound < upperBound
                        {
                            playerRange = lowerBound...upperBound
                            stop.pointee = true
                        }
}

print(playerRange!)
