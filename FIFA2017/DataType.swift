//
//  DataType.swift
//  FIFA2017
//
//  Created by 水谷　慎之介 on 2016/10/05.
//  Copyright © 2016年 水谷　慎之介. All rights reserved.
//
import UIKit
import RealmSwift

class realmPlayer: Object {
    dynamic var name = String()
    dynamic var win:Int = 0
    dynamic var lose:Int = 0
    dynamic var draw:Int = 0
    dynamic var goals:Int = 0
    dynamic var goalag:Int = 0
}

class realmGame: Object {
    dynamic var date = NSDate()
    dynamic var player1 = String()
    dynamic var player2 = String()
    dynamic var p1score:Int = 0
    dynamic var p2score:Int = 0
    dynamic var p1team = String()
    dynamic var p2team = String()
    dynamic var winner = String()
}

class realmTeam: Object {
    dynamic var name = String()
    dynamic var rank:Int = 0
    dynamic var league = String()
}

let leagues:NSArray = ["リーガエスパニョーラ","ブンデスリーガ","セリエA","プレミアリーグ","Jリーグ","リーグ1"]
var realmTry = try!Realm()
var players =  realmTry.objects(realmPlayer.self)
var games =  realmTry.objects(realmGame.self)
var teams =  realmTry.objects(realmTeam.self)
var playerTableView: UITableView!
var gameTableView: UITableView!
let myBoundSize: CGSize = UIScreen.main.bounds.size
