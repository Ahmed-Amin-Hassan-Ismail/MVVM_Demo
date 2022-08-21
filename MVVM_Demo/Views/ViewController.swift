//
//  ViewController.swift
//  MVVM_Demo
//
//  Created by Ahmed Amin on 21/08/2022.
//

import UIKit

class ViewController: UIViewController {
    
    private let viewModel = UsersListViewModel()
    
    private let tableView: UITableView = {
       let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setup tableview
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        tableView.frame = view.bounds
        
        // bind with viewModel
        viewModel.userViewModel.bind { [weak self] _ in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        
        self.fetchUsersData()
    }


}

//MARK: - UItableView
extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
         return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.userViewModel.value?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = viewModel.userViewModel.value?[indexPath.row].name
        return cell
    }
}

//MARK: - Fetch Users Data
extension ViewController {
    private func fetchUsersData() {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/users") else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                let users = try JSONDecoder().decode([Users].self, from: data)
                self.viewModel.userViewModel.value = users.compactMap({
                    UsersTableViewCellViewModel(name: $0.name)
                })
            } catch {
                print("Error Location", error.localizedDescription)
            }
        }
        task.resume()
    }
}

