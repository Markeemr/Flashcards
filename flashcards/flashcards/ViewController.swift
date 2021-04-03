//
//  ViewController.swift
//  flashcards
//

//

import UIKit


struct Flashcard {
    
    var question: String
    var answer: String
}

class ViewController: UIViewController {

    @IBOutlet weak var frontLabel: UILabel!
    
    @IBOutlet weak var backLabel: UILabel!
    
    
    // Array to hold our flashacards
    var flashcards = [Flashcard]()
    
    
    // Current flashcard index
    var currentIndex = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Read saved flashcards
        readSavedFlashcards()
        
        
        // Adding our initial flashcard if needed
        if flashcards.count == 0 {
            
            updateFlashcard(question: "Where was the birth of Hip-Hop?", answer: "The Bronx, NY")
            
        }
        
        else {
            updateLabels()
            updateNextPrevButtons()
            
            
        }
    }

    

    @IBAction func didTapOnFlashcard(_ sender: Any) {
        
        flipFlashcard()
    }
    
    func flipFlashcard() {
        
        frontLabel.isHidden = true
        
        
        UIView.transition(with: card, duration: 0.3, options: .transitionFlipFromRight, animations: {self.frontLabel.isHidden = true })
    }
    
    
    func updateFlashcard(question: String, answer: String) {
        
        let flashcard = Flashcard(question: question, answer: answer)
        frontLabel.text = flashcard.question
        backLabel.text = flashcard.answer
        
        flashcards.append(flashcard)
        
        // Logging to the console
        print("<3 Added new flashcard")
        print("<3 We now have \(flashcards.count) flashcards")
        
        currentIndex = flashcards.count - 1
        print("<3 Our current index is \(currentIndex)")
        
        // Update buttons
        updateNextPrevButtons()
        
        
        // Update labels
        updateLabels()
    }
    
    
    func updateLabels() {
        
        
        // get current flashcard
        
        let currentFlashcard = flashcards[currentIndex]
        
        // Update labels
        frontLabel.text = currentFlashcard.question
        backLabel.text = currentFlashcard.answer
    }
    

    @IBAction func didTapOnePrev(_ sender: Any) {
        
        currentIndex = currentIndex - 1
        
        // Update Labels
        updateLabels()
        
        // Update buttons
        updateNextPrevButtons()
        
        animateCardIn()
        
        
    }
    
    @IBOutlet weak var prevButton: UIButton!
    
    @IBOutlet weak var card: UIView!
    
    
    
    @IBAction func didTapOneNext(_ sender: Any) {
        
        
        //Increase current index
        currentIndex = currentIndex + 1
        
        // Update Labels
        updateLabels()
        
        // Update buttons
        updateNextPrevButtons()
        
        animateCardOut()
    }
    
    
    @IBOutlet weak var nextButton: UIButton!
    
    
    func updateNextPrevButtons() {
        
        // Disable next button if at the end
        if currentIndex == flashcards.count - 1 {
            
            nextButton.isEnabled = false
        }
        
        else {
            nextButton.isEnabled = true
        }
        
        // Disable prev button if at the beginning
        if currentIndex == 0 {
            
            prevButton.isEnabled = false
        }
   
        else {
            prevButton.isEnabled = true
        }
    }
    
    
    func saveAllFlashcardsToDisk() {
        
        // From flashcard array to dictionary array
        let dictionaryArray = flashcards.map { (card) -> [String:String] in return ["question": card.question, "answer": card.answer]
        }
        
        // Save array on disk using UserDefaults
        UserDefaults.standard.set(flashcards, forKey: "flashcards")
        
        // Log it
        print("!!! FLashcards saved to UserDefaults")
        
    }
    
    
    func readSavedFlashcards() {
        
        if let dictionaryArray = UserDefaults.standard.array(forKey: "flashcards") as? [[String: String]] {
            
            // In here we know for sure we have a dictionary array
            let savedCards = dictionaryArray.map { dictionary -> Flashcard in return Flashcard(question: dictionary["question"]!, answer: dictionary["answer"]!)
            
        }
        
            // Put all the cards in our flashcards array
        flashcards.append(contentsOf: savedCards)
        
      
    }
        
    }
    
    func animateCardOut() {
        
        UIView.animate(withDuration: 0.3, animations: { self.card.transform = CGAffineTransform.identity.translatedBy(x: -300.0, y: 0.0) }, completion: { finished in
        
        self.updateLabels()
        
        self.animateCardIn()
    
    })
    }
    
    func animateCardIn() {
        
        card.transform = CGAffineTransform.identity.translatedBy(x: 300.0, y: 0.0)
        
        UIView.animate(withDuration: 0.3) {
            self.card.transform = CGAffineTransform.identity
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let navigationController = segue.destination as! UINavigationController
        
        let creationController = navigationController.topViewController as! CreationViewController
        
        creationController.flashcardsController = self
    }
    
}


