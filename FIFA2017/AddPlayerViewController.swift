//
//  AddPlayerViewController.swift
//  FIFA2017
//
//  Created by 水谷　慎之介 on 2016/10/05.
//  Copyright © 2016年 水谷　慎之介. All rights reserved.
//

import UIKit
import RealmSwift

class AddPlayerViewController: UIViewController, UITextFieldDelegate{
    
    private var playerTextField: UITextField!
    private var playerAddButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Add Player"
        
        // Viewの背景色をwhiteに設定する.
        self.view.backgroundColor = UIColor.white
        
        //位置座標の設定
        let textPosX: CGFloat = (self.view.bounds.width - 200)/2 //中央-100
        let buttonPosX: CGFloat = (self.view.bounds.width - 50)/2 //中央-100
        
        // UITextFieldの作成
        playerTextField = UITextField(frame: CGRect(x: textPosX, y: 100, width: 200, height: 30))
        playerTextField.text = ""
        playerTextField.placeholder = "Player name"
        playerTextField.delegate = self
        playerTextField.borderStyle = .roundedRect
        playerTextField.clearButtonMode = .whileEditing
        self.view.addSubview(playerTextField)
        
        //addボタンを作成する
        playerAddButton = UIButton()
        playerAddButton.frame = CGRect(x: buttonPosX, y: 200, width: 50, height: 30)
        playerAddButton.setTitle("Add", for: .normal)
        playerAddButton.setTitleColor(UIColor.blue, for: .normal)
        playerAddButton.setTitleColor(UIColor.black, for: .highlighted)
        playerAddButton.tag = 1
        playerAddButton.addTarget(self, action: #selector(AddPlayerViewController.onClickAddButton(sender:)), for: .touchUpInside)
        self.view.addSubview(playerAddButton)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //Player Addボタンのイベント.
    internal func onClickAddButton(sender: UIButton) {
        try! realmTry.write {
            let player = realmPlayer()
            player.name = playerTextField.text!
            realmTry.add(player)
            playerTableView.reloadData()
        }
        self.navigationController?.popViewController(animated: true)
    }

}


