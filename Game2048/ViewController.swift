//
//  ViewController.swift
//  Game2048
//
//  Created by admin on 2021/12/3.
//

import UIKit

//获取屏幕宽度
var screen_width:CGFloat{
    return UIScreen.main.bounds.width
}
//自定义间隔
var spacing:CGFloat = 10

class ViewController: UIViewController {
    var titleLabel = UILabel()
    var nowScoreLabel = UILabel()
    var highestScoreLabel = UILabel()
    var collectionView:UICollectionView!
    var restartButton = UIButton()
    // label的显示内容
    var labelText:[String] = Array.init(repeating: " ", count: 16)
    
    // 检测滑动手势
    var leftRecognizer: UISwipeGestureRecognizer!
    var rightRecognizer: UISwipeGestureRecognizer!
    var upRecognizer: UISwipeGestureRecognizer!
    var downRecognizer: UISwipeGestureRecognizer!
    
    // 记录分数
    var nowScore: Int = 0
    var highestScore = UserDefaults.standard.integer(forKey: "HighestScore")

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .black
        initView()
        newGame()
        handleSwipeGesture()
    }
    
    func initView() {
        setupTitleLabel()
        setupNowScoreLabels()
        setupHighestScoreLabel()
        setupRestartButton()
        setupCollectionView()
    }
    
    @objc func newGame() {
        if nowScore > highestScore {
            UserDefaults.standard.set(nowScore, forKey: "HighestScore")
        }
        nowScore = 0
        highestScore = UserDefaults.standard.integer(forKey: "HighestScore")
        initView()
        labelText = Array.init(repeating: " ", count: 16)
        for _ in 1...2 {
            generateNewLabel()
        }
        collectionView.reloadData()
    }
    
    func generateNewLabel() {
        var hasEmpty = false
        for index in 0...15 {
            if labelText[index] == " " {
                hasEmpty = true
                break
            }
        }
        if hasEmpty {
            var flag = 0
            while flag == 0 {
                let index = Int(arc4random()) % 16
                if labelText[index] == " " {
                    labelText[index] = String(2 * (Int(arc4random()) % 2 + 1))
                    flag = 1
                }
            }
        }
    }
    
    func handleSwipeGesture() {
        // 左滑
        leftRecognizer = UISwipeGestureRecognizer.init(target: self, action: #selector(handleSwipeToLeft))
        leftRecognizer.direction = .left
        view.addGestureRecognizer(leftRecognizer)
        // 右滑
        rightRecognizer = UISwipeGestureRecognizer.init(target: self, action: #selector(handleSwipeToRight))
        rightRecognizer.direction = .right
        view.addGestureRecognizer(rightRecognizer)
        // 上滑
        upRecognizer = UISwipeGestureRecognizer.init(target: self, action: #selector(handleSwipeToUp))
        upRecognizer.direction = .up
        view.addGestureRecognizer(upRecognizer)
        // 下滑
        downRecognizer = UISwipeGestureRecognizer.init(target: self, action: #selector(handleSwipeToDown))
        downRecognizer.direction = .down
        view.addGestureRecognizer(downRecognizer)
    }
    
    @objc func handleSwipeToLeft() {
        var hasMoved = false
        for i in 0...3 {
            var index1 = 0
            var index2 = 0
            while index1<=3 && index2<=3 {
                while index1<=3 && labelText[index1+4*i]==" " {
                    index1 += 1
                }
                if index1 == 3 {
                    break
                } else {
                    index2 = index1 + 1
                    while index2<=3 && labelText[index2+4*i]==" " {
                        index2 += 1
                    }
                    if index1<=3 && index2<=3 && labelText[index1+4*i]==labelText[index2+4*i] {
                        hasMoved = true
                        labelText[index1+4*i] = String(Int(labelText[index1+4*i])! * 2)
                        labelText[index2+4*i] = " "
                        nowScore += Int(labelText[index1+4*i])! 
                        nowScoreLabel.text = String(nowScore)
                    }
                }
                index1 += 1
            }
            
            // 向左合并
            let temp = [labelText[0+4*i],labelText[1+4*i],labelText[2+4*i],labelText[3+4*i]]
            var head = 0 //计数添加到数组头的元素数
            var tail = 0 //计数添加到数组尾的元素数
            for m in 0...3 {
                if temp[m] != " " {
                    labelText[head+4*i] = temp[m]
                    head += 1
                } else {
                    labelText[3-tail+4*i] = " "
                    tail += 1
                }
            }
            if !(temp[0]==labelText[0+4*i] && temp[1]==labelText[1+4*i] && temp[2]==labelText[2+4*i] && temp[3]==labelText[3+4*i]) {
                hasMoved = true
            }
            
        }
        // 生成新块
        if hasMoved {
            generateNewLabel()
        }
        collectionView.reloadData()
        checkEnding()
    }
    @objc func handleSwipeToRight() {
        var hasMoved = false
        for i in 0...3 {
            var index1 = 3
            var index2 = 3
            while index1>=0 && index2>=0 {
                while index1>=0 && labelText[index1+4*i]==" " {
                    index1 -= 1
                }
                if index1 == 0 {
                    break
                } else {
                    index2 = index1 - 1
                    while index2>=0 && labelText[index2+4*i]==" " {
                        index2 -= 1
                    }
                    if index1>=0 && index2>=0 && labelText[index1+4*i]==labelText[index2+4*i] {
                        hasMoved = true
                        labelText[index1+4*i] = String(Int(labelText[index1+4*i])! * 2)
                        labelText[index2+4*i] = " "
                        nowScore += Int(labelText[index1+4*i])!
                        nowScoreLabel.text = String(nowScore)
                    }
                }
                index1 -= 1
            }
        
            //  向右合并
            let temp = [labelText[3+4*i],labelText[2+4*i],labelText[1+4*i],labelText[0+4*i]]
            var head = 0 //计数添加到数组头的元素数
            var tail = 0 //计数添加到数组尾的元素数
            for m in 0...3 {
                if temp[m] != " " {
                    labelText[3-head+4*i] = temp[m]
                    head += 1
                } else {
                    labelText[tail+4*i] = " "
                    tail += 1
                }
            }
            if !(temp[0]==labelText[3+4*i] && temp[1]==labelText[2+4*i] && temp[2]==labelText[1+4*i] && temp[3]==labelText[0+4*i]) {
                hasMoved = true
            }
            
        }
        // 生成新块
        if hasMoved {
            generateNewLabel()
        }
        collectionView.reloadData()
        checkEnding()
    }
    @objc func handleSwipeToUp() {
        var hasMoved = false
        for i in (0...3).reversed() {
            var index1 = 0
            var index2 = 0
            while index1<=3 && index2<=3 {
                while index1<=3 && labelText[i+4*index1]==" " {
                    index1 += 1
                }
                if index1 == 3 {
                    break
                } else {
                    index2 = index1 + 1
                    while index2<=3 && labelText[i+4*index2]==" " {
                        index2 += 1
                    }
                    if index1<=3 && index2<=3 && labelText[i+4*index1]==labelText[i+4*index2] {
                        hasMoved = true
                        labelText[i+4*index1] = String(Int(labelText[i+4*index1])! * 2)
                        labelText[i+4*index2] = " "
                        nowScore += Int(labelText[i+4*index1])!
                        nowScoreLabel.text = String(nowScore)
                    }
                }
                index1 += 1
            }
            
            // 向上合并
            let temp = [labelText[i+4*0],labelText[i+4*1],labelText[i+4*2],labelText[i+4*3]]
            var head = 0 //计数添加到数组头的元素数
            var tail = 0 //计数添加到数组尾的元素数
            for m in 0...3 {
                if temp[m] != " " {
                    labelText[i+4*head] = temp[m]
                    head += 1
                } else {
                    labelText[i+4*(3-tail)] = " "
                    tail += 1
                }
            }
            if !(temp[0]==labelText[i+4*0] && temp[1]==labelText[i+4*1] && temp[2]==labelText[i+4*2] && temp[3]==labelText[i+4*3]) {
                hasMoved = true
            }
        }
        // 生成新块
        if hasMoved {
            generateNewLabel()
        }
        collectionView.reloadData()
        checkEnding()

    }
    @objc func handleSwipeToDown() {
        var hasMoved = false
        for i in 0...3 {
            var index1 = 3
            var index2 = 3
            while index1>=0 && index2>=0 {
                while index1>=0 && labelText[i+4*index1]==" " {
                    index1 -= 1
                }
                if index1 == 0 {
                    break
                } else {
                    index2 = index1 - 1
                    while index2>=0 && labelText[i+4*index2]==" " {
                        index2 -= 1
                    }
                    if index1>=0 && index2>=0 && labelText[i+4*index1]==labelText[i+4*index2] {
                        hasMoved = true
                        labelText[i+4*index1] = String(Int(labelText[i+4*index1])! * 2)
                        labelText[i+4*index2] = " "
                        nowScore += Int(labelText[i+4*index1])!
                        nowScoreLabel.text = String(nowScore)
                    }
                }
                index1 -= 1
            }
            
            // 向下合并
            let temp = [labelText[i+4*3],labelText[i+4*2],labelText[i+4*1],labelText[i+4*0]]
            var head = 0 //计数添加到数组头的元素数
            var tail = 0 //计数添加到数组尾的元素数
            for m in 0...3 {
                if temp[m] != " " {
                    labelText[i+4*(3-head)] = temp[m]
                    head += 1
                } else {
                    labelText[i+4*tail] = " "
                    tail += 1
                }
            }
            if !(temp[0]==labelText[i+4*3] && temp[1]==labelText[i+4*2] && temp[2]==labelText[i+4*1] && temp[3]==labelText[i+4*0]) {
                hasMoved = true
            }
        }
        // 生成新块
        if hasMoved {
            generateNewLabel()
        }
        collectionView.reloadData()
        checkEnding()

    }
    
    func checkEnding() {
        for i in 0...3 {
            // 检测横向是否可移动
            var head = 0, tail = 1
            for _ in 1...3 {
                if labelText[head+4*i]==" " || labelText[tail+4*i]==" " {
                    return
                } else if labelText[head+4*i] == labelText[tail+4*i] {
                    return
                }
                head += 1
                tail += 1
            }
            // 检测纵向是否可移动
            head = 0;
            tail = 1;
            for _ in 1...3 {
                if labelText[i+4*head]==" " || labelText[i+4*tail]==" " {
                    return
                } else if labelText[i+4*head] == labelText[i+4*tail] {
                    return
                }
                head += 1
                tail += 1
            }
        }
        
        let alertController = UIAlertController(title: "2048", message: "一副好牌让你打得稀烂！", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "我不玩了", style: .default, handler: nil)
        let againAction = UIAlertAction(title: "再来亿次", style: .cancel, handler: {
            action in
            self.newGame()
        })
        alertController.addAction(cancelAction)
        alertController.addAction(againAction)
        self.present(alertController, animated: true, completion: nil)
        

        
    }
    
    func setupTitleLabel() {
        view.addSubview(titleLabel)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 80).isActive = true
        titleLabel.text = "2048"
        titleLabel.textColor = UIColor.brown
        titleLabel.font = UIFont.boldSystemFont(ofSize: 50)
        titleLabel.sizeToFit()
    }
    
    func setupNowScoreLabels() {
        let nowScoreTextLabel = UILabel()
        view.addSubview(nowScoreTextLabel)
        nowScoreTextLabel.textAlignment = .center
        nowScoreTextLabel.translatesAutoresizingMaskIntoConstraints = false
        nowScoreTextLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -100).isActive = true
        nowScoreTextLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10).isActive = true
        nowScoreTextLabel.text = "Now Score"
        nowScoreTextLabel.textColor = UIColor.brown
        nowScoreTextLabel.font = UIFont.systemFont(ofSize: 25)
        nowScoreTextLabel.sizeToFit()
        
        view.addSubview(nowScoreLabel)
        nowScoreLabel.textAlignment = .center
        nowScoreLabel.translatesAutoresizingMaskIntoConstraints = false
        nowScoreLabel.centerXAnchor.constraint(equalTo: nowScoreTextLabel.centerXAnchor).isActive = true
        nowScoreLabel.topAnchor.constraint(equalTo: nowScoreTextLabel.bottomAnchor, constant: 10).isActive = true
        nowScoreLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        nowScoreLabel.text = String(nowScore)
        nowScoreLabel.textColor = UIColor.brown
        nowScoreLabel.font = UIFont.boldSystemFont(ofSize: 28)
    }
    
    func setupHighestScoreLabel() {
        let highestScoreTextLabel = UILabel()
        view.addSubview(highestScoreTextLabel)
        highestScoreTextLabel.textAlignment = .center
        highestScoreTextLabel.translatesAutoresizingMaskIntoConstraints = false
        highestScoreTextLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 100).isActive = true
        highestScoreTextLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10).isActive = true
        highestScoreTextLabel.text = "Highest Score"
        highestScoreTextLabel.textColor = UIColor.brown
        highestScoreTextLabel.font = UIFont.systemFont(ofSize: 25)
        highestScoreTextLabel.sizeToFit()
        
        view.addSubview(highestScoreLabel)
        highestScoreLabel.textAlignment = .center
        highestScoreLabel.translatesAutoresizingMaskIntoConstraints = false
        highestScoreLabel.centerXAnchor.constraint(equalTo: highestScoreTextLabel.centerXAnchor).isActive = true
        highestScoreLabel.topAnchor.constraint(equalTo: highestScoreTextLabel.bottomAnchor, constant: 10).isActive = true
        highestScoreLabel.text = String(highestScore)
        highestScoreLabel.textColor = UIColor.brown
        highestScoreLabel.font = UIFont.boldSystemFont(ofSize: 28)
    }
    
    func setupRestartButton() {
        view.addSubview(restartButton)
        restartButton.translatesAutoresizingMaskIntoConstraints = false
        restartButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        restartButton.topAnchor.constraint(equalTo: highestScoreLabel.bottomAnchor, constant: 20).isActive = true
        restartButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        restartButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        restartButton.backgroundColor = UIColor.brown
        restartButton.layer.cornerRadius = 5
        restartButton.setTitle("重新开始", for: .normal)
        restartButton.addTarget(self, action: #selector(newGame), for: .touchUpInside)
    }
    
    
    func setupCollectionView() {
        let flowLayout = UICollectionViewFlowLayout()
        let cellWidth = (screen_width-30-3*spacing)/4
        flowLayout.itemSize = CGSize(width: cellWidth, height: cellWidth)
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .black
        collectionView.topAnchor.constraint(equalTo: highestScoreLabel.bottomAnchor, constant: 100).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15).isActive = true
        collectionView.heightAnchor.constraint(equalToConstant: cellWidth*4+spacing*3).isActive = true
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: CollectionViewCell.identifier)
    }
    


}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UIApplicationDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return labelText.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.identifier, for: indexPath) as! CollectionViewCell
        cell.configCellWithNumber(number: labelText[indexPath.item], tag: indexPath.item)
        return cell
    }
    
}

