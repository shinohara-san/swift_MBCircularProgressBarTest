//
//  ViewController.swift
//  CircleAnimationLibraryTest
//
//  Created by Yuki Shinohara on 2020/06/02.
//  Copyright © 2020 Yuki Shinohara. All rights reserved.
//

import UIKit
import MBCircularProgressBar

class ViewController: UIViewController {

    @IBOutlet var progressView: MBCircularProgressBarView!
    @IBOutlet var progressValueLabel: UILabel!
    
    var duration: TimeInterval!
    
    private var timer = Timer()
    var pause = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        duration = 10
        progressView.value = 0
        progressView.maxValue = 100
        progressValueLabel.text = "\(progressView.value)"
        
//        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer.invalidate()
        //画面閉じるときにタイマー止める
    }
    
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(true)
           progressView.value = 0
           progressView.maxValue = 100
//           print(progressView.value)
       }

    @objc func handleTap(){
        self.timer.invalidate()
        if !timer.isValid {
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        }
        
        UIView.animate(withDuration: duration) {
           self.progressView.value = 100
        }
        
    }
    
    @objc func updateTimer(){
        if duration > 0{
            duration -= 1
            progressValueLabel.text = String(duration)
        } else {
            progressView.value = 0
        }

    }
    
    @IBAction func addButtonTapped(_ sender: Any) {
        showAlert()
    }
    
    func showAlert(){
        let ac = UIAlertController(title: "タイマーをセット", message: nil, preferredStyle: .alert)
        
        ac.addTextField { (textField) in
            textField.placeholder = "Seconds here"
            textField.keyboardType = .numberPad
        }
        let add = UIAlertAction(title: "追加", style: .default) { (void) in
            let textField = ac.textFields![0] as UITextField //ワンクッション
            if let text = textField.text{
                self.duration = TimeInterval(text)
                self.progressValueLabel.text = String(self.duration)
                self.timer.invalidate()
            }
        }
        let cancel = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
        ac.addAction(add)
        ac.addAction(cancel)
        present(ac, animated: true)
    }
    @IBAction func startButtonTapped(_ sender: Any) {
        self.timer.invalidate()
        if !timer.isValid {
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        }
        
        UIView.animate(withDuration: duration + 1) {
           self.progressView.value = 100
        }
    }
    
    @IBAction func stopButtonTapped(_ sender: Any) {
        if timer.isValid{
            timer.invalidate()
            progressView.layer.pause()
        } else {
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
            progressView.layer.resume()
        }
        
    }
    
    @IBAction func resetButtonTapped(_ sender: Any) {
        timer.invalidate()
        progressView.value = 0
        duration = 0
        progressValueLabel.text = String(duration)
    }
    
}

extension CALayer {
    func pause() {
        let pausedTime: CFTimeInterval = self.convertTime(CACurrentMediaTime(), from: nil)
        self.speed = 0.0
        self.timeOffset = pausedTime
    }

    func resume() {
        let pausedTime: CFTimeInterval = self.timeOffset
        self.speed = 1.0
        self.timeOffset = 0.0
        self.beginTime = 0.0
        let timeSincePause: CFTimeInterval = self.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        self.beginTime = timeSincePause
    }
}

