//
//  HomeController.swift
//  TinyGrocery
//
//  Created by Bugra's Mac on 22.11.2020.
//

import UIKit

class HomeController: UIViewController {
  
  // MARK: Properties
  
  /// Badge Size for shopiing basket bar buttun item
  let badgeSize: CGFloat = 20
  
  // MARK: Outlets
  
  @IBOutlet weak var basketBarButton: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    showBadge(withCount: 0)
    navigationItem.title = "Tiny Grocery"
  }
  
  
  // MARK: Functions
  
  func badgeLabel(withCount count: Int) -> UILabel {
    let badgeCount = UILabel(frame: CGRect(x: 0, y: 0, width: badgeSize, height: badgeSize))
    
    badgeCount.translatesAutoresizingMaskIntoConstraints = false
    badgeCount.layer.cornerRadius = badgeCount.bounds.size.height / 2
    badgeCount.textAlignment = .center
    badgeCount.layer.masksToBounds = true
    badgeCount.textColor = .black
    badgeCount.font = badgeCount.font.withSize(10)
    badgeCount.backgroundColor = .white
    badgeCount.layer.borderWidth = 0.1
    badgeCount.layer.borderColor = UIColor.lightGray.cgColor
    badgeCount.text = String(count)
    
    return badgeCount
  }
  
  func showBadge(withCount count: Int) {
    let badge = badgeLabel(withCount: count)
    basketBarButton.addSubview(badge)
    // Constraints
    NSLayoutConstraint.activate([
      badge.leftAnchor.constraint(equalTo: basketBarButton.leftAnchor, constant: 32),
      badge.topAnchor.constraint(equalTo: basketBarButton.topAnchor, constant: 4),
      badge.widthAnchor.constraint(equalToConstant: badgeSize),
      badge.heightAnchor.constraint(equalToConstant: badgeSize)
    ])
  }
  
  // MARK: Actions
  
  @IBAction func basketButtonPressed(_ sender: UIButton) {
    print("pressed")
  }
  
}
