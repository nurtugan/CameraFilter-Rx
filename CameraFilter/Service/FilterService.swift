//
//  FilterService.swift
//  CameraFilter
//
//  Created by Nurtugan Nuraly on 9/24/20.
//  Copyright © 2020 XFamily, LLC. All rights reserved.
//

import UIKit
import CoreImage
import RxSwift

final class FilterService {
    private var context: CIContext
    
    init() {
        self.context = CIContext()
    }
    
    func applyFilter(to inputImage: UIImage) -> Observable<UIImage> {
        Observable.create { observer -> Disposable in
            let filter = CIFilter(name: "CICMYKHalftone")!
            filter.setValue(5.0, forKey: kCIInputWidthKey)
            guard let sourceImage = CIImage(image: inputImage) else { return Disposables.create() }
            filter.setValue(sourceImage, forKey: kCIInputImageKey)
            guard let cgImage = self.context.createCGImage(filter.outputImage!, from: filter.outputImage!.extent) else { return Disposables.create() }
            let processedImage = UIImage(cgImage: cgImage, scale: inputImage.scale, orientation: inputImage.imageOrientation)
            observer.onNext(processedImage)
            return Disposables.create()
        }
    }
}
