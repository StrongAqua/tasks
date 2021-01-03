//
//  MainTasksTableViewController.swift
//  Tasks
//
//  Created by aprirez on 1/3/21.
//

import UIKit

class MainTasksTableViewController: UITableViewController {

    var rootTask: Task?
    var tasks: [Task] = []
    
    @IBOutlet weak var rootTaskDescription: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        // add '+' bar button item if rootTask is a CompositeTask - is able
        // to have subtasks
        if let rootTask = rootTask as? CompositeTask {
            rootTaskDescription.text = rootTask.description
            rootTaskDescription.delegate = self
            showAddButton()
        }
        
        // or add '+' bar button if no rootTsk set (first view)
        if rootTask == nil {
            showAddButton()
        }
        
        self.title = rootTask?.name ?? ""

        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        sizeHeaderToFit()
    }

    private func sizeHeaderToFit() {
        let headerView = tableView.tableHeaderView!
        var frame = headerView.frame

        if rootTask == nil {
            rootTaskDescription.text = ""
            frame.size.height = 0
        } else {
            let text = rootTask?.description ?? ""
            rootTaskDescription.text = text
            rootTaskDescription.sizeToFit()
            
            let height = rootTaskDescription.frame.height
            frame.size.height = height
        }

        headerView.frame = frame
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    func showAddButton() {
        let rightSearchBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addNewTask) )
        navigationItem.setRightBarButtonItems([rightSearchBarButtonItem], animated: true)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        guard let rootTask = rootTask as? CompositeTask else {return}
        rootTask.tasks = tasks
    }

    @objc func addNewTask() {
        tasks.append(CompositeTask(name: "Brand new task", description: CompositeTask.debugDescription))
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as? TaskCell else {return UITableViewCell()}

        cell.setup(task: tasks[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let tasksController =
            storyboard.instantiateViewController(withIdentifier: "TasksViewController") as? MainTasksTableViewController
        else {return}

        if let compositeTask = tasks[indexPath.row] as? CompositeTask {
            tasksController.rootTask = compositeTask
            tasksController.tasks = compositeTask.tasks
        }
        navigationController?.pushViewController(tasksController, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tasks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

}

extension MainTasksTableViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        rootTask?.description = textView.text ?? ""
    }
}
