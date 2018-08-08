//
//  MainPageViewControllerDelegate.swift
//  TreeLibrary
//
//  Created by Mertalp Taşdelen on 8.08.2018.
//  Copyright © 2018 Mertalp Taşdelen. All rights reserved.
//

import UIKit

@objc

protocol MainPageViewControllerDelegate {
    @objc optional func openCameraScreen()
    @objc optional func collapseCameraScreen()
}
