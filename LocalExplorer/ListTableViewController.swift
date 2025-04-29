//
//  ListTableViewController.swift
//  LocalExplorer
//

import UIKit
import CoreData

class ListTableViewController: UITableViewController {

    var locations: [NSManagedObject] = []
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()
        loadDataFromDatabase()
        self.navigationItem.leftBarButtonItem = self.editButtonItem
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadDataFromDatabase()
        tableView.reloadData()
    }

    func loadDataFromDatabase() {
        let settings = UserDefaults.standard
        let sortField = settings.string(forKey: Constants.kSortField)
        let sortAscending = settings.bool(forKey: Constants.kSortDirectionAscending)

        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSManagedObject>(entityName: "Location")

        let sortDescriptor = NSSortDescriptor(key: sortField, ascending: sortAscending)
        request.sortDescriptors = [sortDescriptor]

        do {
            locations = try context.fetch(request)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationsCell", for: indexPath)

        let location = locations[indexPath.row] as? Location
        cell.textLabel?.text = location?.locationName
        cell.detailTextLabel?.text = location?.city ?? ""
        cell.accessoryType = .detailDisclosureButton

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedLocation = locations[indexPath.row] as? Location
        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        if let controller = storyboard.instantiateViewController(withIdentifier: "MainController") as? MainViewController {
            controller.currentLocation = selectedLocation
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let location = locations[indexPath.row] as? Location
            let context = appDelegate.persistentContainer.viewContext

            if let locationToDelete = location {
                context.delete(locationToDelete)
                do {
                    try context.save()
                } catch {
                    fatalError("Error saving context after delete: \(error)")
                }

                loadDataFromDatabase()
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    }
}
