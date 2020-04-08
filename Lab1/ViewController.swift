//
//  ViewController.swift
//  Lab1
//
//  Created by Test Testovich on 30/03/2020.
//  Copyright © 2020 Test Testovich. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var t : Timer?
    
    var enemies = [[Enemy]]()
    var aliveEnemies = 15
    
    var enemyXDir :CGFloat = -1
    var enemyYDir :CGFloat = 0
    
    @IBOutlet weak var hp: UILabel!
    @IBOutlet var TapGesture: UITapGestureRecognizer!

    @IBOutlet weak var RightB: UIButton!

    @IBOutlet weak var LeftB: UIButton!
    
    @IBOutlet weak var player: Player!
    @IBOutlet weak var DeathScreen: UILabel!
    
    @IBOutlet weak var bestScoreSV: UIStackView!
    @IBOutlet weak var best_score: UILabel!
    
    @IBOutlet weak var ScoreSV: UIStackView!
    @IBOutlet weak var score: UILabel!
    
    @IBOutlet weak var LevelSV: UIStackView!
    @IBOutlet weak var level: UILabel!
    
    var playerBullets = [UIImageView]()
    var playerAttackCD = 30
    
    var enemyBullets = [UIImageView]()
    var enemyAttackCD: Double = 50
    
    //Controls
    //-------------
    @IBAction func LBTouchDown(_ sender: UIButton) {
        player.direction = -1
    }
    @IBAction func LBTouchUp(_ sender: UIButton) {
        player.direction = 0
    }
    @IBAction func RBTouchDown(_ sender: UIButton) {
        player.direction = 1
    }
    @IBAction func RBTouchUp(_ sender: UIButton) {
        player.direction = 0
    }
    //--------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
         backgroundImage.image = #imageLiteral(resourceName: "space-invader-enemy-1-512")
         backgroundImage.contentMode = UIView.ContentMode.scaleAspectFill
         self.view.insertSubview(backgroundImage, at: 0)*/
        
        playerAttackCD = player.fireRate
        
        let playerFrame = CGRect(x: view.frame.width * 0.4 , y: view.frame.height - 0.2 * view.frame.width - (1/11) * view.frame.width, width: 0.2 * view.frame.width , height:  0.2 * view.frame.width)
        
        player.frame = playerFrame
        
        setUpEnemies()
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        player.saveManager.load()
        restart()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        player.saveManager.saveLevel()
    }
    
    func setUpEnemies() {
        for i in 1...5 {
            var enemyX = [Enemy]()
            for j in 1...3{
                let enemyCGRect = CGRect(x:view.frame.width * CGFloat(i*2-1) * (1/11), y:view.frame.width * (1.5/11) * CGFloat(j), width: view.frame.width * (1/11), height: view.frame.width * (1/11))
                let newEnemy = Enemy(frame: enemyCGRect)
                newEnemy.image = #imageLiteral(resourceName: "space-invader-enemy-1-512")
                view.addSubview(newEnemy)
                enemyX.append(newEnemy)
                
            }
            enemies.append(enemyX)
        }
    }
    
    
    @IBAction func onTap(_ sender: UITapGestureRecognizer) {
        if player.isDead {
            DeathScreen.isHidden = true
            bestScoreSV.isHidden = true
            
            restart()
        }
    }
    
    func restart() {
        player.resurrect()
        enemyAttackCD = Double(50*pow(0.8, Double(player.saveManager.level)))
        hp.text = String(player.health)
        score.text = String(player.saveManager.score)
        level.text = String(player.saveManager.level)
        
        for i in 0...4 {
            for j in 0...2 {
                enemies[i][j].frame.origin.x = view.frame.width * CGFloat((i+1)*2-1) * (1/11)
                enemies[i][j].frame.origin.y = view.frame.width * (1.5/11) * CGFloat(j+1)
                enemies[i][j].isHidden = false
            }
        }
        aliveEnemies = 15
        
        t = Timer.scheduledTimer(timeInterval: 1/30, target: self, selector: #selector(draw), userInfo: nil, repeats: true)
    }
    
    @objc func draw()  {
        
        drawPlayer()
        drawEnemies()
        
    }
    
    func drawPlayer() {
        playerAttackCD += 1
        attack()
        
        let ms = player.calcMS()
        if (player.frame.origin.x + ms) > 5 &&
            (player.frame.origin.x + ms < (view.frame.maxX-player.frame.width-5)) {
            player.frame.origin.x += ms
        }
        
        checkForDeath()
        
        
    }
    
    func checkForDeath() {
        
        if enemies[0][2].frame.origin.y + enemies[0][2].frame.height > player.frame.origin.y {
            die()
        }
        
        for (number, item) in enemyBullets.enumerated() {
            item.frame.origin.y += 5
            if item.frame.origin.y > item.frame.height + view.frame.height {
                enemyBullets[number].removeFromSuperview()
                enemyBullets.remove(at: number)
            }
            if (item.frame.origin.y - player.frame.height*0.3 > player.frame.origin.y){
                if (item.frame.intersects(player.frame)) {
                    enemyBullets[number].removeFromSuperview()
                    enemyBullets.remove(at: number)
                    player.health-=1
                    hp.text = String(player.health)
                    if (player.health==0) {
                        die()
                    }
                    
                }
            }
        }
        
    }
    
    func die() {
        player.die()
        aliveEnemies = 15
        best_score.text = String(player.saveManager.bestScore)
        bestScoreSV.isHidden = false
        DeathScreen.isHidden = false
        t?.invalidate()
    }
    
    func attack() {
        if playerAttackCD > player.fireRate {
            let myView = CGRect(x: player.frame.origin.x + player.frame.width * 0.45, y: player.frame.origin.y-player.frame.height * 0.3, width: player.frame.width * 0.1, height: player.frame.height * 0.5)
            let newPlayerBullet = UIImageView(frame: myView)
            newPlayerBullet.image = #imageLiteral(resourceName: "220-2205494_space-invaders-ship-clipart")
            view.addSubview(newPlayerBullet)
            playerBullets.append(newPlayerBullet)
            playerAttackCD = 0
        }
        
        //player bullet intersect check + new level check
        let enemyPos = enemies[0][2].frame.origin.y + enemies[0][2].frame.height
        outer: for (number, item) in playerBullets.enumerated(){
            item.frame.origin.y -= 10
            if item.frame.origin.y < -150 {
                playerBullets[number].removeFromSuperview()
                playerBullets.remove(at: number)
            } else {
                if enemyPos >= item.frame.origin.y {
                    inner : for i in 0...4 {
                        for j in 0...2 {
                            if (item.frame.intersects(enemies[i][j].frame) && enemies[i][j].isHidden==false) {
                                playerBullets[number].removeFromSuperview()
                                playerBullets.remove(at: number)
                                enemies[i][j].isHidden = true
                                player.saveManager.score += player.saveManager.level
                                score.text = String(player.saveManager.score)
                                aliveEnemies -= 1
                                
                                if aliveEnemies == 0 {
                                    t?.invalidate()
                                    player.saveManager.level += 1
                                    player.saveManager.save()
                                    restart()
                                    break outer
                                }
                                break inner
                            }
                        }
                    }
                }
            }
        }
        //---------------
        
    }
    
    func drawEnemies() {
        enemyAttack()
        
        for i in 0...4 {
            for j in 0...2 {
                enemies[i][j].frame.origin.x += enemyXDir
            }
        }
        
        for i in 0...4{
            if enemies[i][0].frame.origin.x + enemies[i][0].frame.width >= view.frame.width {
                enemyXDir = -1
                enemyYDir += view.frame.width * (1/44)
            }
            if enemies[i][0].frame.origin.x  <= 0 {
                enemyXDir = 1
                enemyYDir += view.frame.width * (1/44)
            }
        }
        
        for i in 0...4 {
            for j in 0...2 {
                enemies[i][j].frame.origin.y += enemyYDir
                enemies[i][j].transform = CGAffineTransform(scaleX: enemyXDir, y: 1)
            }
        }
        enemyYDir = 0
        
        
    }
    
    func enemyAttack(){
        enemyAttackCD += 1
        
        if enemyAttackCD >= 60 {
            let randx = Int.random(in: 0...4)
            let randy = Int.random(in: 0...2)
            let selectedEnemy = enemies[randx][randy]
            if !selectedEnemy.isHidden {
                let myView = CGRect(x: selectedEnemy.frame.origin.x + selectedEnemy.frame.width * 0.45, y: selectedEnemy.frame.origin.y + selectedEnemy.frame.height * 0.3, width: selectedEnemy.frame.width * 0.5, height: selectedEnemy.frame.height * 0.5)
                let newEnemyBullet = UIImageView(frame: myView)
                newEnemyBullet.image = #imageLiteral(resourceName: "220-2205494_space-invaders-ship-clipart")
                view.addSubview(newEnemyBullet)
                enemyBullets.append(newEnemyBullet)
                enemyAttackCD = 0
            }
        }
        
        for (number, item) in enemyBullets.enumerated() {
            item.frame.origin.y += 5
            if item.frame.origin.y > item.frame.height + view.frame.height {
                enemyBullets[number].removeFromSuperview()
                enemyBullets.remove(at: number)
            }
        }
        
        
    }
}
