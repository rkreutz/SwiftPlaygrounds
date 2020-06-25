import UIKit

public struct Beer: Equatable, Comparable {

    public typealias `Type` = Int

    public enum Aging: Int {

        case classic
        case barrelAged
    }

    var type: Type
    var aging: Aging

    var cost: Int { aging.rawValue }

    public static func < (lhs: Beer, rhs: Beer) -> Bool { lhs.type < rhs.type }

    func isCompatible(with beer: Beer) -> Bool {

        guard type == beer.type else { return true }
        return aging == beer.aging
    }
}

public typealias BeerBatch = [Beer]

extension BeerBatch: Comparable {

    public static func < (lhs: BeerBatch, rhs: BeerBatch) -> Bool {

        lhs.reduce(into: 0, { $0 += $1.cost }) < rhs.reduce(into: 0, { $0 += $1.cost })
    }

    func isCompatible(with beer: Beer) -> Bool {

        !contains(where: { !$0.isCompatible(with: beer) })
    }

    func isCompatible() -> Bool {

        !enumerated().contains { index, beer in

            let remaining = Array(self.dropFirst(index + 1))
            return !remaining.isCompatible(with: beer)
        }
    }
}

extension BeerBatch: ExpressibleByDictionaryLiteral {

    public init(dictionaryLiteral elements: (Beer.`Type`, Beer.Aging)...) {

        self.init(elements.map(Beer.init))
    }
}






func bruteForceBatch(beerTypes: Int, customers: [BeerBatch]) -> BeerBatch? {

    let defaultBatch = (1 ... beerTypes).map { Beer(type: $0, aging: .classic) }

    func recursivePossibleBatches(temporaryBatch: BeerBatch, remainingCustomers: [BeerBatch]) -> [BeerBatch] {

        guard let customer = remainingCustomers.first else {

            guard temporaryBatch.isCompatible() else { return [] }
            return [temporaryBatch]
        }

        return customer.flatMap { recursivePossibleBatches(temporaryBatch: temporaryBatch + [$0], remainingCustomers: Array(remainingCustomers.dropFirst())) }
    }

    let possibleBatches = recursivePossibleBatches(temporaryBatch: [], remainingCustomers: customers)

    guard let batch = possibleBatches.min() else { return nil }

    return defaultBatch
        .map { beer in

            guard let batchBeer = batch.first(where: { $0.type == beer.type }) else { return beer }
            return batchBeer
        }
        .sorted()
}

var beerTypes = 5
var customers: [BeerBatch] = [
    [1: .barrelAged, 3: .classic, 5: .classic],
    [2: .classic, 3: .barrelAged, 4: .classic],
    [5: .barrelAged]
]

bruteForceBatch(beerTypes: beerTypes, customers: customers)

beerTypes = 1
customers = [
    [1: .classic],
    [1: .barrelAged]
]

bruteForceBatch(beerTypes: beerTypes, customers: customers)


beerTypes = 5
customers = [
    [2: .barrelAged],
    [5: .classic],
    [1: .classic],
    [5: .classic, 1: .classic, 4: .barrelAged],
    [3: .classic],
    [5: .classic],
    [3: .classic, 5: .classic, 1: .classic],
    [3: .classic],
    [2: .barrelAged],
    [5: .classic, 1: .classic],
    [2: .barrelAged],
    [5: .classic],
    [4: .barrelAged],
    [5: .classic, 4: .barrelAged]
]

bruteForceBatch(beerTypes: beerTypes, customers: customers)


beerTypes = 3
customers = [
    [1: .classic, 2: .barrelAged],
    [1: .barrelAged],
    [1: .classic, 2: .classic, 3: .barrelAged]
]

bruteForceBatch(beerTypes: beerTypes, customers: customers)

beerTypes = 2
customers = [
    [1: .classic, 2: .barrelAged],
    [1: .barrelAged]
]

bruteForceBatch(beerTypes: beerTypes, customers: customers)
