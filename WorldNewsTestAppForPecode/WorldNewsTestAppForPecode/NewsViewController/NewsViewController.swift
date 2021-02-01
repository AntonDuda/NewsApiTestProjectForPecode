//
//  NewsViewController.swift
//  WorldNewsTestAppForPecode
//
//  Created by Anton on 30.01.2021.
//

import UIKit
import WebKit

class NewsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating, WKNavigationDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Vars
    
    private var allArticles: [Article] = []
    private var allViewModels: [ArticleViewModel] = []
    
    private var searchArticles: [Article] = []
    private var searchViewModels: [ArticleViewModel] = []
    
    private let apiManager = APIManager()
    
    private let searchController: UISearchController = {
        let ctrl = UISearchController(searchResultsController: nil)
        ctrl.obscuresBackgroundDuringPresentation = false
        ctrl.searchBar.placeholder = "Search Articles"
        return ctrl
    }()
    
    private var articles: [Article] { isSearching ? searchArticles : allArticles }
    private var viewModels: [ArticleViewModel] { isSearching ? searchViewModels : allViewModels }
    
    private var isSearchBarEmpty: Bool { searchController.searchBar.text?.isEmpty ?? true }
    private var isSearching: Bool { searchController.isActive && !isSearchBarEmpty }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createSpinnerView()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        view.backgroundColor = .lightGray

        tableView.register(UINib(nibName: "CustomTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        
        searchController.searchResultsUpdater = self
        
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        loadNewsData()
    }
    
    // MARK: Private methods
    
    private func createSpinnerView() {
        let child = SpinnerViewController()

        addChild(child)
        child.view.frame = view.frame
        view.addSubview(child.view)
        child.didMove(toParent: self)

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            child.willMove(toParent: nil)
            child.view.removeFromSuperview()
            child.removeFromParent()
        }
    }
    
    private func loadNewsData() {
        apiManager.articles { [weak self] (articles) -> Void in
            guard let sself = self else { return }
            
            sself.allArticles = articles
            sself.allViewModels = sself.makeViewModels(articles: articles)
            
            DispatchQueue.main.async {
                sself.tableView.reloadData()
            }
        }
    }
    
    private func makeViewModels(articles: [Article]) -> [ArticleViewModel] {
        return articles.compactMap {
            
            var urlToImage: URL?
            if let url = $0.urlToImage {
                urlToImage = URL(string: url)
            }
            
            return .init(
                source: $0.source.name ,
                title: $0.title,
                description: $0.description,
                author: $0.author,
                urlToImage: urlToImage,
                url: $0.url
            )
        }
    }
    
    // MARK: UISearchResultsUpdating
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        
        apiManager.search(word: searchText) { [weak self] (articles) -> Void in
            guard let sself = self else { return }
            
            sself.searchArticles = articles
            sself.searchViewModels = sself.makeViewModels(articles: articles)
            
            DispatchQueue.main.async {
                sself.tableView.reloadData()
            }
        }
    }
    
    // MARK: UITableViewDataSource
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 350
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? CustomTableViewCell else {
            fatalError("NewsCollectionViewCell is not registered!")
        }
        let row = viewModels[indexPath.row]
        cell.setup(article: row)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard
            let articleUrl = articles[indexPath.row].url,
            let url = URL(string: articleUrl) else {
            return
        }
        let webVc = WKWebViewController()
        webVc.url = url
        self.navigationController?.pushViewController(webVc, animated: true)
        print("cell did selected\(url)")
    }
    
}
