//
//  HomeCollectionViewCell.swift
//  TinyGrocery
//
//  Created by Bugra's Mac on 23.11.2020.
//

import UIKit

class HomeCollectionViewCell: UICollectionViewCell {
  
  // MARK: Properties
  
  /// Callback for Plus Button
  @objc public var stepperPlusPressed: (() -> Void)?
  /// Callback for Minus Button
  @objc public var stepperMinusPressed: (() -> Void)?
  
  // MARK: Outlets
  
  @IBOutlet weak var productImageView: UIImageView!
  @IBOutlet weak var productPriceLabel: UILabel!
  @IBOutlet weak var productNameLabel: UILabel!
  @IBOutlet weak var topStepperView: UIView!
  @IBOutlet weak var stockLabel: UILabel!
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    initStepperActions()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    
    initStepperActions()
  }
  /// Plus button for adding product to shopping basket
  let stepperPlusButton: UIButton = {
    let button = UIButton(type: UIButton.ButtonType.system)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.backgroundColor = .white
    button.setTitle("", for: .normal)
    button.setBackgroundImage(UIImage(systemName: "plus.app"), for: .normal)
    return button
  }()
  
  // Minus button for removing product from shopping basket
  let stepperMinusButton: UIButton = {
    let button = UIButton(type: UIButton.ButtonType.system)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.backgroundColor = .white
    button.setTitle("", for: .normal)
    button.setBackgroundImage(UIImage(systemName: "minus.square"), for: .normal)
    return button
  }()
  
  /// Count label for product
  let stepperLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  func initStepperActions() {
    addSubview(stepperPlusButton)
    addSubview(stepperMinusButton)
    addSubview(stepperLabel)
    
    // Plus button constraints
    contentView.rightAnchor.constraint(equalTo: stepperPlusButton.rightAnchor, constant: 4)
      .isActive = true
    stepperPlusButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8)
      .isActive = true
    
    // Stepper View label constraints
    stepperPlusButton.leadingAnchor.constraint(equalTo: stepperLabel.trailingAnchor ,constant: 8)
      .isActive = true
    stepperLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8)
      .isActive = true
    
    // Minus button constraints
    stepperLabel.leadingAnchor.constraint(equalTo: stepperMinusButton.trailingAnchor, constant: 8)
      .isActive = true
    stepperMinusButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8)
      .isActive = true
    
    // Button actions
    stepperPlusButton.addTarget(self, action: #selector(plusButtonPressed), for: .touchUpInside)
    stepperMinusButton.addTarget(self, action: #selector(minusButtonPressed), for: .touchUpInside)
  }
  
  @objc func plusButtonPressed() {
    stepperPlusPressed?()
  }
  
  @objc func minusButtonPressed() {
    stepperMinusPressed?()
  }
  
}
