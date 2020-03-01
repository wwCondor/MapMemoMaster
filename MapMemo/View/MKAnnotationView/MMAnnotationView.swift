//
//  MMAnnotationView.swift
//  MapMemo
//
//  Created by Wouter Willebrands on 01/03/2020.
//  Copyright © 2020 Studio Willebrands. All rights reserved.
//

import UIKit
import MapKit

class MMAnnotationView: MKAnnotationView {
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        if view != nil {
            self.superview?.bringSubviewToFront(self)
        }
        return view
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let rectangle = self.bounds
        
        var isInside: Bool = rectangle.contains(point)
        if isInside != true {
            for view in self.subviews {
                isInside = view.frame.contains(point)
                if isInside {
                    break
                }
            }
        }
        return isInside
    }
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        configureView()
    }

    convenience init(viewController: UIViewController) {
        self.init()
    }
    
    private func configureView() {
        self.backgroundColor = .systemPink
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
