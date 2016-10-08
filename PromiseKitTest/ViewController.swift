//
//  ViewController.swift
//  PromiseKitTest
//
//  Created by Shane Whitehead on 8/10/16.
//  Copyright © 2016 KaiZen. All rights reserved.
//

import UIKit
import PromiseKit

class ViewController: UIViewController {
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	@IBAction func doClick(_ sender: Any) {
		makeItSo()
	}
	
	func makeItSo() {
		makePromise().then { (value) -> Void in
			print("Has been done \(value)")
		}.catch { (error) in
			print(error)
		}
	}
	
	func makePromise() -> Promise<Int> {
		var values: [Int] = []
		for num in 0..<100 {
			values.append(num)
		}
		
		var anchor: Promise<Int>?
		var count = 0
		
		for num in values {
			if let check = anchor {
				anchor = check.then(execute: { (Int) -> Promise<Int> in
					return self.makePromise(for: num)
				})
			} else {
				anchor = makePromise(for: num)
			}
			
			anchor = anchor!.then(execute: { (value) -> Promise<Int> in
				return Promise<Int> { (fulfill, fail) in
					count += 1
					fulfill(count)
				}
			})
		}
		
//		let result: Promise<Void> = Promise<Void>{ (fulfill, fail) in
//			fulfill()
//		}
//		
//		return anchor!.then(execute: { (Int) -> Promise<Void> in
//			return result
//		})
		
		return anchor!

	}
	
	func makePromise(`for` num: Int) -> Promise<Int> {
		return Promise<Int>{ (fulfill, fail) in
			DispatchQueue.global().async {
				self.later(num: num, fulfill: fulfill)
			}
		}
	}
	
	func later(num: Int, fulfill: @escaping (Int) -> Void) {
		DispatchQueue.global().async {
			print("Processing \(num)")
			Thread.sleep(forTimeInterval: 0.5)
			fulfill(num)
		}
	}
	
}

