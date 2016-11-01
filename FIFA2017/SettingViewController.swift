//
//  SettingViewController.swift
//  FIFA2017
//
//  Created by 水谷　慎之介 on 2016/10/12.
//  Copyright © 2016年 水谷　慎之介. All rights reserved.
//

import UIKit
import RealmSwift

class SettingViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource{
    
    //Setting menu
    let setMenu = ["Add Team","Add League"]
    
    //TabBarの設定
    init() {
        super.init(nibName: nil, bundle: nil)
        
        // Viewの背景色をwhiteに設定する.
        self.view.backgroundColor = UIColor.white
        
        //tabBarItemのアイコンをFeaturedに、タグを2と定義する.
        self.tabBarItem = UITabBarItem(title: "Setting" , image: UIImage(named: "spanner.png"), tag: 3)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    required override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: Bundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    var setTableView:UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // NavigationBarの設定
        self.title = "Setting"
        
        // Viewの高さと幅を取得.
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height
        
        // setTableViewの生成
        setTableView = UITableView(frame: CGRect(x: 0, y: 0, width: displayWidth, height: displayHeight))
        setTableView.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
        setTableView.dataSource = self
        setTableView.delegate = self
        self.view.addSubview(setTableView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Num: \(indexPath.row)")
        print("Value: \(setMenu[indexPath.row])")
        
        if indexPath.row == 0 {
            if leagues.count != 0 {
                // Add Team が選択されたとき
                // 遷移するViewを定義する.
                let mySecondViewController: UIViewController = AddTeamViewController()
                self.navigationController?.pushViewController(mySecondViewController, animated: true)
            } else {
                // UIAlertControllerを作成する.
                let myAlert: UIAlertController = UIAlertController(title: "ERROR", message: "Add League", preferredStyle: .alert)
                
                // OKのアクションを作成する.
                let myOkAction = UIAlertAction(title: "OK", style: .default) { action in }
                
                // OKのActionを追加する.
                myAlert.addAction(myOkAction)
                
                // UIAlertを発動する.
                present(myAlert, animated: true, completion: nil)
            }
        }else if indexPath.row==1 {
            // League Team が選択されたとき
            // 遷移するViewを定義する.
            let mySecondViewController: UIViewController = AddLeagueViewController()
            self.navigationController?.pushViewController(mySecondViewController, animated: true)
            
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return setMenu.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 再利用するCellを取得する.
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath as IndexPath)
        
        // Cellに値を設定する.
        cell.textLabel!.text = "\(setMenu[indexPath.row])"
        
        return cell
    }

}
