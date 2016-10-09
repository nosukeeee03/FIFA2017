//
//  PlayerViewController.swift
//  FIFA2017
//
//  Created by 水谷　慎之介 on 2016/10/05.
//  Copyright © 2016年 水谷　慎之介. All rights reserved.
//

import UIKit
import RealmSwift

class PlayerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    //TabBarの設定
    init() {
        super.init(nibName: nil, bundle: nil)
        
        // Viewの背景色をwhiteに設定する.
        self.view.backgroundColor = UIColor.white
        
        //tabBarItemのアイコンをPlayerに、タグを1と定義する.
        self.tabBarItem = UITabBarItem(title: "Player" , image: UIImage(named: "user.png"), tag: 1)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    required override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: Bundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // NavigationBarの設定
        self.title = "Players"
        let playerAddButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(PlayerViewController.onClickAddButton(sender:)))
        self.navigationItem.setRightBarButton(playerAddButton, animated: true)
        
        // Viewの高さと幅を取得.
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height
        
        // playerTableViewの生成
        playerTableView = UITableView(frame: CGRect(x: 0, y: 0, width: displayWidth, height: displayHeight))
        playerTableView.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
        playerTableView.dataSource = self
        playerTableView.delegate = self
        self.view.addSubview(playerTableView)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //Player Addボタンのイベント.
    internal func onClickAddButton(sender: UIButton) {
        // 遷移するViewを定義する.
        let mySecondViewController: UIViewController = AddPlayerViewController()
        self.navigationController?.pushViewController(mySecondViewController, animated: true)
    }
    
    //Cellが選択された際に呼び出される.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Num: \(indexPath.row)")
        print("Value: \(players[indexPath.row].name)")
    }

    //Cellの総数を返す.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return players.count
    }

    //Cellに値を設定する.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: .value1, reuseIdentifier: "myCell")
            //tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath as IndexPath)
        
        cell.textLabel?.text = "\(players[indexPath.row].name)"
        cell.detailTextLabel?.text = "Win:\(players[indexPath.row].win) Lose:\(players[indexPath.row].lose) Draw:\(players[indexPath.row].draw) Gf:\(players[indexPath.row].goals) Ga:\(players[indexPath.row].goalag)"
        
        return cell
    }
    
    //Cellを削除しようとした際に呼び出される
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        // 削除のとき.
        if editingStyle == UITableViewCellEditingStyle.delete {
            print("削除")
            //realmファイルを開く
            try!realmTry.write {
                
                //オブジェクト削除
                realmTry.delete(players[indexPath.row])
                playerTableView.reloadData()
            }
        }
    }

}
