//
//  WelcomeViewController.swift
//  Air Space
//
//  Created by Roland Tecson on 2021-07-06.
//

import UIKit

class WelcomeViewController: UIViewController {

    // MARK: - IBActions
    @IBAction func easyButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: segueStartGame, sender: nil)
    }

    @IBAction func mediumButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: segueStartGame, sender: nil)
    }

    @IBAction func difficultButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: segueStartGame, sender: nil)
    }

    // MARK: - Private constants
    private let segueStartGame = "segueStartGame"
}

// MARK: - UIViewController methods
extension WelcomeViewController {
 
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //
    }
}
