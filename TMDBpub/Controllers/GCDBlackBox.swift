//
//  GCDBlackBox.swift
//  FlickFinder

import Foundation

func performUIUpdatesOnMain(updates: @escaping () -> Void) {
    DispatchQueue.main.async {
        updates()
    }
//    dispatch_async(dispatch_get_main_queue()) {
//        updates()
//    }
}
