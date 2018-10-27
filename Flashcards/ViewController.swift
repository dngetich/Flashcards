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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
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

    func updateFlashcard(question: String, answer: String){
    
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //destination of the segue is the Navigation View Controller
        let navigationController  = segue.destination as! UINavigationController
        
        //navigation controller only contains a creation view contrller
        let creationController = navigationController.topViewController as! CreationViewController
        
        //set the flashcards view controller property to self
        creationController.flashcardsController = self
    }
    
}

