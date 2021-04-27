//
//  CollectionViewController.swift
//  metronome
//
//  Created by Egor on 1/22/20.
//  Copyright © 2020 Egor. All rights reserved.
//

import UIKit

// MARK: - Main

class CollectionViewController: UICollectionViewController {

  // MARK: - Initialization

  var presenter: CollectionPresenterProtocol?

  override func viewDidLoad() {
    super.viewDidLoad()

    setupCollection()
    setupDelegates()
  }

  // MARK: - Public

  @objc func close(_ sender: UIButton) {
    let cell = sender.superview?.superview as! CollectionCell

    presenter?.selectCell(withIndex: cell.index)

    dismiss(animated: true)
  }

  override func collectionView(_ collectionView: UICollectionView,
                               numberOfItemsInSection section: Int) -> Int {
    return presenter?.getNumberOfCells() ?? 0
  }

  override func collectionView(_ collectionView: UICollectionView,
                               cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionCell.reuseID,
                                                        for: indexPath) as? CollectionCell else {
      fatalError("Wrong cell")
    }

    setupCell(cell, withIndex: indexPath.row)
    return cell
  }

  // MARK: - Private

  private func setupCollection() {
    collectionView.register(CollectionCell.nib, forCellWithReuseIdentifier: CollectionCell.reuseID)
  }

  private func setupDelegates() {
    collectionView.dataSource = self
    collectionView.delegate = self
  }

  private func setupCell(_ cell: CollectionCell, withIndex index: Int) {
    let image = UIImage(named: presenter?.getImageName(forIndex: index) ?? GlobalSettings.STRING_OF_NILDATA)
    cell.soundButton.setBackgroundImage(image, for: .normal)
    cell.soundButton.addTarget(self, action: #selector(close), for: .touchUpInside)
    cell.index = index
  }

}

// MARK: - Extensions

extension CollectionViewController: CollectionViewProtocol {
  func updateCollection() {
    collectionView.reloadData()
  }
}

extension CollectionViewController: UICollectionViewDelegateFlowLayout {
  override func collectionView(_ collectionView: UICollectionView,
                               shouldSelectItemAt indexPath: IndexPath) -> Bool {
    return true
  }

  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: 100, height: 100)
  }
}
