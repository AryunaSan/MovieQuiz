//
//  GameResult.swift
//  MovieQuiz
//
//  Created by Aryuna on 17.05.2024.
//

import Foundation
struct GameResult: Codable {
    let correct: Int
    let total: Int
    let date: Date
    
    // метод сравнения по количеству верных ответов
        func isBetterThan(_ another: GameResult) -> Bool {
            correct > another.correct
        }
}
