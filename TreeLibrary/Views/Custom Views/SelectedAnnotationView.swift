//
//  SelectedAnnotationView.swift
//  TreeLibrary
//
//  Created by Mertalp Taşdelen on 8.12.2018.
//  Copyright © 2018 Mertalp Taşdelen. All rights reserved.
//

import UIKit

class SelectedAnnotationView: UIView {

    @IBOutlet var contentView: SelectedAnnotationView!
    @IBOutlet weak var holder: UIView!
    @IBOutlet weak var latinNameTextField: UILabel!
    @IBOutlet weak var bothanicalPropertie: UITextView!
    @IBOutlet weak var leafType: UILabel!
    @IBOutlet weak var seedType: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit(){
        Bundle.main.loadNibNamed("SelectedAnnotationView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight,.flexibleWidth]
    }

    
    

}
