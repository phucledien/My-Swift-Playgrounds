import Foundation

protocol CurrencyType {
    static var code: String {get}
    static var symbol: String {get}
    static var name: String {get}
}

enum USD: CurrencyType {
    static var code: String {return "USD"}
    static var symbol: String {return "$"}
    static var name: String {return "US Dollar"}
}

public enum AFN: CurrencyType {
    public static var code: String {
        return "AFN"
    }
    public static var name: String {
        return "Afghani"
    }
    public static var symbol: String {
        return "a"
    }
}

struct Money<C: CurrencyType>: Equatable {
    typealias Currency = C
    
    var amount: Decimal
    
    init(amount: Decimal) {
        self.amount = amount
    }
    
    var currency: CurrencyType.Type {
        return Currency.self
    }
}

extension Money: Comparable {
    static func < (lhs: Money<C>, rhs: Money<C>) -> Bool {
        return lhs.amount < rhs.amount
    }
}

extension Money: ExpressibleByIntegerLiteral {
    public init(integerLiteral value: Int) {
        self.init(amount: Decimal(integerLiteral: value))
    }
}

extension Money: ExpressibleByFloatLiteral {
    public init(floatLiteral value: Double) {
        self.init(amount: Decimal(floatLiteral: value))
    }
}

extension Money {
    static func + (lhs: Money<C>, rhs: Money<C>) -> Money<C> {
        return Money(amount: lhs.amount + rhs.amount)
    }
    
    static func += (lhs: inout Money<C>, rhs: Money<C>) {
        lhs.amount += rhs.amount
    }
}

// Format money
let price: Money<AFN> = 14.00
let formatter = NumberFormatter()
formatter.numberStyle = .currency
formatter.currencyCode = price.currency.code
formatter.locale = Locale(identifier: "fr-FR")
print(formatter.string(for: price.amount)!)


// Exchange money between 2 currencies
protocol UnidirectionalCurrencyConverter {
    associatedtype Fixed: CurrencyType
    associatedtype Variable: CurrencyType
    
    var rate: Decimal {get set}
}

extension UnidirectionalCurrencyConverter {
    func convert(_ value: Money<Fixed>) -> Money<Variable> {
        return Money<Variable>(amount: value.amount * rate)
    }
}

protocol BidirectionalCurrencyConverter: UnidirectionalCurrencyConverter {
    
}

extension BidirectionalCurrencyConverter {
    func convert(_ value: Money<Variable>) -> Money<Fixed> {
        return Money<Fixed>(amount: value.amount / rate)
    }
}

struct CurrencyPair<A: CurrencyType, B: CurrencyType>: BidirectionalCurrencyConverter {
    var rate: Decimal
    typealias Fixed = A
    typealias Variable = B
    
    init(rate: Decimal) {
        precondition(rate > 0)
        self.rate = rate
    }
}

let AFNtoUSD = CurrencyPair<AFN, USD>(rate: 1.17)

let usdAmount: Money<USD> = 123.45
let afnAmount = AFNtoUSD.convert(usdAmount)
print(afnAmount)

