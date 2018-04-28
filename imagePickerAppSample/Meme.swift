//
//  Meme.swift
//  imagePickerAppSample
//
//  Created by Arnab Roy on 4/27/18.
//  Copyright © 2018 RoyInc. All rights reserved.
//

import Foundation
import UIKit

struct Meme {
    var topTextFieldText: String
    var bottomTextFieldText: String
    var originalImage: UIImage!
    var memImage: UIImage!
    

    init(topTextFieldText: String, bottomTextFieldText: String, originalImage: UIImage, memImage: UIImage) {
        self.topTextFieldText = topTextFieldText
        self.bottomTextFieldText = bottomTextFieldText
        self.originalImage = originalImage
        self.memImage = memImage
    }
}
