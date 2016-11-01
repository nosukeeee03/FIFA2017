//
//  AddLeagueViewController.swift
//  FIFA2017
//
//  Created by 水谷　慎之介 on 2016/10/20.
//  Copyright © 2016年 水谷　慎之介. All rights reserved.
//

//
//  AddTeamViewController.swift
//  FIFA2017
//
//  Created by 水谷　慎之介 on 2016/10/09.
//  Copyright © 2016年 水谷　慎之介. All rights reserved.
//

import UIKit
import RealmSwift

class AddLeagueViewController: UIViewController, UITextFieldDelegate{
    private var teamTextField: UITextField!
    private var teamAddButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Add League"
        
        // Viewの背景色をwhiteに設定する.
        self.view.backgroundColor = UIColor.white
        
        //位置座標の設定
        let barHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
        
        // UITextFieldの作成
        teamTextField = UITextField(frame: CGRect(x: myBoundSize.width/2-100, y: barHeight+70, width: 200, height: 30))
        teamTextField.text = ""
        teamTextField.placeholder = "League name"
        teamTextField.delegate = self
        teamTextField.borderStyle = .roundedRect
        teamTextField.clearButtonMode = .whileEditing
        self.view.addSubview(teamTextField)
        
        
        //addボタンを作成する
        teamAddButton = UIButton()
        teamAddButton.frame = CGRect(x: (myBoundSize.width-50)/2, y: barHeight+150, width: 50, height: 30)
        teamAddButton.setTitle("Add", for: .normal)
        teamAddButton.setTitleColor(UIColor.blue, for: .normal)
        teamAddButton.setTitleColor(UIColor.black, for: .highlighted)
        teamAddButton.tag = 1
        teamAddButton.addTarget(self, action: #selector(AddTeamViewController.onClickAddButton(sender:)), for: .touchUpInside)
        self.view.addSubview(teamAddButton)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //テキストの改行が押されたとき
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        
        // キーボードを閉じる
        textField.resignFirstResponder()
        
        return true
    }
    
    //Team Addボタンのイベント.
    internal func onClickAddButton(sender: UIButton) {
        let league = realmLeague()
        league.name = teamTextField.text!
        try! realmTry.write {
            realmTry.add(league)
        }
        self.navigationController?.popViewController(animated: true)
    }
}
