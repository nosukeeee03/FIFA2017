//
//  GameViewController.swift
//  FIFA2017
//
//  Created by 水谷　慎之介 on 2016/10/05.
//  Copyright © 2016年 水谷　慎之介. All rights reserved.
//

import UIKit
import RealmSwift

class GameViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
 
    //TabBarの設定
    init() {
        super.init(nibName: nil, bundle: nil)
        
        // Viewの背景色をwhiteに設定する.
        self.view.backgroundColor = UIColor.white
        
        //tabBarItemのアイコンをFeaturedに、タグを2と定義する.
        self.tabBarItem = UITabBarItem(title: "Game" , image: UIImage(named: "football.png"), tag: 2)
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
        self.title = "Games"
        let gameAddButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(GameViewController.onClickAddButton(sender:)))
        self.navigationItem.setRightBarButton(gameAddButton, animated: true)

        // Viewの高さと幅を取得.
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height
        
        // playerTableViewの生成
        gameTableView = UITableView(frame: CGRect(x: 0, y: 0, width: displayWidth, height: displayHeight))
        gameTableView.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
        gameTableView.dataSource = self
        gameTableView.delegate = self
        self.view.addSubview(gameTableView)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //Game Addボタンのイベント.
    internal func onClickAddButton(sender: UIButton) {
        // 遷移するViewを定義する.
        let mySecondViewController: UIViewController = AddGameViewController()
        self.navigationController?.pushViewController(mySecondViewController, animated: true)
    }
    
    
    //Cellが選択された際に呼び出される.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Num: \(indexPath.row)")
        print("Value: \(games[indexPath.row].date)")
    }
    
    //Cellの総数を返す.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return games.count
    }
    
    //Cellに値を設定する.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: .subtitle, reuseIdentifier: "myCell")
        let p1name = UILabel(frame: CGRect(x: 0, y: 0, width: (myBoundSize.width-50)/2, height: 55))
        let p1score = UILabel(frame: CGRect(x: (myBoundSize.width-50)/2, y: 0, width: 15, height: 30))
        let p2score = UILabel(frame: CGRect(x: (myBoundSize.width-50)/2+35, y: 0, width: 15, height: 30))
        let p2name = UILabel(frame: CGRect(x: (myBoundSize.width-50)/2+50, y: 0, width: (myBoundSize.width-50)/2, height: 55))
        let title = UILabel(frame: CGRect(x: (myBoundSize.width - 20)/2, y: 0, width: 20, height: 30))
        let subtitle = UILabel(frame: CGRect(x: 0, y: 30, width: myBoundSize.width, height: 20))

        p1name.text = "\(games[indexPath.row].player1)"
        p1name.textAlignment = NSTextAlignment.center
        p1name.font = UIFont.systemFont(ofSize: CGFloat(25))
        cell.addSubview(p1name)
        
        p2name.text = "\(games[indexPath.row].player2)"
        p2name.textAlignment = NSTextAlignment.center
        p2name.font = UIFont.systemFont(ofSize: CGFloat(25))
        cell.addSubview(p2name)
        
        if games[indexPath.row].p1score > games[indexPath.row].p2score {
            p1score.textColor = UIColor.red
            p2score.textColor = UIColor.blue
        }else if games[indexPath.row].p1score < games[indexPath.row].p2score {
            p1score.textColor = UIColor.blue
            p2score.textColor = UIColor.red
        }
        
        p1score.text = "\(games[indexPath.row].p1score)"
        p1score.textAlignment = NSTextAlignment.center
        p1score.font = UIFont.systemFont(ofSize: CGFloat(20))
        cell.addSubview(p1score)
        
        p2score.text = "\(games[indexPath.row].p2score)"
        p2score.textAlignment = NSTextAlignment.center
        p2score.font = UIFont.systemFont(ofSize: CGFloat(20))
        cell.addSubview(p2score)
        
        title.text = "-"
        title.textAlignment = NSTextAlignment.center
        cell.addSubview(title)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/M/d  HH:mm"
        dateFormatter.locale = NSLocale(localeIdentifier: "ja_JP") as Locale!
        subtitle.text = "\(dateFormatter.string(from: games[indexPath.row].date as Date))"
        subtitle.textAlignment = NSTextAlignment.center
        subtitle.textColor = UIColor.gray
        subtitle.font = UIFont.systemFont(ofSize: CGFloat(10))
        cell.addSubview(subtitle)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath!) -> CGFloat {
        return 55
    }
    
    //Cellを削除しようとした際に呼び出される
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        // 削除のとき.
        if editingStyle == UITableViewCellEditingStyle.delete {
            print("削除")
            let p1name = games[indexPath.row].player1
            let p2name = games[indexPath.row].player2
            let p1score = games[indexPath.row].p1score
            let p2score = games[indexPath.row].p2score
            let p1 = realmTry.objects(realmPlayer).filter("name==%@",p1name).first
            let p2 = realmTry.objects(realmPlayer).filter("name==%@",p2name).first
            
            //realmファイルを開く
            try!realmTry.write {
                if p1score == p2score {
                    p1!.draw -= 1
                    p2!.draw -= 1
                }else if p1score < p2score {
                    p1!.lose -= 1
                    p2!.win -= 1
                }else{
                    p1!.win -= 1
                    p2!.lose -= 1
                }
                p1!.goals -= p1score
                p1!.goalag -= p2score
                p2!.goals -= p2score
                p2!.goalag -= p1score
                //オブジェクト削除
                realmTry.delete(games[indexPath.row])
                gameTableView.reloadData()
                playerTableView.reloadData()
            }
        }
    }

}
