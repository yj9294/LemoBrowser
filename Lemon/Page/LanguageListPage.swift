//
//  LanguageListPage.swift
//  Lemon
//
//  Created by yangjian on 2023/9/23.
//

import UIKit

class LanguageListPage: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var didSelectHandle: ((Language)->Void)? = nil
    var language: Language
    var dataSource: [Language]
    
    init(_ language: Language, dataSource: [Language]) {
        self.language = language
        self.dataSource = dataSource
        super.init(nibName: "LanguageListPage", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "LanguageCell", bundle: .main), forCellReuseIdentifier: "LanguageCell")
    }
    
    @IBAction func back() {
        dismiss(animated: true)
    }

}

extension LanguageListPage: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LanguageCell", for: indexPath)
        if let cell = cell as? LanguageCell {
            cell.item = dataSource[indexPath.row]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectHandle?(dataSource[indexPath.row])
    }
}
