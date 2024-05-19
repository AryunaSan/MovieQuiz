//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Aryuna on 17.05.2024.
//

import Foundation
protocol StatisticService {
    var gamesCount: Int { get }
    var bestGame: GameResult { get }
    var totalAccuracy: Double { get }
//метод для сохранения текущего результата игры
    func store(correct count: Int, total amount: Int)
}

