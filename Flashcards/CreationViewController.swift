//
//  CreationViewController.swift
//  Flashcards
//
//  Created by David Ngetich on 10/27/18.
//  Copyright © 2018 David Ngetich. All rights reserved.
//

import UIKit

class CreationViewController: UIViewController {
    
    var flashcardsController: ViewController!
    
    @IBOutlet weak var questionTextField: UITextField!
    @IBOutlet weak var answerTextField: UITextField!
    @IBOutlet weak var answer2TextField: UITextField!
    @IBOutlet weak var answer3TextField: UITextField!
    
    
    
    
    var initialQuestion: String?
    var initialAnswer: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        questionTextField.text = initialQuestion
        answerTextField.text = initialAnswer
        
    }
    
    
    @IBAction func didTapOnCancel(_ sender: Any) {
        
        dismiss(animated: true)
    }
    
    @IBAction func didTapOnDone(_ sender: Any) {
        
        //Get the question in the question text field
        let questionText = questionTextField.text
        
        //Get the text in the answer text field
        let answerText = answerTextField.text
        
        //Get the text from the extra answer 1
        let AddedAnswer1 = answer2TextField.text
        
        //get the text from the scond extra answer
        let AddedAnswer2 = answer3TextField.text
        
        //check if empty
        if(questionText == nil || answerText == nil || questionText!.isEmpty || questionText!.isEmpty){
            //show error
            let alert = UIAlertController (title: "Missing text", message: "You should enter both question and answer", preferredStyle: .alert)
            
            present(alert, animated: true)
            
            let OkAction = UIAlertAction(title: "OK", style: .default)
            alert.addAction(OkAction)
        }
        else{
            
            //call the function to update the flashcards
            flashcardsController.updateFlashcard(question: questionText!, answer: answerText!, extraAnswerOne: AddedAnswer1!, extraAnswerTwo: AddedAnswer2!)
            
            //Dismiss
            dismiss(animated: true)
            
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
