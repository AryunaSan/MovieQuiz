//
//  StatisticServiceImplementation.swift
//  MovieQuiz
//
//  Created by Aryuna on 20.05.2024.
//

import Foundation
final class StatisticServiceImplementation: StatisticService {
    private let userDefaults = UserDefaults.standard
    private enum Keys: String {
        case gamesCount
        case bestGame
        case total
        case correct
    }
    var total: Int {
        get {
            userDefaults.integer(forKey: Keys.total.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.total.rawValue)
        }
    }
    var correct: Int {
        get {
            userDefaults.integer(forKey: Keys.correct.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.correct.rawValue)
        }
    }
    
    var gamesCount: Int{
        get {
            userDefaults.integer(forKey: Keys.gamesCount.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }
    
    var bestGame: GameResult {
        get {
            guard let data = userDefaults.data(forKey: Keys.bestGame.rawValue),
                  let record = try? JSONDecoder().decode(GameResult.self, from: data) else {
                return .init(correct: 0, total: 0, date: Date())
            }
            return record
        }
        set {
            guard let data = try? JSONEncoder().encode(newValue) else {
                print("Невозможно загрузить данные")
                return
            }
            userDefaults.set(data, forKey: Keys.bestGame.rawValue)
        }
    }
    var totalAccuracy: Double {
        let totalCorrect = userDefaults.integer(forKey: Keys.correct.rawValue)
        let totalQuestions = userDefaults.integer(forKey: Keys.total.rawValue)
        return Double(totalCorrect) / Double(totalQuestions) * 100
    }
    
    func store(correct count: Int, total amount: Int) {
        correct += count
        total += amount
        gamesCount += 1
        
        let newRecord = GameResult(correct: count, total: amount, date: Date())
        
        if newRecord.isBetterThan(bestGame) {
            bestGame = newRecord
        }
    }
}
