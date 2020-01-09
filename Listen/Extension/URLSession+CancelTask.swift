//
//  URLSession+CancelTask.swift
//  Listen
//
//  Created by Atul Prakash on 31/12/19.
//  Copyright © 2019 Atul Prakash. All rights reserved.
//

import Foundation

extension URLSession {
    func cancelTask() {
        self.getTasksWithCompletionHandler { (dataTasks, uploadTasks, downloadTasks) in
            if dataTasks.count == 0 {
                return
            }
            for task in dataTasks {
                task.cancel()
            }
        }
    }
}
