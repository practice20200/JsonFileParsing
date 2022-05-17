//
//  ViewController.swift
//  FileParsingJSON
//
//  Created by Apple New on 2022-05-16.
//

import UIKit

class ViewController: UIViewController {
    
    var result : Result?
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        parseJSON()
        
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        tableView.frame = view.bounds
    }

    private func parseJSON(){
        guard let path = Bundle.main.path(forResource: "data", ofType: "json") else { return }
                
        let url = URL(fileURLWithPath: path)
        
        
        do {
            let jsonData = try Data(contentsOf: url)
            result = try  JSONDecoder().decode(Result.self, from:  jsonData)
            
//            if let result = result {
//                print("reslt: \(result)")
//            }else {
//                print("Failed to parse")
//            }
            
        }catch{
            print("Error: \(error.localizedDescription)")
        }
    }

}


struct Result: Codable {
    let data: [ResultItem]
}

struct ResultItem: Codable {
    let title: String
    let items: [String]
}


extension ViewController: UITableViewDelegate {
    
}

extension ViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return result?.data[section].items.count ?? 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return result?.data.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let item = result?.data[indexPath.section].items[indexPath.row]
        cell.textLabel?.text = item
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return result?.data[section].title
    }
    
}
