//
//  I am not responsible of this code.
//
//  shell.swift
//
//
//  Created by Podul on 2022/7/14
//  Copyright © 2022 Podul. All rights reserved.
//
//    ┌─┐       ┌─┐
// ┌──┘ ┴───────┘ ┴──┐
// │                 │
// │       ───       │
// │  ─┬┘       └┬─  │
// │                 │
// │       ─┴─       │
// │                 │
// └───┐         ┌───┘
//     │         │
//     │         │
//     │         │
//     │         └──────────────┐
//     │                        │
//     │                        ├─┐
//     │                        ┌─┘
//     │                        │
//     └─┐  ┐  ┌───────┬──┐  ┌──┘
//       │ ─┤ ─┤       │ ─┤ ─┤
//       └──┴──┘       └──┴──┘
//
//
//


import Foundation


public struct Shell {
    private let task = Process()
    
    init(workDir: URL? = URL(fileURLWithPath: NSHomeDirectory()),
         environment: [String: String]? = nil,
         stdinPipe: Pipe? = nil,
         stdoutPipe: Pipe? = stdoutPipe,
         stderrPipe: Pipe? = stderrPipe) {
        task.launchPath = "/usr/bin/env"
        task.currentDirectoryURL = workDir
        task.standardOutput = stdoutPipe
        task.standardInput = stdinPipe
        task.standardError = stderrPipe
        
        if let environment = environment {
            task.environment = task.environment?.merging(environment, uniquingKeysWith: { _, new in new })
        }
    }
    
    /// 参数空格已自动处理
    @discardableResult @inlinable
    public func exec(_ arguments: [String]) -> Int32 {
        let arguments = arguments.map { $0.replacingOccurrences(of: " ", with: "\\ ") }.joined(separator: " ")
        return exec(arguments)
    }
    
    /// 参数空格已自动处理
    @discardableResult @inlinable
    public func exec(_ arguments: String...) -> Int32 {
        exec(arguments)
    }
    
    
    /// 需注意参数中的空格问题
    @discardableResult
    public func exec(_ arguments: String) -> Int32 {
        task.arguments = ["/bin/bash", "-c", arguments]
        task.launch()
        task.waitUntilExit()
        return task.terminationStatus
    }
    
    public func interrupt() {
        task.interrupt()
    }
    
    // MARK: -
    private static var stdoutPipe: Pipe {
        let pipe = Pipe()
        pipe.fileHandleForReading.readabilityHandler = { handler in
            guard let log = String(data: handler.availableData, encoding: .utf8) else { return }
            fputs(log, stdout)
        }
        return pipe
    }
    
    private static var stderrPipe: Pipe {
        let pipe = Pipe()
        pipe.fileHandleForReading.readabilityHandler = { handler in
            guard let log = String(data: handler.availableData, encoding: .utf8) else { return }
            fputs(log, stderr)
        }
        return pipe
    }
}
