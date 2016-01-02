//
//  ColorSchemesViewController.swift
//  CI2Go
//
//  Created by Atsushi Nagase on 10/26/14.
//  Copyright (c) 2014 LittleApps Inc. All rights reserved.
//

import UIKit

class ColorSchemesViewController: UITableViewController {

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return ColorScheme().statusBarStyle()
    }

    private var _sectionIndexes: [String]?
    private var _sections: [[String]] = []
    var sectionIndexes: [String] {
        if !(_sectionIndexes?.count > 0) {
            buildSections()
        }
        return _sectionIndexes!
    }

    var sections: [[String]] {
        if !(_sections.count > 0) {
            buildSections()
        }
        return _sections
    }

    private func buildSections() {
        _sectionIndexes = [String]()
        _sections = [[String]]()
        var section: [String]?
        for name in ColorScheme.names {
            let fchar = name.substringToIndex(name.startIndex.advancedBy(1))
            if (_sectionIndexes!).indexOf(fchar) == nil {
                _sectionIndexes?.append(fchar)
                if section != nil {
                    _sections.append(section!)
                }
                section = [String]()
            }
            section!.append(name)
        }
        _sections.append(section!)
    }

    override func viewWillAppear(animated: Bool) {
        let name = ColorScheme().name
        guard let fchar = name.characters.first else {
            return
        }
        let str = String(fchar)
        let section = sectionIndexes.indexOf(str)
        if section != nil {
            let row = sections[section!].indexOf(name)
            if row != nil {
                let indexPath = NSIndexPath(forRow: row!, inSection: section!)
                tableView.selectRowAtIndexPath(indexPath, animated: false, scrollPosition: UITableViewScrollPosition.Top)
                tableView.deselectRowAtIndexPath(indexPath, animated: false)
            }
        }
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        let tracker = GAI.sharedInstance().defaultTracker
        tracker.set(kGAIScreenName, value: "ColorScheme Screen")
        tracker.send(GAIDictionaryBuilder.createScreenView().build() as [NSObject : AnyObject])
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sectionIndexes.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell")! as! ColorSchemeTableViewCell
        cell.colorSchemeName = sections[indexPath.section][indexPath.row]
        return cell
    }

    override func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
        return sectionIndexes
    }

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionIndexes[section]
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let item = sections[indexPath.section][indexPath.row]
        ColorScheme(item)?.apply()
        let tracker = GAI.sharedInstance().defaultTracker
        let dict = GAIDictionaryBuilder.createEventWithCategory("settings", action: "color-scheme-change", label: item, value: 1).build() as [NSObject : AnyObject]
        tracker.send(dict)
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
}
