import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var textLabel: UILabel!
    
    private var currentQuestionIndex = 0
    private var correctAnswers = 0
    private let questionsAmount: Int = 10
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    
    private var alertPresenter: AlertPresenterProtocol?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    // MARK: - Lifestyle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //let firstQuestion = questions[currentQuestionIndex]
        
        let questionFactory = QuestionFactory()
        questionFactory.delegate = self
        self.questionFactory = questionFactory
        /*
         if let firstQuestion = questionFactory.requestNextQuestion() {
         currentQuestion = firstQuestion
         let viewModel = convert(model: firstQuestion)
         show(quiz: viewModel)
         */
        questionFactory.requestNextQuestion()
        
        alertPresenter = AlertPresenter(viewController: self)
    }
    // MARK: - QuestionFactoryDelegate
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        // проверка, что вопрос не nil
        guard let question = question else {
            return
        }
        
        currentQuestion = question
        let viewModel = convert(model: question)
        //show(quiz: viewModel)
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        }
    }
    
    // MARK: - Actions
    
    @IBAction private func noButton(_ sender: UIButton) {
        // let currentQuestion = questions[currentQuestionIndex]
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = false
        
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    @IBAction private func yesButton(_ sender: UIButton) {
        // let currentQuestion = questions[currentQuestionIndex]
        guard let currentQuestion = currentQuestion else {
            return
        }
        
        let givenAnswer = true
        
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    // MARK: - Private functions
    
    // приватный метод конвертации, который принимает моковый вопрос и возвращает вью модель для главного экрана
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        let questionStep = QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
        return questionStep
    }
    
    
    // приватный метод вывода на экран вопроса, который принимает на вход вью модель вопроса и ничего не возвращает
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
        imageView.layer.borderColor = UIColor.clear.cgColor
    }
    
    // приватный метод, который меняет цвет рамки
    // принимает на вход булевое значение и ничего не возвращает
    private func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
            correctAnswers += 1
        }
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        
        // запускаем задачу через 1 секунду c помощью диспетчера задач
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            // код, который мы хотим вызвать через 1 секунду
            self.showNextQuestionOrResults()
        }
        
    }
    // приватный метод, который содержит логику перехода в один из сценариев
    // метод ничего не принимает и ничего не возвращает
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questionsAmount - 1 {
            let text = "Ваш результат: \(correctAnswers)/10"
            let viewModel = QuizResultsViewModel(
                title: "Этот раунд окончен!",
                text: text,
                buttonText: "Сыграть ещё раз")
            show(quiz: viewModel)
        } else {
            currentQuestionIndex += 1
            //let nextQuestion = questions[currentQuestionIndex]
            /*
             if let nextQuestion = questionFactory.requestNextQuestion() {
             currentQuestion = nextQuestion
             let viewModel = convert(model: nextQuestion)
             
             show(quiz: viewModel)
             }
             */
            questionFactory?.requestNextQuestion()
        }
    }
    // константа с кнопкой для системного алерта
    let alert = UIAlertController(
        title: "Этот раунд окончен!",
        message: "Ваш результат ???",
        preferredStyle: .alert)
    
    // приватный метод для показа результатов раунда квиза
    // принимает вью модель QuizResultsViewModel и ничего не возвращает
    private func show(quiz result: QuizResultsViewModel) {
        let alertModel = AlertModel(
            title: result.title,
            message: result.text,
            buttonText: result.buttonText,
            completion: { [weak self] in
                guard let self = self else { return }
                self.currentQuestionIndex = 0
                self.correctAnswers = 0
                self.questionFactory?.requestNextQuestion()
            }
        )
        alertPresenter?.showAlert(alert: alertModel)
            }
        //            let alert = UIAlertController(
        //                title: result.title,
        //                message: result.text,
        //                preferredStyle: .alert)
        //
        //            let action = UIAlertAction(title: result.buttonText, style: .default) { [weak self] _ in // слабая ссылка на self
        //                guard let self = self else { return } // разворачиваем слабую ссылку
        //
        //                self.currentQuestionIndex = 0
        //                self.correctAnswers = 0
        //
        //               // let firstQuestion = self.questions[self.currentQuestionIndex]
        //        /*
        //                if let firstQuestion = self.questionFactory.requestNextQuestion() {
        //                    self.currentQuestion = firstQuestion
        //                    let viewModel = self.convert(model: firstQuestion)
        //
        //                    self.show(quiz: viewModel)
        //         */
        //                self.questionFactory?.requestNextQuestion()
        //
        //            }
        //
        //            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in // слабая ссылка на self
        //                guard let self = self else { return } // разворачиваем слабую ссылку
        //                self.showNextQuestionOrResults()
        //            }
        //
        //        alert.addAction(action)
        //
        //        self.present(alert, animated: true, completion: nil)
        //
        //
        //    }
    }

