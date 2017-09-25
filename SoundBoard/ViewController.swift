//
//  ViewController.swift
//  SoundBoard
//
//  Created by Connor Jennison on 9/22/17.
//  Copyright © 2017 Connor Jennison. All rights reserved.
//

import UIKit
import AVFoundation
var audioPlayer: AVAudioPlayer?

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var sounds: [Sound] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.dataSource = self
        tableView.delegate  = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do
        {
            try sounds = context.fetch(Sound.fetchRequest())
            tableView.reloadData()
        }
        catch{}
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sounds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let sound = sounds[indexPath.row]
        cell.textLabel?.text = sound.name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        do
        {
            let sound = sounds[indexPath.row]
            try audioPlayer = AVAudioPlayer(data: sound.audio! as Data)
            audioPlayer?.play()
        }
        catch{}
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete
        {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            
            let sound = sounds[indexPath.row]
            context.delete(sound)
            
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            
            do
            {
                try sounds = context.fetch(Sound.fetchRequest())
                tableView.reloadData()
            }
            catch{}
            
        }
    }
override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
}




}

