//
//  ViewController.swift
//  Flashcards
//
//  Created by David Ngetich on 10/13/18.
//  Copyright © 2018 David Ngetich. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var backLabel: UILabel!
    
    @IBOutlet weak var frontLabel: UILabel!
    

    @IBOutlet weak var card: UIView!
    
    @IBOutlet weak var btnOptionOne: UIButton!
    
    @IBOutlet weak var btnOptionTwo: UIButton!
    
    @IBOutlet weak var btnOptionThree: UIButton!
    
    
    
    
    
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
    
    func updateFlashcard(question: String, answer: String, extraAnswerOne: String?, extraAnswerTwo: String?){
        frontLabel.text = question
        backLabel.text = answer
        
        btnOptionOne.setTitle(answer, for: .normal)
        btnOptionTwo.setTitle(extraAnswerOne, for: .normal)
        btnOptionThree.setTitle(extraAnswerTwo, for: .normal)
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

