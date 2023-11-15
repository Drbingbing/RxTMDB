//
//  UIView+Extensions.swift
//  TMDBLibrary
//
//  Created by 鍾秉辰 on 2023/11/14.
//

import UIKit

private func swizzle(_ vc: UIViewController.Type) {
    [
        (#selector(vc.viewDidLoad), #selector(vc.tmdb_ViewDidLoad)),
        (#selector(vc.viewWillAppear(_:)), #selector(vc.tmdb_ViewWillAppear(_:)))
    ].forEach { original, swizzled in
        
        guard let originalMethod = class_getInstanceMethod(vc, original),
              let swizzledMethod = class_getInstanceMethod(vc, swizzled) else { return }
        
        let didAddViewDidLoadMethod = class_addMethod(
            vc,
            original,
            method_getImplementation(swizzledMethod),
            method_getTypeEncoding(swizzledMethod)
        )
        
        if didAddViewDidLoadMethod {
            class_replaceMethod(
                vc,
                swizzled,
                method_getImplementation(originalMethod),
                method_getTypeEncoding(originalMethod)
            )
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod)
        }
    }
}

private var hasSwizzled: Bool = false

extension UIViewController {
    
    public final class func doBadSwizzleStuff() {
        guard !hasSwizzled else { return }
        hasSwizzled = true
        swizzle(self)
    }
    
    @objc internal func tmdb_ViewDidLoad() {
        tmdb_ViewDidLoad()
        bindingViewModel()
        bindingUI()
    }
    
    @objc internal func tmdb_ViewWillAppear(_ animated: Bool) {
        tmdb_ViewWillAppear(animated)
        if !hasViewAppeared {
            bindStyles()
            hasViewAppeared = true
        }
    }
    
    @objc open func bindingViewModel() {}
    @objc open func bindStyles() {}
    @objc open func bindingUI() {}
    
    private struct AssociatedKeys {
        static var hasViewAppeared = "hasViewAppeared"
    }
    
    private var hasViewAppeared: Bool {
        get {
            withUnsafePointer(to: &AssociatedKeys.hasViewAppeared) {
                return objc_getAssociatedObject(self, $0) as? Bool ?? false
            }
        }
        set {
            withUnsafePointer(to: &AssociatedKeys.hasViewAppeared) {
                objc_setAssociatedObject(
                    self, 
                    $0,
                    newValue,
                    .OBJC_ASSOCIATION_RETAIN_NONATOMIC
                )
            }
        }
    }
}
