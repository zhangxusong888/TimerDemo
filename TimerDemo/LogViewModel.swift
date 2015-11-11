//
//  LogViewModel.swift
//  TimerDemo
//
//  Created by zhangxusong on 15/11/10.
//  Copyright © 2015年 mo. All rights reserved.
//

import Foundation

struct LogViewModel {
    // ui content
    var logText = "log"

    // action
    var log: String? {
        didSet {
            guard let log = log else { return }
            let message = "[\(NSDate())] \(log)"
            logText = logText + "\(message)\n\t------\t\n"
            print(message)
        }
    }
}
