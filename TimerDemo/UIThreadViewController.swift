//
//  UIThreadViewController.swift
//  TimerDemo
//
//  Created by zhangxusong on 15/11/10.
//  Copyright © 2015年 mo. All rights reserved.
//

import UIKit

extension UIThreadViewController {
    // 定时器
    func startTimer() {
        viewModel?.log = "主线程: \(NSThread.currentThread())"
        //创建Timer, 这两个函数都能用
        //        timer = NSTimer(timeInterval: 2, target: self, selector: Selector("timerHandler"), userInfo: nil, repeats: true)
        timer = NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: Selector("timerHandler"), userInfo: nil, repeats: true)
        guard let timer = timer else { return }
        //使用NSRunLoopCommonModes模式，把timer加入到当前Run Loop中。
        NSRunLoop.currentRunLoop().addTimer(timer, forMode: NSRunLoopCommonModes)
        viewModel?.log = "startTimer(): \(timer)"
    }

    //timer的回调方法
    func timerHandler() {
        viewModel?.log = "Timer \(NSThread.currentThread())"
    }

    func stopTimer() {
        viewModel?.log = "stopTimer(): \(timer)"
        timer?.invalidate()
        timer = nil
    }
}

extension UIThreadViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel = LogViewModel()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        startTimer()
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)

        stopTimer()
    }
}

class UIThreadViewController: UIViewController {
    @IBOutlet weak var logTextView: UITextView!

    private var viewModel: LogViewModel? {
        didSet {
            guard let viewModel = viewModel else { return }

            dispatch_async(dispatch_get_main_queue()) {
                self.logTextView.text = viewModel.logText
            }
        }
    }
    private var timer: NSTimer?
}




