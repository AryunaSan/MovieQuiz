//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Aryuna on 17.05.2024.
//

import Foundation
protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)    // метод, который должен быть у делегата фабрики — его будет вызывать фабрика, чтобы отдать готовый вопрос квиза.
}

