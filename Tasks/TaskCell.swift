//
//  TaskCell.swift
//  Tasks
//
//  Created by aprirez on 1/3/21.
//

import UIKit

class TaskCell: UITableViewCell {

    @IBOutlet weak var taskName: UITextField!
    @IBOutlet weak var subtaskCounter: UILabel!
    
    var task: Task?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func onEndEditing(_ sender: Any) {
        taskName.isUserInteractionEnabled = false
        task?.name = taskName.text ?? ""
    }
    
    @IBAction func editTitle(_ sender: Any) {
        taskName.isUserInteractionEnabled = true
        taskName.becomeFirstResponder()
        taskName.keyboardType = UIKeyboardType.default // hack to show keyboard
        taskName.delegate = self
    }

    func setup(task: Task) {
        taskName.borderStyle = .none
        self.task = task
        taskName.text = task.name
        subtaskCounter.text = "Subtasks: \(task.subtasksCount())"
    }

}

extension TaskCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textView: UITextField) -> Bool {
        textView.resignFirstResponder()
        return true
    }
}
