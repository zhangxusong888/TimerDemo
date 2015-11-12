//
//  WorkThreadViewController.swift
//  TimerDemo
//
//  Created by zhangxusong on 15/11/10.
//  Copyright © 2015年 mo. All rights reserved.
//

import UIKit

extension WorkThreadViewController {
    // 定时器
    func startTimer() {
        //在当前Run Loop中添加timer，模式是默认的NSDefaultRunLoopMode
        timer = NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: Selector("timerHandler"), userInfo: nil, repeats: true)
        guard let timer = timer else { return }
        //使用NSRunLoopCommonModes模式，把timer加入到当前Run Loop中。
        NSRunLoop.currentRunLoop().addTimer(timer, forMode: NSRunLoopCommonModes)
        viewModel?.log = "startTimer(): \(timer)"
        NSRunLoop.currentRunLoop().run()
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

extension WorkThreadViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel = LogViewModel()
        viewModel?.log = "主线程: \(NSThread.currentThread())"
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        //创建并执行新的线程
//        let thread = NSThread(target: self, selector: Selector("startTimer"), object: nil)
//        thread.start()
        NSThread.detachNewThreadSelector(Selector("startTimer"), toTarget: self, withObject: nil)
//        viewModel?.log = "新的线程: \(thread)"
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        stopTimer()
    }
}

class WorkThreadViewController: UIViewController {
    
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
