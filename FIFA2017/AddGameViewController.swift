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
    
    private var gameAddButton: UIButton! //addボタン
    private var p1Picker: UIPickerView! //player1の名前picker
    private var p2Picker: UIPickerView! //player2の名前picker
    private var p1sPicker: UIPickerView! //player1の得点picker
    private var p2sPicker: UIPickerView! //player2の得点picker
    private var p1tPicker: UIPickerView! //player1のチームpicker
    private var p2tPicker: UIPickerView! //player2のチームpicker
    private var pValues: NSArray! = [] //player pickerに表示する値
    private var lValues: NSArray! = [] //league picker に表示する値
    private var tValues: [[String?]] = [] //team pickerに表示する値
    private var sValues: [Int] = [0,1,2,3,4,5,6,7,8,9] //score pickerに表示する値
    private var p1name:String!
    private var p2name:String!
    private var p1score:Int = 0
    private var p2score:Int = 0
    private var p1team:String!
    private var p2team:String!
    private var p1leagueText:UITextField!
    private var p2leagueText:UITextField!
    private var p1leaguePicker:UIPickerView!
    private var p2leaguePicker:UIPickerView!
    private var p1leagueBar:UIToolbar!
    private var p2leagueBar:UIToolbar!
    private var p1leagueIndex: Int = 0
    private var p2leagueIndex: Int = 0
    private var p1teamText:UITextField!
    private var p2teamText:UITextField!
    private var p1teamBar:UIToolbar!
    private var p2teamBar:UIToolbar!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Add Game"
        
        // Viewの背景色をwhiteに設定する.
        self.view.backgroundColor = UIColor.white
        
        //位置座標の設定
        let barHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
        
        //addボタンを作成する
        gameAddButton = UIButton()
        gameAddButton.frame = CGRect(x: (myBoundSize.width-50)/2, y: 450, width: 50, height: 30)
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
        
        // league name picker の値設定
        for league in leagues {
            lValues = lValues.adding(league.name) as NSArray!
        }
        
        var tValues2 : [String] = []
        // team name picker の値設定
        for league in leagues {
            tValues2 = []
            for team in teams {
                if league.name == team.league {
                    tValues2.append(team.name)
                }
            }
            tValues.append(tValues2)
        }
        p1team = tValues[0][0]!
        p2team = tValues[0][0]!
        
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
        
        //league text の生成
        p1leagueText = UITextField()
        p1leagueText.frame = CGRect(x: myBoundSize.width/2-175, y: barHeight+250, width: 150, height: 30)
        p1leagueText.text = "\(leagues[0].name)"
        p1leagueText.textAlignment = NSTextAlignment.center
        p1leagueText.tintColor = UIColor.white
        self.view.addSubview(p1leagueText)
        
        p2leagueText = UITextField()
        p2leagueText.frame = CGRect(x: myBoundSize.width/2+25, y: barHeight+250, width: 150, height: 30)
        p2leagueText.text = "\(leagues[0].name)"
        p2leagueText.textAlignment = NSTextAlignment.center
        p2leagueText.tintColor = UIColor.white
        self.view.addSubview(p2leagueText)
        
        //league toolbarの生成
        p1leagueBar = UIToolbar(frame: CGRect(x:0, y:myBoundSize.height/6, width:myBoundSize.width, height:40.0))
        p1leagueBar.layer.position = CGPoint(x: myBoundSize.width/2, y: myBoundSize.height-20.0)
        p1leagueBar.backgroundColor = UIColor.black
        p1leagueBar.barStyle = UIBarStyle.black
        p1leagueBar.tintColor = UIColor.white
        let p1leagueBarButton = UIBarButtonItem(title: "OK", style:.plain, target: self, action: #selector(onClick(sender:)))
        p1leagueBarButton.tag = 1
        p1leagueBar.items = [p1leagueBarButton]
        
        p2leagueBar = UIToolbar(frame: CGRect(x:0, y:myBoundSize.height/6, width:myBoundSize.width, height:40.0))
        p2leagueBar.layer.position = CGPoint(x: myBoundSize.width/2, y: myBoundSize.height-20.0)
        p2leagueBar.backgroundColor = UIColor.black
        p2leagueBar.barStyle = UIBarStyle.black
        p2leagueBar.tintColor = UIColor.white
        let p2leagueBarButton = UIBarButtonItem(title: "OK", style:.plain, target: self, action: #selector(onClick(sender:)))
        p2leagueBarButton.tag = 2
        p2leagueBar.items = [p2leagueBarButton]

        //league pickerの生成
        p1leaguePicker = UIPickerView()
        p1leaguePicker.delegate = self
        p1leaguePicker.tag = 5
        p1leagueText.inputView = p1leaguePicker
        p1leagueText.inputAccessoryView = p1leagueBar
        
        p2leaguePicker = UIPickerView()
        p2leaguePicker.delegate = self
        p2leaguePicker.tag = 6
        p2leagueText.inputView = p2leaguePicker
        p2leagueText.inputAccessoryView = p2leagueBar

        
        //team text の生成
        p1teamText = UITextField()
        p1teamText.frame = CGRect(x: myBoundSize.width/2-175, y: barHeight+300, width: 150, height: 30)
        p1teamText.text = "\(tValues[0][0]!)"
        p1teamText.textAlignment = NSTextAlignment.center
        p1teamText.tintColor = UIColor.white
        self.view.addSubview(p1teamText)
        
        p2teamText = UITextField()
        p2teamText.frame = CGRect(x: myBoundSize.width/2+25, y: barHeight+300, width: 150, height: 30)
        p2teamText.text = "\(tValues[0][0]!)"
        p2teamText.textAlignment = NSTextAlignment.center
        p2teamText.tintColor = UIColor.white
        self.view.addSubview(p2teamText)
        
        //team toolbarの生成
        p1teamBar = UIToolbar(frame: CGRect(x:0, y:myBoundSize.height/6, width:myBoundSize.width, height:40.0))
        p1teamBar.layer.position = CGPoint(x: myBoundSize.width/2, y: myBoundSize.height-20.0)
        p1teamBar.backgroundColor = UIColor.black
        p1teamBar.barStyle = UIBarStyle.black
        p1teamBar.tintColor = UIColor.white
        let p1teamBarButton = UIBarButtonItem(title: "OK", style:.plain, target: self, action: #selector(onClick(sender:)))
        p1teamBarButton.tag = 3
        p1teamBar.items = [p1teamBarButton]
        
        p2teamBar = UIToolbar(frame: CGRect(x:0, y:myBoundSize.height/6, width:myBoundSize.width, height:40.0))
        p2teamBar.layer.position = CGPoint(x: myBoundSize.width/2, y: myBoundSize.height-20.0)
        p2teamBar.backgroundColor = UIColor.black
        p2teamBar.barStyle = UIBarStyle.black
        p2teamBar.tintColor = UIColor.white
        let p2teamBarButton = UIBarButtonItem(title: "OK", style:.plain, target: self, action: #selector(onClick(sender:)))
        p2teamBarButton.tag = 4
        p2teamBar.items = [p2teamBarButton]

        //league pickerの生成
        p1tPicker = UIPickerView()
        p1tPicker.delegate = self
        p1tPicker.tag = 7
        p1teamText.inputView = p1tPicker
        p1teamText.inputAccessoryView = p1teamBar
        
        p2tPicker = UIPickerView()
        p2tPicker.delegate = self
        p2tPicker.tag = 8
        p2teamText.inputView = p2tPicker
        p2teamText.inputAccessoryView = p2teamBar
        
        //team pickerの生成
        /*p1tPicker = UIPickerView()
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
        self.view.addSubview(p2tPicker)*/

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    //Game Addボタンのイベント.
    internal func onClickAddButton(sender: UIButton) {
        if p1name != p2name {
            let p1 = realmTry.objects(realmPlayer.self).filter("name==%@",p1name).first
            let p2 = realmTry.objects(realmPlayer.self).filter("name==%@",p2name).first
            let game = realmGame()
            game.date = NSDate()
            game.player1 = p1name
            game.player2 = p2name
            game.p1score = p1score
            game.p2score = p2score
            game.p1team = p1team!
            game.p2team = p2team!
            if p1score == p2score {
                game.winner = ""
                game.winnerteam = ""
                game.loser = ""
                game.loserteam = ""
            }else if p1score < p2score {
                game.winner = p2name
                game.winnerteam = p2team
                game.loser = p1name
                game.loserteam = p1team
            }else{
                game.winner = p1name
                game.winnerteam = p1team
                game.loser = p2name
                game.loserteam = p2team
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

    }
    
    //ツールバーの閉じるボタン
    func onClick(sender: UIBarButtonItem) {
        if sender.tag == 1{
            p1leagueText.resignFirstResponder()
        }else if sender.tag == 2{
            p2leagueText.resignFirstResponder()
        }else if sender.tag == 3{
            p1teamText.resignFirstResponder()
        }else if sender.tag == 4{
            p2teamText.resignFirstResponder()
        }
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
            return lValues.count
        }else if pickerView.tag == 7{
            return tValues[p1leagueIndex].count
        }else if pickerView.tag == 8{
            return tValues[p2leagueIndex].count
        }
        return tValues[p2leagueIndex].count
    }
    
    // pickerに表示する値を返すデリゲートメソッド.
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag<=2{
            return pValues[row] as? String
        }else if pickerView.tag<=4 {
            return String(sValues[row])
        }else if pickerView.tag<=6 {
            return lValues[row] as? String
        }else if pickerView.tag == 7{
            return tValues[p1leagueIndex][row]
        }else if pickerView.tag == 8{
            return tValues[p2leagueIndex][row]
        }
        return tValues[p2leagueIndex][row]
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
            p1leagueText.text = lValues[row] as? String
            p1teamText.text = tValues[row][0]
            p1leagueIndex = row
            p1team = tValues[row][0]
        }else if pickerView.tag==6{
            p2leagueText.text = lValues[row] as? String
            p2teamText.text = tValues[row][0]
            p2leagueIndex = row
            p2team = tValues[row][0]
        }else if pickerView.tag==7{
            p1teamText.text = tValues[p1leagueIndex][row]
            p1team = tValues[p1leagueIndex][row]
            print("\(p1team)")
        }else if pickerView.tag==8{
            p2teamText.text = tValues[p2leagueIndex][row]
            p2team = tValues[p2leagueIndex][row]
            print("\(p2team)")
        }
    }
    
}
