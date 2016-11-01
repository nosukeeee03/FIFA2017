//
//  EachPlayerViewController.swift
//  FIFA2017
//
//  Created by 水谷　慎之介 on 2016/10/20.
//  Copyright © 2016年 水谷　慎之介. All rights reserved.
//

import UIKit
import RealmSwift

class EachPlayerViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    private var teamPicker: UIPickerView!
    private var vsPicker: UIPickerView!
    private var teamValues: NSArray! = ["Any"]
    private var vsValues: NSArray! = ["Any"]
    private var teamLabel: UILabel!
    private var vsLabel: UILabel!
    private var wldLabel: UILabel!
    private var goalLabel: UILabel!
    private var teamIndex: Int = 0
    private var vsIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //タイトルの設定
        self.title = "\(players[playerIndex].name)"
        
        //picker内データの設定
        for game in games {
            if game.player1 == players[playerIndex].name && !teamValues.contains(game.p1team){
                teamValues = teamValues.adding(game.p1team) as NSArray!
            }else if game.player2 == players[playerIndex].name && !teamValues.contains(game.p2team){
                teamValues = teamValues.adding(game.p2team) as NSArray!
            }
        }
        for player in players {
            if players[playerIndex].name != player.name {
                vsValues = vsValues.adding(player.name) as NSArray!
            }
        }
        
        // Viewの背景色をwhiteに設定する.
        self.view.backgroundColor = UIColor.white
        
        // 位置座標の設定
        let barHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height

        // team labelの生成
        teamLabel = UILabel()
        teamLabel.frame = CGRect(x: myBoundSize.width/2-170, y: barHeight+50, width: 200, height: 30)
        teamLabel.text = "Your Team"
        teamLabel.textAlignment = NSTextAlignment.center
        //teamLabel.font = UIFont.systemFont(ofSize: CGFloat(20))
        self.view.addSubview(teamLabel)

        // team pickerの生成
        teamPicker = UIPickerView()
        teamPicker.frame = CGRect(x: myBoundSize.width/2-170, y: barHeight+80, width: 200, height: 100)
        teamPicker.delegate = self
        teamPicker.dataSource = self
        teamPicker.tag = 1
        self.view.addSubview(teamPicker)

        // vs labelの生成
        vsLabel = UILabel()
        vsLabel.frame = CGRect(x: myBoundSize.width/2+50, y: barHeight+50, width: 100, height: 30)
        vsLabel.text = "Opponent"
        vsLabel.textAlignment = NSTextAlignment.center
        //vsLabel.font = UIFont.systemFont(ofSize: CGFloat(20))
        self.view.addSubview(vsLabel)

        // vs pickerの生成
        vsPicker = UIPickerView()
        vsPicker.frame = CGRect(x: myBoundSize.width/2+50, y: barHeight+80, width: 100, height: 100)
        vsPicker.delegate = self
        vsPicker.dataSource = self
        vsPicker.tag = 2
        self.view.addSubview(vsPicker)


        // 勝ち負け引き分けのlabelの生成
        wldLabel = UILabel()
        wldLabel.frame = CGRect(x: myBoundSize.width/2-150, y: barHeight+250, width: 300, height: 30)
        wldLabel.textAlignment = NSTextAlignment.center
        wldLabel.font = UIFont.systemFont(ofSize: CGFloat(23))
        wldLabel.text = "Win: \(players[playerIndex].win)   Lose: \(players[playerIndex].lose)   Draw: \(players[playerIndex].draw)"
        self.view.addSubview(wldLabel)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // pickerの表示数
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    // pickerに表示する行数を返すデータソースメソッド (実装必須)
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag==1 {
            return teamValues.count
        }else if pickerView.tag==2 {
            return vsValues.count
        }
        return vsValues.count
    }
    
    // pickerに表示する値を返すデリゲートメソッド.
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag==1{
            return teamValues[row] as? String
        }else if pickerView.tag==2 {
            return vsValues[row] as? String
        }
        return vsValues[row] as? String
    }
    
    
    // pickerが選択された際に呼ばれるデリゲートメソッド.
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1{
            teamIndex = row
            setLabel()
        }else{
            vsIndex = row
            setLabel()
        }

    }
    
    func setLabel(){
        switch (teamIndex,vsIndex) {
        case (0,0):
            wldLabel.text = "Win: \(players[playerIndex].win)   Lose: \(players[playerIndex].lose)   Draw: \(players[playerIndex].draw)"
       case (let x,0) where x > 0:
            let win1game = realmTry.objects(realmGame.self).filter("winner==%@ AND winnerteam==%@",players[playerIndex].name,teamValues[teamIndex])
            let lose1game = realmTry.objects(realmGame.self).filter("loser==%@ AND loserteam==%@",players[playerIndex].name,teamValues[teamIndex])
            let draw1game = realmTry.objects(realmGame.self).filter("loser=='' AND ((player1==%@ AND p1team==%@) OR (player2==%@ AND p2team==%@))",players[playerIndex].name,teamValues[teamIndex],players[playerIndex].name,teamValues[teamIndex])
            wldLabel.text = "Win: \(win1game.count)   Lose: \(lose1game.count)   Draw: \(draw1game.count)"
        case (0,let y) where y > 0:
            let win2game = realmTry.objects(realmGame.self).filter("winner==%@ AND loser==%@",players[playerIndex].name,vsValues[vsIndex])
            let lose2game = realmTry.objects(realmGame.self).filter("loser==%@ AND winner==%@",players[playerIndex].name,vsValues[vsIndex])
            let draw2game = realmTry.objects(realmGame.self).filter("loser=='' AND ((player1==%@ AND player2==%@) OR (player1==%@ AND player2==%@))",players[playerIndex].name,vsValues[vsIndex],vsValues[vsIndex],players[playerIndex].name)
            wldLabel.text = "Win: \(win2game.count)   Lose: \(lose2game.count)   Draw: \(draw2game.count)"
        case (let x,let y) where x > 0 && y > 0:
            let win3game = realmTry.objects(realmGame.self).filter("winner==%@ AND (loser==%@ AND winnerteam==%@)",players[playerIndex].name,vsValues[vsIndex],teamValues[teamIndex])
            let lose3game = realmTry.objects(realmGame.self).filter("loser==%@ AND winner==%@ AND loserteam==%@",players[playerIndex].name,vsValues[vsIndex],teamValues[teamIndex])
            let draw3game = realmTry.objects(realmGame.self).filter("loser=='' AND ((player1==%@ AND player2==%@ AND p1team ==%@)OR(player1==%@ AND player2==%@ AND p2team ==%@))",players[playerIndex].name,vsValues[vsIndex],teamValues[teamIndex],vsValues[vsIndex],players[playerIndex].name,teamValues[teamIndex])
            wldLabel.text = "Win: \(win3game.count)  Lose: \(lose3game.count)   Draw: \(draw3game.count)"
        default: break
            
        }
    }
}
