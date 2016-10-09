//
//  AddGameViewController.swift
//  FIFA2017
//
//  Created by 水谷　慎之介 on 2016/10/06.
//  Copyright © 2016年 水谷　慎之介. All rights reserved.
//

import UIKit
import RealmSwift

class AddGameViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{
    
    private var gameAddButton: UIButton!
    private var p1Picker: UIPickerView!
    private var p2Picker: UIPickerView!
    private var p1sPicker: UIPickerView!
    private var p2sPicker: UIPickerView!
    private var p1tPicker: UIPickerView!
    private var p2tPicker: UIPickerView!
    private var pValues: NSArray! = []
    private var tValues: NSArray! = []
    private var sValues: [Int] = [0,1,2,3,4,5,6,7,8,9,10]
    private var p1name:String!
    private var p2name:String!
    private var p1score:Int = 0
    private var p2score:Int = 0
    private var p1team:String!
    private var p2team:String!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Add Game"
        let teamAddButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(AddGameViewController.onClickTeamAddButton(sender:)))
        self.navigationItem.setRightBarButton(teamAddButton, animated: true)

        // Viewの背景色をwhiteに設定する.
        self.view.backgroundColor = UIColor.white
        
        //位置座標の設定
        let barHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
        
        //addボタンを作成する
        gameAddButton = UIButton()
        gameAddButton.frame = CGRect(x: (myBoundSize.width-50)/2, y: 500, width: 50, height: 30)
        gameAddButton.setTitle("Add", for: .normal)
        gameAddButton.setTitleColor(UIColor.blue, for: .normal)
        gameAddButton.setTitleColor(UIColor.black, for: .highlighted)
        gameAddButton.tag = 1
        gameAddButton.addTarget(self, action: #selector(AddPlayerViewController.onClickAddButton(sender:)), for: .touchUpInside)
        self.view.addSubview(gameAddButton)
        
        // player name picker の値設定
        for player in players {
            pValues = pValues.adding(player.name) as NSArray!
        }
        p1name = String(describing: pValues[0])
        p2name = String(describing: pValues[0])
        
        // team name picker の値設定
        for team in teams {
            tValues = tValues.adding(team.name) as NSArray!
        }
        p1team = String(describing: tValues[0])
        p2team = String(describing: tValues[0])
        
        // player name pickerの生成
        p1Picker = UIPickerView()
        p2Picker = UIPickerView()
        p1Picker.frame = CGRect(x: myBoundSize.width/2-125, y: barHeight+50, width: 100, height: 100)
        p2Picker.frame = CGRect(x: myBoundSize.width/2+25, y: barHeight+50, width: 100, height: 100)
        p1Picker.delegate = self
        p2Picker.delegate = self
        p1Picker.dataSource = self
        p2Picker.dataSource = self
        p1Picker.tag = 1
        p2Picker.tag = 2
        self.view.addSubview(p1Picker)
        self.view.addSubview(p2Picker)
        
        // score pickerの生成
        p1sPicker = UIPickerView()
        p2sPicker = UIPickerView()
        p1sPicker.frame = CGRect(x: myBoundSize.width/2-125, y: barHeight+150, width: 100, height: 100)
        p2sPicker.frame = CGRect(x: myBoundSize.width/2+25, y: barHeight+150, width: 100, height: 100)
        p1sPicker.delegate = self
        p2sPicker.delegate = self
        p1sPicker.dataSource = self
        p2sPicker.dataSource = self
        p1sPicker.tag = 3
        p2sPicker.tag = 4
        self.view.addSubview(p1sPicker)
        self.view.addSubview(p2sPicker)
        
        //team pickerの生成
        p1tPicker = UIPickerView()
        p2tPicker = UIPickerView()
        p1tPicker.frame = CGRect(x: myBoundSize.width/2-175, y: barHeight+250, width: 150, height: 100)
        p2tPicker.frame = CGRect(x: myBoundSize.width/2+25, y: barHeight+250, width: 150, height: 100)
        p1tPicker.delegate = self
        p2tPicker.delegate = self
        p1tPicker.dataSource = self
        p2tPicker.dataSource = self
        p1tPicker.tag = 5
        p2tPicker.tag = 6
        self.view.addSubview(p1tPicker)
        self.view.addSubview(p2tPicker)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    //Game Addボタンのイベント.
    internal func onClickAddButton(sender: UIButton) {
        let p1 = realmTry.objects(realmPlayer).filter("name==%@",p1name).first
        let p2 = realmTry.objects(realmPlayer).filter("name==%@",p2name).first
        let game = realmGame()
        game.date = NSDate()
        game.player1 = p1name
        game.player2 = p2name
        game.p1score = p1score
        game.p2score = p2score
        game.p1team = p1team
        game.p2team = p2team
        if p1score == p2score {
            game.winner = ""
        }else if p1score < p2score {
            game.winner = p2name
        }else{
            game.winner = p1name
        }

        try! realmTry.write {
           if p1score == p2score {
                p1!.draw += 1
                p2!.draw += 1
            }else if p1score < p2score {
                p1!.lose += 1
                p2!.win += 1
            }else{
                p1!.win += 1
                p2!.lose += 1
            }

            p1!.goals += p1score
            p1!.goalag += p2score
            p2!.goals += p2score
            p2!.goalag += p1score
            realmTry.add(game)
            games = realmTry.objects(realmGame.self).sorted(byProperty: "date", ascending: false)
            gameTableView.reloadData()
            playerTableView.reloadData()
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    
    internal func onClickTeamAddButton(sender: UIButton) {
        // 遷移するViewを定義する.
        let mySecondViewController: UIViewController = AddTeamViewController()
        self.navigationController?.pushViewController(mySecondViewController, animated: true)
    }
    // pickerの表示数
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
     // pickerに表示する行数を返すデータソースメソッド (実装必須)
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag<=2 {
            return pValues.count
        }else if pickerView.tag<=4 {
            return sValues.count
        }else if pickerView.tag<=6 {
            return tValues.count
        }
        return pValues.count
    }
    
    // pickerに表示する値を返すデリゲートメソッド.
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag<=2{
            return pValues[row] as? String
        }else if pickerView.tag<=4 {
            return String(sValues[row])
        }else if pickerView.tag<=6 {
            return tValues[row] as? String
        }
        return pValues[row] as? String
    }
    

    // pickerが選択された際に呼ばれるデリゲートメソッド.
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag==1{
            p1name = String(describing: pValues[row])
        }else if pickerView.tag==2{
            p2name = String(describing: pValues[row])
        }else if pickerView.tag==3{
            p1score = Int(sValues[row])
        }else if pickerView.tag==4{
            p2score = Int(sValues[row])
        }else if pickerView.tag==5{
            p1team = String(describing: tValues[row])
        }else if pickerView.tag==6{
            p2team = String(describing: tValues[row])
        }
    }
    
}
