//
//  AddTeamViewController.swift
//  FIFA2017
//
//  Created by 水谷　慎之介 on 2016/10/09.
//  Copyright © 2016年 水谷　慎之介. All rights reserved.
//

import UIKit
import RealmSwift

class AddTeamViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource{
    private var teamTextField: UITextField!
    private var teamAddButton: UIButton!
    private var rValues: [Int] = [0,1,2,3,4,5,6,7,8,9,10]
    private var rankPicker: UIPickerView!
    private var leaguePicker: UIPickerView!
    private var selectedRank: Int = 0
    private var selectedLeague: String = leagues[0] as! String

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Add Team"
        
        // Viewの背景色をwhiteに設定する.
        self.view.backgroundColor = UIColor.white
        
        //位置座標の設定
        let barHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
        
        // UITextFieldの作成
        teamTextField = UITextField(frame: CGRect(x: myBoundSize.width/2-100, y: barHeight+70, width: 200, height: 30))
        teamTextField.text = ""
        teamTextField.delegate = self
        teamTextField.borderStyle = .roundedRect
        teamTextField.clearButtonMode = .whileEditing
        self.view.addSubview(teamTextField)

        
        //addボタンを作成する
        teamAddButton = UIButton()
        teamAddButton.frame = CGRect(x: (myBoundSize.width-50)/2, y: 500, width: 50, height: 30)
        teamAddButton.setTitle("Add", for: .normal)
        teamAddButton.setTitleColor(UIColor.blue, for: .normal)
        teamAddButton.setTitleColor(UIColor.black, for: .highlighted)
        teamAddButton.tag = 1
        teamAddButton.addTarget(self, action: #selector(AddTeamViewController.onClickAddButton(sender:)), for: .touchUpInside)
        self.view.addSubview(teamAddButton)
        
        // pickerの生成
        rankPicker = UIPickerView()
        rankPicker.frame = CGRect(x: myBoundSize.width/2-50, y: barHeight+100, width: 100, height: 100)
        rankPicker.delegate = self
        rankPicker.dataSource = self
        rankPicker.tag = 1
        self.view.addSubview(rankPicker)
        
        leaguePicker = UIPickerView()
        leaguePicker.frame = CGRect(x: myBoundSize.width/2-140, y: barHeight+200, width: 280, height: 100)
        leaguePicker.delegate = self
        leaguePicker.dataSource = self
        leaguePicker.tag = 2
        self.view.addSubview(leaguePicker)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    //Team Addボタンのイベント.
    internal func onClickAddButton(sender: UIButton) {
        let team = realmTeam()
        team.name = teamTextField.text!
        team.rank = selectedRank
        team.league = selectedLeague
        try! realmTry.write {
            realmTry.add(team)
        }
         self.navigationController?.popViewController(animated: true)
    }

    // pickerの表示数
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    // pickerに表示する行数を返すデータソースメソッド (実装必須)
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag==1 {
            return rValues.count
        }else if pickerView.tag==2{
            return leagues.count
        }
        return leagues.count
    }
    
    // pickerに表示する値を返すデリゲートメソッド.
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag==1{
            return String(rValues[row])
        }else if pickerView.tag==2{
            return String(describing: leagues[row])
        }
        return String(describing: leagues[row])
    }
    
    
    // pickerが選択された際に呼ばれるデリゲートメソッド.
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag==1{
            selectedRank = rValues[row]
        }else if pickerView.tag==2{
            selectedLeague = String(describing: leagues[row])
        }
    }

}
