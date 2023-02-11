//
//  ViewController.swift
//  Proto File RW plus Firestore
//
//  Created by Santosh Krishnamurthy on 1/30/23.
//

import UIKit

class ViewController: UIViewController {

    // Sample Dict
    let dictionary: [String: Any] = ["bar": "qux", "baz": 42]
    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var readButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    @IBAction func readButtonPressed(_ sender: UIButton) {
        print("Read btn pressed")
        
        readJSONFileFromProjectFolder()
        
    }
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        debugPrint("save Btn pressed")
        
        saveJSONFileToTempFolder()
        
    }
    //MARK: - Write JSON file into File System
    
    func saveJSONFileToTempFolder() -> Void {
        // Saving dict into a JSON file in Application support Dir
        do {
            // use temporaryDirectory to get Path to temporary Dir
            let dir = FileManager.default.temporaryDirectory
            debugPrint(dir)
            let fileURL = dir.appendingPathComponent("example.json")
            debugPrint(fileURL)

            try JSONSerialization.data(withJSONObject: dictionary)
                .write(to: fileURL)
        } catch {
            print(error)
        }
    }
    
    //MARK: - Read JSON file from File System
    
    func readJSONFileFromAppSupportFolder(){
        do{
            // Returns Dir path as URL object
            // use .applicationSupportDirectory to get path to /Library/Application Support
            // use .cachesDirectory to get path to /Library/Caches Dir
            // use .documentDirectory to get path to /Library/Documents Dir
            let dirURL = try FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            // append file name to Dir Path
            let fileURL = dirURL.appending(path: "example.json")
            print(fileURL)
            
            
            // Read file contents into Data object
            let fileData = try Data(contentsOf: fileURL)
            
            
            // Create instance of JSON decoder
            let decoder = JSONDecoder()
            //
            let sample = try decoder.decode(Example.self, from: fileData)
            debugPrint(sample)
            
        } catch {
            print ("error reading file - \(error)")
        }
    }
    
    func readJSONFileFromProjectFolder(){
        // Reading the contents of a file in Project Folder
        let filePath = Bundle.main.path(forResource: "us-state-capitals", ofType: "json")
        print(filePath!)
        
        
        do{
            // Reading file contents into a string object
            let fileString = try String(contentsOfFile: filePath!, encoding: String.Encoding.utf8)
            // print(fileString)
            // converting String into Data object
            let dataNew = fileString.data(using: .utf8)
            debugPrint(dataNew!)
            
            // Reading file contents into a Data object
            let data = try Data(contentsOf: URL(filePath: filePath!))
            debugPrint(data)
            
            // Decode JSON in Data object into decodable custom type
            
            let decoder = JSONDecoder()
            let quizData = try decoder.decode(Quiz.self, from: data)
            debugPrint(quizData)
            
        } catch {
            print("Error reading file - \(error)")
        }
    }
    
}

