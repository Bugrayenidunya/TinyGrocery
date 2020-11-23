//
//  HomeController.swift
//  TinyGrocery
//
//  Created by Bugra's Mac on 22.11.2020.
//

import Kingfisher
import UIKit

class HomeController: UIViewController {
  
  // MARK: Properties
  
  /// Init viewModel
  private let viewModel = HomeViewModel()
  /// Badge Size for shopiing basket bar buttun item
  let badgeSize: CGFloat = 20
  /// All products from API call
  var products: [Product] = []
  /// Shopping Basket
  var shoppingBasket: [Product] = []
  /// Store only uniqe value from basket, for show on the basket's badge
  var uniqueProducts: Set<String> = []
  
  // MARK: Outlets
  
  @IBOutlet weak var basketBarButton: UIButton!
  @IBOutlet weak var collectionView: UICollectionView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    collectionView.delegate = self
    collectionView.dataSource = self
    
    navigationItem.title = "Tiny Grocery"
    navigationController?.navigationBar.prefersLargeTitles = true
    
    // Init functions
    loadAllProducts()
    showBadge(withCount: 0)
    configureCollectionViewLayout()
  }
  
  // MARK: Functions
  
  func loadAllProducts() {
    viewModel.fetchAllProducts { (result: Result <[Product], Error>) in
      switch result {
        case .success(let products):
          self.products = products
          self.collectionView.reloadData()
        case .failure(let error):
          print(error, #line, #file)
      }
    }
  }
  
  func configureCollectionViewLayout() {
    /// Create instance of CollectionViewFlowLayout
    let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    
    // set section inset
    layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    
    // set Minimum spacing between cells
    layout.minimumInteritemSpacing = 8
    
    // set minimum vertical line spacing between cells
    layout.minimumLineSpacing = 8
    
    // apply defined layout to collectionview
    collectionView.collectionViewLayout = layout
  }
  
  /// Create bacge label for shopping basket icon
  func badgeLabel(withCount count: Int) -> UILabel {
    let badgeCount = UILabel(frame: CGRect(x: 0, y: 0, width: badgeSize, height: badgeSize))
    
    badgeCount.translatesAutoresizingMaskIntoConstraints = false
    badgeCount.layer.cornerRadius = badgeCount.bounds.size.height / 2
    badgeCount.textAlignment = .center
    badgeCount.layer.masksToBounds = true
    badgeCount.textColor = .black
    badgeCount.font = badgeCount.font.withSize(12)
    badgeCount.backgroundColor = .white
    badgeCount.layer.borderWidth = 0.1
    badgeCount.layer.borderColor = UIColor.lightGray.cgColor
    badgeCount.text = String(count)
    
    return badgeCount
  }
  
  /// Show the badge on the shopping basket icon
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
    
  }
  
}

// MARK: - UICollectionViewDelegate

extension HomeController: UICollectionViewDelegate {
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    collectionView.deselectItem(at: indexPath, animated: false)
  }
  
}

// MARK: - UICollectionViewDataSource

extension HomeController: UICollectionViewDataSource {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return products.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    /// Single product
    let product = products[indexPath.row]
    /// Stock for check
    let stock = product.stock
    /// For adding the shopping basket
    var piece = 0
    /// Count every object in shopping basket
    var countOfEachProduct: [String:Int] = [:]
    
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constant.UI.homeCollectionViewCell, for: indexPath) as? HomeCollectionViewCell else  { return UICollectionViewCell() }
    
    // We set them to Hidden at first launch
    cell.stepperMinusButton.isHidden = true
    cell.stepperLabel.isHidden = true
    
    /// Storing Image Url for Kingfisher
    let imageUrl = URL(string: product.imageUrl)
    
    // Cell configurations
    cell.stepperLabel.textColor = UIColor.systemGreen
    cell.productImageView.kf.indicatorType = .activity
    cell.productImageView.kf.setImage(with: imageUrl, options: [.scaleFactor(UIScreen.main.scale), .transition(.fade(1)), .cacheOriginalImage])
    cell.productNameLabel.text = product.name
    cell.productPriceLabel.text = "\(product.currency)\(product.price)"
    
    cell.layer.cornerRadius = 4
    cell.layer.borderWidth = 0.25
    cell.layer.borderColor = UIColor.systemGray.cgColor
    
    // Plus Button Callback function
    cell.stepperPlusPressed = {
      cell.stepperLabel.isHidden = false
      cell.stepperMinusButton.isHidden = false
      // Check stock
      if piece < stock {
        piece += 1
        cell.stepperLabel.text = String(piece)
        // Add product to basket
        self.shoppingBasket.append(product)
        // Add each unique product to 'Set'
        for item in self.shoppingBasket {
          self.uniqueProducts.insert(item.id)
        }
      }
      self.showBadge(withCount: self.uniqueProducts.count)
    }
    
    // Minus Button Callback function
    cell.stepperMinusPressed = {
      // Collect each product's id and count frequency for the badge count
      countOfEachProduct = self.shoppingBasket.reduce(into: [:]) { $0[$1.id, default: 0] += 1 }
      // Check stock
      if piece <= stock && piece > 0 {
        piece -= 1
        cell.stepperLabel.text = String(piece)
        // Get index of selected product inside basket and remove
        if let index = self.shoppingBasket.firstIndex(where: { $0.id == product.id }) {
          self.shoppingBasket.remove(at: index)
        }
        if piece == 0 {
          cell.stepperLabel.isHidden = true
          cell.stepperMinusButton.isHidden = true
        }
        // Check unique procudt's count and remove
        if countOfEachProduct[product.id] == 1 {
          self.uniqueProducts.remove(product.id)
        }
        self.showBadge(withCount: self.uniqueProducts.count)
      }
    }
    
    return cell
  }
  
}

// MARK: - UICollectionViewDelegateFlowLayout

extension HomeController: UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
    /// How many rows will be in per row
    let numberOfCellsPerRow: CGFloat = 3
    /// Horizantal spacing between cells
    let spaceBetweenCells: CGFloat = 8
    /// Total calculated space per row
    let totalSpace = ((numberOfCellsPerRow - 1) * spaceBetweenCells) + 40
    /// Width of per cell
    let cellWidth = (collectionView.bounds.width - totalSpace) / numberOfCellsPerRow
    
    return CGSize(width: cellWidth, height: cellWidth * 1.75 )
  }
  
}
