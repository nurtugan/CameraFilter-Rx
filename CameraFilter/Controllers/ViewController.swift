//
//  ViewController.swift
//  CameraFilter
//
//  Created by Nurtugan Nuraly on 9/23/20.
//  Copyright © 2020 XFamily, LLC. All rights reserved.
//

import UIKit
import RxSwift

final class ViewController: UIViewController {
    @IBOutlet private weak var photoImageView: UIImageView!
    @IBOutlet private weak var applyFilterButton: UIButton!
    
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let navC = segue.destination as? UINavigationController,
            let photosCVC = navC.viewControllers.first as? PhotosCollectionViewController else {
                fatalError("Segue destination is not found")
        }
        photosCVC.selectedPhoto
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { photo in
                self.updateUI(with: photo)
            }).disposed(by: disposeBag)
    }

    @IBAction private func applyFilter(_ sender: UIButton) {
        guard let sourceImage = photoImageView.image else { return }
        FilterService().applyFilter(to: sourceImage)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { filteredImage in
                self.photoImageView.image = filteredImage
            }).disposed(by: disposeBag)
    }

    private func updateUI(with image: UIImage) {
        photoImageView.image = image
        applyFilterButton.isHidden = false
    }
}
