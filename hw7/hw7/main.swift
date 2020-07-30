//
//  main.swift
//  hw7
//
//  Created by aprirez on 7/19/20.
//  Copyright © 2020 Alla. All rights reserved.
//

import Foundation

class Song {
    let musician : String
    let songName : String
    let releaseYear: Int
    init(musician: String, songName: String, releaseYear: Int) {
        self.musician = musician
        self.songName = songName
        self.releaseYear = releaseYear
    }
}

enum DJState {
    case onPlace, outPlace
}

enum DJMood {
    case fine, bad
}

enum DJClubError: Error {
    
    case invalidSelection
    case DJOutPlace
    case DJMoodISBad
}
    
class DJClub {
    
    var musicLibrary = [
        Song(musician: "Maitre Gims & Sting", songName: "Reste", releaseYear: 2020),
        Song(musician: "Charli XCX feat. Lizzo", songName: "Blame It On Your Love", releaseYear: 2019),
        Song(musician: "The Weekend", songName: "In Your Eyes", releaseYear: 2020)
    ]
    
    var djState: DJState
    var djMood: DJMood
    
    init() {
        self.djState = .onPlace
        self.djMood = .fine
    }
    
    func changeDJStateOut() {
        djState = .outPlace
    }
    func changeDJStateOn() {
        djState = .onPlace
    }
    func changeDJMoodFine() {
        djMood = .fine
    }
    func changeDJMoodBad() {
        djMood = .bad
    }
    
    func searchSongByName(songName: String) -> Song? {
        for song in musicLibrary {
            if song.songName == songName {
                return song
            }
        }
        return nil
        
    }
    
    func askDJSetTheSong(songName: String) -> (Song?, DJClubError?) {
        print("Диджей! Поставь \(songName)")
        guard let song = searchSongByName(songName: songName) else {
            return (nil, DJClubError.invalidSelection)
        }
        
        guard djState == .onPlace else {
            return (song, DJClubError.DJOutPlace)
        }
        
        guard djMood == .fine else {
            return (song, DJClubError.DJMoodISBad)
        }
        return (song, nil)
    }
}

let djClub = DJClub()

func checkResult(response: (Song?, DJClubError?)) {
    if let error = response.1 {
        if let song = response.0 {
            print("Просим поставить песню: \(song.songName)\nПроизошла ошибка: \(error.localizedDescription)")
        } else {
            print("У диджея нет такого компакт диска!\nПроизошла ошибка: \(error.localizedDescription)")
        }
    } else if let song = response.0 {
        print("Звучит песня: \(song.songName)")
    }
}

checkResult(response: djClub.askDJSetTheSong(songName: "In Your Eyes"))
print("\n")
checkResult(response: djClub.askDJSetTheSong(songName: "Romashki"))

print("\n")
_ = djClub.changeDJMoodBad()
print("Настроение DJ:", djClub.djMood)
checkResult(response: djClub.askDJSetTheSong(songName: "In Your Eyes"))


//---------------------

extension DJClub {
    func askDJSetTheSongT(songName: String) throws -> Song {
        guard let song = searchSongByName(songName: songName) else {
            throw DJClubError.invalidSelection
        }
        guard djState == .onPlace else {
           throw DJClubError.DJOutPlace
        }
        guard djMood == .fine else {
            throw DJClubError.DJMoodISBad
            
        }
        return song
    }
}

func askForSong(songName: String) {
    do {
        _ = try djClub.askDJSetTheSongT(songName: songName)
    } catch DJClubError.invalidSelection {
        print("Такой песни нет в нашей библиотеке")
    } catch DJClubError.DJOutPlace {
        print("DJ не на месте, подождите он скоро вернется")
    } catch DJClubError.DJMoodISBad {
        print("У DJ плохое настроение, угостите его")
    } catch let error {
        print(error.localizedDescription)
    }
}
print("\n")
askForSong(songName: "In Your Eyes")
