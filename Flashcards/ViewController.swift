//
//  ViewController.swift
//  Flashcards
//
//  Created by David Ngetich on 10/13/18.
//  Copyright © 2018 David Ngetich. All rights reserved.
//

import UIKit

struct Flashcard {
    var question: String
    var answer: String
}
class ViewController: UIViewController {

    @IBOutlet weak var backLabel: UILabel!
    
    @IBOutlet weak var frontLabel: UILabel!
    

    @IBOutlet weak var card: UIView!
    
    @IBOutlet weak var btnOptionOne: UIButton!
    
    @IBOutlet weak var btnOptionTwo: UIButton!
    
    @IBOutlet weak var btnOptionThree: UIButton!
    
    @IBOutlet weak var prevButton: UIButton!
    
    @IBOutlet weak var nextButton: UIButton!
    
    
    //declare the flashcards array
    var flashcards = [Flashcard]()
    
    //declare an index variable
    var currentIndex = 0
    
    override func viewDidLoad() {
         super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        
        card.layer.cornerRadius = 20.0
        card.clipsToBounds = true
        card.layer.shadowRadius = 15.0
        card.layer.shadowOpacity = 0.2
        card.clipsToBounds = true
        
        btnOptionOne.layer.cornerRadius = 20.0
        btnOptionOne.layer.borderWidth = 3.0
        btnOptionOne.layer.borderColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        
        btnOptionTwo.layer.cornerRadius = 20.0
        btnOptionTwo.layer.borderWidth = 3.0
        btnOptionTwo.layer.borderColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        
        btnOptionThree.layer.cornerRadius = 20.0
        btnOptionThree.layer.borderWidth = 3.0
        btnOptionThree.layer.borderColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        
        //read saved flashcards
        readSavedFlashcards()
        
        //Adding the initial flashcard if needed
        if(flashcards.count == 0){
            updateFlashcard(question: "What's the capitol of Kenya", answer: "Nairobi")
        }else {
            updateLabels()
            updatePrevNextButtons()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func didTapOnFlashcard(_ sender: Any) {
        
        if(frontLabel.isHidden)
        {
            frontLabel.isHidden = false
        }
        else
        {
            frontLabel.isHidden = true
        }
    }
    
    @IBAction func didTapOptionOne(_ sender: Any) {
        btnOptionOne.isHidden = true
    }
    
    @IBAction func didTapOptionTwo(_ sender: Any) {
        frontLabel.isHidden = true
    }
    
    @IBAction func didTapOptionThree(_ sender: Any) {
        btnOptionThree.isHidden = true
    }
    
    func updatePrevNextButtons(){
        //disable nextButton if at the end
        if(currentIndex == flashcards.count - 1){
            nextButton.isEnabled = false
        }else {
            nextButton.isEnabled = true
        }
        
        //Disbale prev button if at the beginning
        if(currentIndex == 0){
            prevButton.isEnabled = false
        }else {
            prevButton.isEnabled = true
        }
    }
    

    
    @IBAction func didTapOnPrev(_ sender: Any) {
        //upfdate current index
        currentIndex = currentIndex - 1
        
        //update the flashcards label
        updateLabels()
        
        //update the prev and Next Buttons
        updatePrevNextButtons()
    }
    
    @IBAction func didTapOnNext(_ sender: Any) {
        //update current index
        currentIndex = currentIndex + 1
        
        //update the labels
        updateLabels()
        
        //update the prev and next buttons
        updatePrevNextButtons()
        
    }
    
    
//    func updateFlashcard(question: String?, answer: String?, extraAnswerOne: String?, extraAnswerTwo: String?){
//        frontLabel.text = question
//        backLabel.text = answer
//
//        btnOptionOne.setTitle(extraAnswerOne, for: .normal)
//        btnOptionTwo.setTitle(answer, for: .normal)
//        btnOptionThree.setTitle(extraAnswerTwo, for: .normal)
//    }
    
    func updateLabels() {
        //get the current flashcard
        let currentFlashcard = flashcards[currentIndex]
        
        //update the labels
        frontLabel.text = currentFlashcard.question
        backLabel.text = currentFlashcard.answer
        
    }
    
    
    func updateFlashcard(question: String, answer: String){
        let flashcard = Flashcard.init(question: question, answer: answer)
        
        
        //add the flashcard to the array
        flashcards.append(flashcard)
        
        //update current index in the array
        currentIndex = flashcards.count - 1
        
        print("Added new flashcard ")
        print("We now have \(flashcards.count) flashcards")
        print("The current index in array is \(currentIndex)")
        
        //update the prev and Next Buttons
        updatePrevNextButtons()
        
        //update the labels
        updateLabels()
        
        //save all the flashcards to the disk
        saveAllFlashcardsToDisk()
    }
    
    func saveAllFlashcardsToDisk(){
        
        //from flashcard array to dictionary array
        let dictionaryArray = flashcards.map { (card) -> [String: String] in
            return ["question": card.question, "answer": card.answer]
        }
        
        //save array on disk using user defaults
        UserDefaults.standard.set(dictionaryArray, forKey: "flashcards")
        
        //Print loaded
        print("Congrats the flashcard shave been loaded to disk")
    }
    
    func readSavedFlashcards(){
        //read dictionary array if any exists
        if let dictionaryArray = UserDefaults.standard.array(forKey: "flashcards") as? [[String: String]] {
            let savedCards = dictionaryArray.map { dictionary -> Flashcard in
                return Flashcard(question: dictionary["question"]!, answer: dictionary["answer"]!)
            }
            //put all the flashcards in the array
            flashcards.append(contentsOf: savedCards)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //destination of the segue is the Navigation View Controller
        let navigationController  = segue.destination as! UINavigationController
        
        //navigation controller only contains a Creation View Contrller
        let creationController = navigationController.topViewController as! CreationViewController
        
        //set the flashcards view controller property to self
        creationController.flashcardsController = self
    
        if segue.identifier == "EditSegue" {
        creationController.initialQuestion = frontLabel.text
        creationController.initialAnswer = backLabel.text
        }
    
    }
 
}

