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
    var answer2: String
    var answer3: String
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
    
    var correctAnswerButton: UIButton!
    
    //declare the flashcards array
    var flashcards = [Flashcard]()
    
    //declare an index variable
    var currentIndex = 0
    
    override func viewDidLoad() {
         super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        
        card.layer.cornerRadius = 20.0
        card.layer.shadowRadius = 15.0
        card.layer.shadowOpacity = 1.0
        
        backLabel.layer.cornerRadius = 20.0
        frontLabel.layer.cornerRadius = 20.0
        backLabel.clipsToBounds = true
        frontLabel.clipsToBounds = true
        
        btnOptionOne.layer.cornerRadius = 20.0
        btnOptionOne.layer.borderWidth = 3.0
        btnOptionOne.layer.borderColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        
        btnOptionTwo.layer.cornerRadius = 20.0
        btnOptionTwo.layer.borderWidth = 3.0
        btnOptionTwo.layer.borderColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        
        btnOptionThree.layer.cornerRadius = 20.0
        btnOptionThree.layer.borderWidth = 3.0
        btnOptionThree.layer.borderColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        
        btnOptionOne.isHidden = false
        btnOptionTwo.isHidden = false
        btnOptionThree.isHidden = false
        
        
        //read saved flashcards
        readSavedFlashcards()
        
        //Adding the initial flashcard if needed
        if(flashcards.count == 0){
            updateFlashcard(question: "What's the capitol of Kenya", answer: "Nairobi",answer2: "Kisumu", answer3: "Mombasa", isExisting: false)
        }else {
            updateLabels()
            updatePrevNextButtons()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //wanna start with the flashcard very small and slightly increament the size
        card.alpha = 0.0
        card.transform = CGAffineTransform.identity.scaledBy(x: 0.75, y: 0.75)
        
        //Now we do the animation
        UIView.animate(withDuration: 0.6, delay: 0.5, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [], animations: {
            self.card.alpha = 1.0
            self.card.transform = CGAffineTransform.identity
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func didTapOnDelete(_ sender: Any) {
        //Confirm before deleting
        let alert = UIAlertController(title: "Delete", message: "Are you sure you want to delete the flashcard?", preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (action) in self.deleteCurrentFlashcard()
        }
        alert.addAction(deleteAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(cancelAction)
        
        present(alert, animated:true)
        
    }
    
    //Deletes the current flashcard
    func deleteCurrentFlashcard() {
        //delete Current flashcard
        flashcards.remove(at: currentIndex)
        
        //special case: remove last card
        if currentIndex > flashcards.count - 1 {
            currentIndex = flashcards.count - 1
        }
        
        //update buttons and labels and save to disk
        updatePrevNextButtons()
        updateLabels()
        saveAllFlashcardsToDisk()
    }
    
    @IBAction func didTapOnFlashcard(_ sender: Any) {
        flipFlashcard()
    }
    
    func flipFlashcard(){
        if(frontLabel.isHidden)
        {
            frontLabel.isHidden = false
        }
        else
        {
            frontLabel.isHidden = true
            UIView.transition(with: card, duration: 0.3, options: .transitionFlipFromRight, animations: {
                self.frontLabel.isHidden = true
            })
        }
    }
    
    func animateCardOut(){
        UIView.animate(withDuration: 0.3, animations: {
            self.card.transform = CGAffineTransform.identity.translatedBy(x: -300.0, y: 0.0)
        }, completion: {finished in
            
            //update the labels
            self.updateLabels()
            
            //run other animation
            self.animateCardIn()
        })
    }
    func animateCardIn(){
        
        //start on the right side without animating this
        card.transform = CGAffineTransform.identity.translatedBy(x: 300.0, y: 0.0)
        
        //animate card going back to it's original position
        UIView.animate(withDuration: 0.3) {
            self.card.transform = CGAffineTransform.identity
        }
    }
    
    
    func animateCardOutPrev(){
        UIView.animate(withDuration: 0.3, animations: {
            self.card.transform = CGAffineTransform.identity.translatedBy(x: 300.0, y: 0.0)
        }, completion: {finished in
            
            //update the labels
            self.updateLabels()
            
            //run other animation
            self.animateCardInPrev()
        })
    }
    func animateCardInPrev(){
        
        //start on the right side without animating this
        card.transform = CGAffineTransform.identity.translatedBy(x: -300.0, y: 0.0)
        
        //animate card going back to it's original position
        UIView.animate(withDuration: 0.3) {
            self.card.transform = CGAffineTransform.identity
        }
    }
    
    func updateLabels() {
        //get the current flashcard
        let currentFlashcard = flashcards[currentIndex]
        
        
        //update the labels
        frontLabel.text = currentFlashcard.question
        backLabel.text = currentFlashcard.answer
        
        //update Buttons
        let buttons = [btnOptionOne, btnOptionTwo, btnOptionThree].shuffled()
        let answers = [currentFlashcard.answer, currentFlashcard.answer2, currentFlashcard.answer3].shuffled()
        
        for (button, answer) in zip(buttons, answers){
            
            //set the title for this random button, with random answer
            button?.setTitle(answer, for: .normal)
            
            //check for the right answer
            if(answer == currentFlashcard.answer){
                correctAnswerButton = button
            }
            
        }
        //check to see if the card doesn't have all the multiple choice and hide buttons
//        if currentFlashcard.answer2.isEmpty || currentFlashcard.answer3.isEmpty {
//            btnOptionOne.isHidden = true
//            btnOptionThree.isHidden = true
//            btnOptionTwo.isHidden = true
//        }
//
        //Enable the buttons on
        btnOptionOne.isEnabled = true
        btnOptionTwo.isEnabled = true
        btnOptionThree.isEnabled = true
        
    }
    

    @IBAction func didTapOptionOne(_ sender: Any) {
        
        //check if the button is the correct one
        if  btnOptionOne == correctAnswerButton{
            flipFlashcard()
        }else {
            frontLabel.isHidden = false
            btnOptionOne.isEnabled = false
        }
    }
    
    @IBAction func didTapOptionTwo(_ sender: Any) {
        
        //check if this is the correct answer button
        if btnOptionTwo == correctAnswerButton{
            flipFlashcard()
        }else{
            frontLabel.isHidden = false
            btnOptionTwo.isEnabled = false
        }
    }
    
    @IBAction func didTapOptionThree(_ sender: Any) {
        
        //check if this is the correct answer button
        if btnOptionThree == correctAnswerButton{
            flipFlashcard()
        }else{
            frontLabel.isHidden = false
            btnOptionThree.isEnabled = false
        }
    }
    
    
    func updatePrevNextButtons(){
        //disable nextButton if at the end
        if(currentIndex == flashcards.count - 1){
            nextButton.isEnabled = false
        }else {
            nextButton.isEnabled = true
            frontLabel.isHidden = false
        }
        
        //Disbale prev button if at the beginning
        if(currentIndex == 0){
            prevButton.isEnabled = false
        }else {
            prevButton.isEnabled = true
            frontLabel.isHidden = false
        }
    }
    

    
    @IBAction func didTapOnPrev(_ sender: Any) {
        //upfdate current index
        currentIndex = currentIndex - 1
        
        //update the flashcards label
        updateLabels()
        
        //update the prev and Next Buttons
        updatePrevNextButtons()
        
        //animate card in
        animateCardOutPrev()
    }
    
    @IBAction func didTapOnNext(_ sender: Any) {
        //update current index
        currentIndex = currentIndex + 1
        
        //update the prev and next buttons
        updatePrevNextButtons()
        
        //call he animatecardOut func
        animateCardOut()
        
    }
    
    func updateFlashcard(question: String, answer: String, answer2: String, answer3: String, isExisting: Bool){
        let flashcard = Flashcard.init(question: question, answer: answer, answer2: answer2, answer3: answer3)
        
        if isExisting {
        
            //replace the existing card
            flashcards[currentIndex] = flashcard
//            if flashcard.answer2.isEmpty || flashcard.answer3.isEmpty {
//                btnOptionOne.isHidden = true
//                btnOptionThree.isHidden = true
//                btnOptionTwo.isHidden = true
//            }
        }
        else {
            
            //Update the multiple choice buttons
            btnOptionOne.setTitle(answer2, for: .normal)
            btnOptionTwo.setTitle(answer, for: .normal)
            btnOptionThree.setTitle(answer3, for: .normal)
            
            //add the flashcard to the array
            flashcards.append(flashcard)
            
            //update current index in the array
            currentIndex = flashcards.count - 1
            
            print("Added new flashcard ")
            print("We now have \(flashcards.count) flashcards")
            print("The current index in array is \(currentIndex)")
            
            //update the prev and Next Buttons
            updatePrevNextButtons()
            
//            if flashcard.answer2.isEmpty || flashcard.answer3.isEmpty {
//                btnOptionOne.isHidden = true
//                btnOptionThree.isHidden = true
//                btnOptionTwo.isHidden = true
//            }
            
            //update the labels
            updateLabels()
            
       
            
            //save all the flashcards to the disk
            saveAllFlashcardsToDisk()
        }
    }
    
    func saveAllFlashcardsToDisk(){
        
        //from flashcard array to dictionary array
        let dictionaryArray = flashcards.map { (card) -> [String: String] in
            return ["question": card.question, "answer": card.answer, "answer2": card.answer2, "answer3": card.answer3]
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
                return Flashcard(question: dictionary["question"] ?? "What's the capitol of Kenya", answer: dictionary["answer"] ?? "Nairobi", answer2: (dictionary["answer2"] ?? "Kisumu"), answer3: (dictionary["answer3"] ?? "Mombasa"))
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
//            if creationController.initialAnswer2 == nil || creationController.initialAnswer3 == nil{
//                btnOptionOne.isHidden = true
//                btnOptionThree.isHidden = true
//                btnOptionTwo.isHidden = true
//            }
        }
    
    }
 
}

