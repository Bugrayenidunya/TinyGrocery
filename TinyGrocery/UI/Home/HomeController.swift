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
    
    // Set section inset
    layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 40, right: 20)
    
    // Set Minimum spacing between cells
    layout.minimumInteritemSpacing = 8
    
    // Set minimum vertical line spacing between cells
    layout.minimumLineSpacing = 8
    
    // Apply defined layout to collectionview
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
    badgeCount.font = .systemFont(ofSize: 14, weight: .medium)
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
    
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constant.UI.homeCollectionViewCell, for: indexPath) as? HomeCollectionViewCell else  { return UICollectionViewCell() }
    
    /// Storing Image Url for Kingfisher
    let imageUrl = URL(string: product.imageUrl)
    
    // Cell configurations
    cell.stepperLabel.textColor = UIColor.systemBlue
    cell.stepperLabel.font = .systemFont(ofSize: 17, weight: .medium)
    cell.productImageView.kf.indicatorType = .activity
    cell.productImageView.kf.setImage(with: imageUrl, options: [.scaleFactor(UIScreen.main.scale), .transition(.fade(1)), .cacheOriginalImage])
    cell.productNameLabel.text = product.name
    cell.productPriceLabel.text = "\(product.currency)\(product.price)"
    cell.stockLabel.text = String(stock)
    
    cell.layer.cornerRadius = 4
    cell.layer.borderWidth = 0.25
    cell.layer.borderColor = UIColor.systemGray.cgColor
    
    // Plus Button Callback function
    cell.stepperPlusPressed = { [self] in
      // Set visible
      cell.stepperLabel.isHidden = false
      cell.stepperMinusButton.isHidden = false
      /// Get count
      let productCount = viewModel.countProductInBasket(with: product.id)
      // Check stock
      if productCount < stock && productCount == 0 {
        // Add product to basket
        viewModel.shoppingBasket.append(product)
        /// Get count
        let productCount = viewModel.countProductInBasket(with: product.id)
        // Update new count
        cell.stepperLabel.text = String(productCount)
        // Add each unique product insert to 'Set' type
        for item in viewModel.shoppingBasket {
          viewModel.uniqueProducts.insert(item.id)
        }
      } else if productCount < stock && productCount > 0 {
        // Add product to basket
        viewModel.shoppingBasket.append(product)
        /// Get count
        let productCount = viewModel.countProductInBasket(with: product.id)
        // Update new count
        cell.stepperLabel.text = String(productCount)
      } else {
        // TODO: - Do This: Add Alert
      }
      self.showBadge(withCount: viewModel.uniqueProducts.count)
    } //: Plus Button
    
    // Minus Button Callback function
    cell.stepperMinusPressed = { [self] in
      /// Get count
      let productCount = viewModel.countProductInBasket(with: product.id)
      // Check stock
      if productCount <= stock {
        // Get index of selected product inside basket and remove
        if let index = viewModel.shoppingBasket.firstIndex(where: { $0.id == product.id }) {
          viewModel.shoppingBasket.remove(at: index)
        }
        /// Get count
        let productCount = viewModel.countProductInBasket(with: product.id)
        // Update new count
        cell.stepperLabel.text = String(productCount)
        // Check unique procudt's count and remove
        if productCount == 0 {
          viewModel.uniqueProducts.remove(product.id)
          cell.stepperLabel.isHidden = true
          cell.stepperMinusButton.isHidden = true
        }
        // Update Badge
        self.showBadge(withCount: viewModel.uniqueProducts.count)
        
      } else {
        cell.stepperLabel.isHidden = false
        cell.stepperLabel.isHidden = false
      }
    } //: Minus Button
    
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
    
    return CGSize(width: cellWidth, height: cellWidth * 2.5 )
  }
  
}
