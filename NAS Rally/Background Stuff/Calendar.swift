//
//  Calendar.swift
//  NAS Rally
//
//  Created by Peyton Ward on 6/2/26.
//

struct CalendarEvent {
    var eventName: String
    var eventDate: String
    var eventTime: String
    var eventLocation: String
    var eventDescription: String
    var eventImage: String
    var peopleGoing: Int
}

func getCalendarEvents() -> [CalendarEvent] {
    return []
}

func saveCalendarEvent(_ event: CalendarEvent) {
    // Will take in event with info, then format to an event making call
}
