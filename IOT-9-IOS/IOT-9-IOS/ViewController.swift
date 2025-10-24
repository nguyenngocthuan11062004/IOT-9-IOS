//
//  ViewController.swift
//  IOT-9
//
//  Created by Thuận Nguyễn on 17/10/25.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var btFacebook: LoginTypeView!
    @IBOutlet weak var btApple: LoginTypeView!
    @IBOutlet weak var btnGoogle: LoginTypeView!
    @IBOutlet weak var btSignIn: UIButton!
    @IBOutlet weak var tfLogin: UIView!
    
    @IBOutlet weak var viewBtSignIn: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tfLogin.roundCorners(corners: [.topLeft,.topRight,.bottomLeft,.bottomRight], radius: 16)
        viewBtSignIn.layer.cornerRadius = viewBtSignIn.frame.height/2
        viewBtSignIn.clipsToBounds = true
        btFacebook.setIcon(UIImage(named: "ic_facebook") )
        btnGoogle.setIcon(UIImage(named: "ic_google"))
        btApple.setIcon(UIImage(named: "ic_apple"))
    }
}

