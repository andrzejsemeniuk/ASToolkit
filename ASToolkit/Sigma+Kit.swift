//
//  SigmaKit.swift
//  ASToolkit
//
//  Created by andrzej semeniuk on 2026-01-19.
//  Copyright © 2026 Andrzej Semeniuk. All rights reserved.
//

import Foundation

extension Sigma {
    
    struct Kit {

        // Source data for calculations
        let values: [Double]

        let count : Int
        
        // MARK: - Cached values
        private(set) var _sum: Double?
        private(set) var _average: Double?
        private(set) var _min: Double?
        private(set) var _max: Double?
        private(set) var _span: Double?
        private(set) var _variancePopulation: Double?
        private(set) var _varianceSample: Double?
        private(set) var _stdDevPopulation: Double?
        private(set) var _stdDevSample: Double?
        private(set) var _standardErrorOfTheMean: Double?
        private(set) var _median: Double?
        private(set) var _medianLow: Double?
        private(set) var _medianHigh: Double?
        private(set) var _skewnessA: Double?
        private(set) var _skewnessB: Double?
        private(set) var _kurtosisA: Double?
        private(set) var _kurtosisB: Double?

        // Central moments cache by order
        private var _centralMoments: [Int: Double] = [:]

        init(values: [Double]) {
            self.values = values
            self.count = values.count
            
            self._sum = nil
            self._average = nil
            self._min = nil
            self._max = nil
            self._span = nil
            self._variancePopulation = nil
            self._varianceSample = nil
            self._stdDevPopulation = nil
            self._stdDevSample = nil
            self._standardErrorOfTheMean = nil
            self._median = nil
            self._medianLow = nil
            self._medianHigh = nil
            self._skewnessA = nil
            self._skewnessB = nil
            self._kurtosisA = nil
            self._kurtosisB = nil
            self._centralMoments = [:]
        }

        // MARK: - Replicated Sigma single-array APIs with caching

        // Sigma.max(_ values: [Double]) -> Double?
        mutating func max() -> Double? {
            if let m = _max { return m }
            guard let m = values.max() else { return nil }
            _max = m
            return m
        }

        // Sigma.min(_ values: [Double]) -> Double?
        mutating func min() -> Double? {
            if let m = _min { return m }
            guard let m = values.min() else { return nil }
            _min = m
            return m
        }

        // Sigma.sum(_ values: [Double]) -> Double
        mutating func sum() -> Double {
            if let s = _sum { return s }
            let s = values.reduce(0, +)
            _sum = s
            return s
        }

        // Sigma.average(_ values: [Double]) -> Double?
        mutating func span() -> Double? {
            if let a = _span { return a }
            guard let m = self.min(), let M = self.max(), m <= M else {
                return nil
            }
            _span = M - m
            return _span
        }

        // Sigma.average(_ values: [Double]) -> Double?
        mutating func average() -> Double? {
            if let a = _average { return a }
            let c = count
            if c == 0 { return nil }
            let a = sum() / Double(c)
            _average = a
            return a
        }

        // Sigma.varianceSample(_ values: [Double]) -> Double?
        mutating func varianceSample() -> Double? {
            if let v = _varianceSample { return v }
            let c = count
            if c < 2 { return nil }
            guard let mean = average() else { return nil }
            let numerator = values.reduce(0.0) { $0 + pow(mean - $1, 2) }
            let v = numerator / Double(c - 1)
            _varianceSample = v
            return v
        }

        // Sigma.variancePopulation(_ values: [Double]) -> Double?
        mutating func variancePopulation() -> Double? {
            if let v = _variancePopulation { return v }
            let c = count
            if c == 0 { return nil }
            guard let mean = average() else { return nil }
            let numerator = values.reduce(0.0) { $0 + pow(mean - $1, 2) }
            let v = numerator / Double(c)
            _variancePopulation = v
            return v
        }

        // Sigma.standardDeviationSample(_ values: [Double]) -> Double?
        mutating func standardDeviationSample() -> Double? {
            if let s = _stdDevSample { return s }
            guard let v = varianceSample() else { return nil }
            let s = sqrt(v)
            _stdDevSample = s
            return s
        }

        // Sigma.standardDeviationPopulation(_ values: [Double]) -> Double?
        mutating func standardDeviationPopulation() -> Double? {
            if let s = _stdDevPopulation { return s }
            guard let v = variancePopulation() else { return nil }
            let s = sqrt(v)
            _stdDevPopulation = s
            return s
        }

        // Sigma.standardErrorOfTheMean(_ values: [Double]) -> Double?
        mutating func standardErrorOfTheMean() -> Double? {
            if let se = _standardErrorOfTheMean { return se }
            let c = count
            if c == 0 { return nil }
            guard let s = standardDeviationSample() else { return nil }
            let se = s / sqrt(Double(c))
            _standardErrorOfTheMean = se
            return se
        }

        // Sigma.median(_ values: [Double]) -> Double?
        mutating func median() -> Double? {
            if let m = _median { return m }
            let c = count
            if c == 0 { return nil }
            let sorted = values.sorted(by: <)
            let result: Double
            if Double(c).truncatingRemainder(dividingBy: 2) == 0 {
                let leftIndex = Int(Double(c) / 2 - 1)
                let leftValue = sorted[leftIndex]
                let rightValue = sorted[leftIndex + 1]
                result = (leftValue + rightValue) / 2
            } else {
                result = sorted[Int(Double(c) / 2)]
            }
            _median = result
            return result
        }

        // Sigma.medianLow(_ values: [Double]) -> Double?
        mutating func medianLow() -> Double? {
            if let m = _medianLow { return m }
            let c = count
            if c == 0 { return nil }
            let sorted = values.sorted(by: <)
            let result: Double
            if Double(c).truncatingRemainder(dividingBy: 2) == 0 {
                result = sorted[Int(Double(c) / 2) - 1]
            } else {
                result = sorted[Int(Double(c) / 2)]
            }
            _medianLow = result
            return result
        }

        // Sigma.medianHigh(_ values: [Double]) -> Double?
        mutating func medianHigh() -> Double? {
            if let m = _medianHigh { return m }
            let c = count
            if c == 0 { return nil }
            let sorted = values.sorted(by: <)
            let result = sorted[Int(Double(c) / 2)]
            _medianHigh = result
            return result
        }

        // Sigma.centralMoment(_ values: [Double], order: Int) -> Double?
        mutating func centralMoment(order: Int) -> Double? {
            if let cached = _centralMoments[order] { return cached }
            let c = Double(count)
            if c == 0 { return nil }
            guard let mean = average() else { return nil }
            let total = values.reduce(0.0) { sum, value in
                sum + pow((value - mean), Double(order))
            }
            let moment = total / c
            _centralMoments[order] = moment
            return moment
        }

        // Sigma.skewnessA(_ values: [Double]) -> Double?
        mutating func skewnessA() -> Double? {
            if let s = _skewnessA { return s }
            let c = Double(count)
            if c < 3 { return nil }
            guard let moment3 = centralMoment(order: 3) else { return nil }
            guard let stdDev = standardDeviationSample() else { return nil }
            if stdDev == 0 { return nil }
            let result = pow(c, 2) / ((c - 1) * (c - 2)) * moment3 / pow(stdDev, 3)
            _skewnessA = result
            return result
        }

        // Sigma.skewnessB(_ values: [Double]) -> Double?
        mutating func skewnessB() -> Double? {
            if let s = _skewnessB { return s }
            if count < 3 { return nil }
            guard let stdDev = standardDeviationPopulation() else { return nil }
            if stdDev == 0 { return nil }
            guard let moment3 = centralMoment(order: 3) else { return nil }
            let result = moment3 / pow(stdDev, 3)
            _skewnessB = result
            return result
        }

        // Sigma.kurtosisA(_ values: [Double]) -> Double?
        mutating func kurtosisA() -> Double? {
            if let k = _kurtosisA { return k }
            let n = Double(count)
            if n < 4 { return nil }
            guard let avg = average() else { return nil }
            guard let stdev = standardDeviationSample() else { return nil }
            var result = values.reduce(0.0) { sum, value in
                let v = (value - avg) / stdev
                return sum + pow(v, 4)
            }
            result *= (n * (n + 1) / ((n - 1) * (n - 2) * (n - 3)))
            result -= 3 * pow(n - 1, 2) / ((n - 2) * (n - 3))
            _kurtosisA = result
            return result
        }

        // Sigma.kurtosisB(_ values: [Double]) -> Double?
        mutating func kurtosisB() -> Double? {
            if let k = _kurtosisB { return k }
            if values.isEmpty { return nil }
            guard let m4 = centralMoment(order: 4) else { return nil }
            guard let m2 = centralMoment(order: 2) else { return nil }
            if m2 == 0 { return nil }
            let result = m4 / pow(m2, 2)
            _kurtosisB = result
            return result
        }

        // Sigma.coefficientOfVariationSample(_ values: [Double]) -> Double?
        mutating func coefficientOfVariationSample() -> Double? {
            if values.count < 2 { return nil }
            guard let stdDev = standardDeviationSample() else { return nil }
            guard let avg = average() else { return nil }
            if avg == 0 { return stdDev >= 0 ? Double.infinity : -Double.infinity }
            return stdDev / avg
        }

        // Sigma.percentile(_ data: [Double], percentile: Double) -> Double?
        // Inside Kit we bind data to `values` and accept the percentile parameter.
        mutating func percentile(percentile: Double) -> Double? {
            return Sigma.quantiles.method7(values, probability: percentile)
        }
    }
    
}
