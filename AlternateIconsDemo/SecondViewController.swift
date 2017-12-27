//
//  SecondViewController.swift
//  AlternateIconsDemo
//
//  Created by QDHL on 2017/12/26.
//  Copyright © 2017年 QDHL. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {

    @IBOutlet weak var firstViewTop: NSLayoutConstraint!
    @IBOutlet weak var firstViewSuperviewBottom: NSLayoutConstraint!
    @IBOutlet weak var firstView: UIView!
    
    @IBAction func alertClicked(_ sender: UIButton) {
        let title = "title"
        let msg = "message"
        let cancelTitle = "cancel"
        let okTitle = "ok"
        
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel) { (action: UIAlertAction) in
            print("cancel")
        }
        
        let okAction = UIAlertAction(title: okTitle, style: .default) { (action: UIAlertAction) in
            print("ok")
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true) {
            
        }
    }
    
    @IBAction func alternateClicked(_ sender: UIButton) {
        
        if #available(iOS 10.3, *) {
            if UIApplication.shared.supportsAlternateIcons {
                let iconName = UIApplication.shared.alternateIconName
                if iconName == nil {//当前显示的是原始图标
                    UIApplication.shared.setAlternateIconName("alternate60", completionHandler: { (error) in
                        
                    })
                }
            }
        }
    }
    
    @IBAction func primaryClicked(_ sender: UIButton) {
        if #available(iOS 10.3, *) {
            if UIApplication.shared.supportsAlternateIcons {
                if let _ = UIApplication.shared.alternateIconName {//当前显示的是替换图标
                    UIApplication.shared.setAlternateIconName(nil, completionHandler: { (error) in
                        
                    })
                }
            }
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Second"
        // Do any additional setup after loading the view.
        
        let statusBarFrame = UIApplication.shared.statusBarFrame;
        let navBounds = self.navigationController?.navigationBar.bounds;
        firstViewTop.constant = statusBarFrame.height + (navBounds?.height ?? 0.0)
        
        // 5.8英寸（iphone X）
        if 812 == UIScreen.main.bounds.height {
            firstViewSuperviewBottom.constant = 34.0
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.runtimeRemoveAlert()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.runtimeResetAlert()
    }
    
    //利用runtime指定方法实现
    func runtimeRemoveAlert() -> Void {        
        if let presentM = class_getInstanceMethod(type(of: self), #selector(present(_:animated:completion:))),
            let presentSwizzlingM = class_getInstanceMethod(type(of: self), #selector(temporary_present(_:animated:completion:))){
            method_exchangeImplementations(presentM, presentSwizzlingM)
        }
    }
    //利用runtime恢复方法实现
    func runtimeResetAlert() -> Void {
        if let presentM = class_getInstanceMethod(type(of: self), #selector(present(_:animated:completion:))),
            let presentSwizzlingM = class_getInstanceMethod(type(of: self), #selector(temporary_present(_:animated:completion:))){
            method_exchangeImplementations(presentM, presentSwizzlingM)
        }
    }
    
    //在自己实现中特殊处理
    @objc dynamic func temporary_present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Swift.Void)? = nil){
        if viewControllerToPresent.isKind(of: UIAlertController.self) {
            if let alertController = viewControllerToPresent as? UIAlertController{
                //通过判断title和message都为nil，得知是替换icon触发的提示。
                if alertController.title == nil && alertController.message == nil {
                    return;
                }
            }
        }
        
        self.temporary_present(viewControllerToPresent, animated: flag, completion: completion)
    }
}























