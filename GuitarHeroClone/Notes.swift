import SwiftUI

// Fixed X-coordinates for note lanes
let notePositions: [CGFloat] = [50, 176, 306, 438]
let noteColors: [Color] = [.red, .blue, .yellow, .green]


struct Note: Identifiable {
    let id = UUID()
    var x: CGFloat
    var y: CGFloat
    var speed: CGFloat
    var waveID: UUID // Tracks which wave this note belongs to
    var xIndex: Int  // Tracks which lane (1-4)
}

// Function to convert musical notes to MIDI values
func note(_ note: String, _ octave: Int) -> UInt8 {
    let offsets: [String: Int] = [
        "C": 0, "C#": 1, "Db": 1, "D": 2, "D#": 3, "Eb": 3,
        "E": 4, "F": 5, "F#": 6, "Gb": 6, "G": 7, "G#": 8, "Ab": 8,
        "A": 9, "A#": 10, "Bb": 10, "B": 11
    ]
    guard let offset = offsets[note] else { fatalError("Invalid note name: \(note)") }
    return UInt8(12 + 12 * octave + offset)
}

let bohemian: [(id: UUID, keys: [Int], noteDuration: Double, midiNotes: [UInt8], semitoneBend: Int)] = [
    (UUID(), [1], 2.5, [note("Bb", 4)], 0), 
    (UUID(), [3], 1.5, [note("G", 5)], 0), 
    (UUID(), [2], 0.25, [note("F", 5)], 0), 
    (UUID(), [1], 0.25, [note("Eb", 5)], 0), 
    (UUID(), [4], 3.0, [note("Bb", 5)], 0), 
    (UUID(), [3], 1.0, [note("G", 5)], 0), 
    (UUID(), [1], 4.0, [note("C", 6)], 0), 

    (UUID(), [1], 1.0, [note("C", 6)], 0), 
    (UUID(), [2], 0.5, [note("D", 6)], 0), 
    (UUID(), [3], 0.5, [note("Eb", 6)], 0), 
    (UUID(), [1], 1.0, [note("C", 6)], 0), 
    (UUID(), [2], 0.5, [note("D", 6)], 0), 
    (UUID(), [3], 0.5, [note("Eb", 6)], 0), 
    (UUID(), [4], 4.0, [note("F", 6)], 0), 

    (UUID(), [4], 0.5, [note("F", 6)], 0), 
    (UUID(), [1], 0.5, [note("G", 6)], 0), 
    (UUID(), [2], 0.5, [note("Ab", 6)], 0), 
    (UUID(), [3], 0.5, [note("Bb", 6)], 0), 
    (UUID(), [4], 2, [note("C", 7)], 0), 

    (UUID(), [3], 0.5, [note("Bb", 6)], 0),  // Complex passage
    (UUID(), [2], 0.5, [note("Ab", 6)], 0), 

    (UUID(), [1], 1/3, [note("G", 6)], 0), 
    (UUID(), [2], 1/3, [note("Ab", 6)], 0), 
    (UUID(), [1], 1/6, [note("G", 6)], 0), 
    (UUID(), [2], 1/6, [note("Ab", 6)], 0), 

    (UUID(), [1], 0.25, [note("G", 6)], 0), 
    (UUID(), [4], 0.25, [note("F", 6)], 0), 
    (UUID(), [1], 0.25, [note("G", 6)], 0), 
    (UUID(), [4], 0.25, [note("F", 6)], 0), 

    (UUID(), [3], 1/3, [note("Eb", 6)], 0), 
    (UUID(), [2], 1/3, [note("D", 6)], 0), 
    (UUID(), [3], 1/3, [note("Eb", 6)], 0), 

    (UUID(), [2], 1/6, [note("D", 6)], 0), 
    (UUID(), [3], 1/6, [note("Eb", 6)], 0), 
    (UUID(), [2], 1/3, [note("D", 6)], 0), 
    (UUID(), [1], 1/3, [note("C", 6)], 0), 

    (UUID(), [2], 0.25, [note("D", 6)], 0), 
    (UUID(), [1], 0.25, [note("C", 6)], 0), 
    (UUID(), [4], 2.5, [note("Bb", 5)], 0),  // End of complex passage

    (UUID(), [4], 2/3, [note("Bb", 5)], 0),  // Triplet run 1
    (UUID(), [4], 2/3, [note("Bb", 5)], 0), 

    (UUID(), [1], 1/3, [note("C", 6)], 0), 
    (UUID(), [2], 1/3, [note("D", 6)], 0), 

    (UUID(), [3], 1/3, [note("Eb", 6)], 0), 
    (UUID(), [4], 1/3, [note("F", 6)], 0), 
    (UUID(), [1], 1/3, [note("G", 6)], 0), 

    (UUID(), [2], 1/3, [note("Ab", 6)], 0), 
    (UUID(), [3], 1, [note("Bb", 6)], 0),  // End of triplet run 1


    (UUID(), [4], 1/3, [note("Bb", 6)], 0),  // Triplet run 2
    (UUID(), [1], 1/3, [note("C", 6)], 0), 

    (UUID(), [2], 1/3, [note("D", 6)], 0), 
    (UUID(), [3], 1/3, [note("Eb", 6)], 0), 
    (UUID(), [4], 1/3, [note("F", 6)], 0), 

    (UUID(), [1], 1/3, [note("G", 6)], 0), 
    (UUID(), [2], 1/3, [note("Ab", 6)], 0), 
    (UUID(), [3], 1/3, [note("Bb", 6)], 0), 
    (UUID(), [4], 4, [note("C", 7)], 0),  // End of triplet run 2


    (UUID(), [2], 0.5, [note("D", 6)], 0), 
    (UUID(), [3], 0.5, [note("Eb", 6)], 0), 
    (UUID(), [1], 1, [note("C", 6)], 0), 

    (UUID(), [2], 0.5, [note("D", 6)], 0), 
    (UUID(), [3], 0.5, [note("Eb", 6)], 0), 
    (UUID(), [1], 1, [note("C", 6)], 0), 
    (UUID(), [2], 0.5, [note("D", 6)], 0), 
    (UUID(), [3], 0.5, [note("Eb", 6)], 0), 
    (UUID(), [4], 3, [note("F", 6)], 0), 

    (UUID(), [4], 0.5, [note("F", 5)], 0), 
    (UUID(), [1], 0.5, [note("G", 5)], 0), 
    (UUID(), [2], 2, [note("Ab", 5)], 0), 
    (UUID(), [4], 2, [note("F", 6)], 0), 

    (UUID(), [2], 7/3 + 0.07, [note("Ab", 5)], 0), 
    (UUID(), [4], 2/3, [note("Db", 6)], 0), 
    (UUID(), [4], 2/3, [note("Db", 6)], 0), 
    (UUID(), [4], 2-0.07, [note("Db", 6)], 0), 
    (UUID(), [2], 2, [note("Db", 5)], 0), 
    (UUID(), [1], 1, [note("A", 4)], 0), 
]


let c = 1.0415

let teen_spirit: [(id: UUID, keys: [Int], noteDuration: Double, midiNotes: [UInt8], semitoneBend: Int)] = [
    (UUID(), [2], 0.5, [note("F", 3)], 0),  // Add fifths for chords
    (UUID(), [2], 0.5, [note("F", 3)], 0), 
    (UUID(), [1], 0.5, [note("E", 3)], 0), 
    (UUID(), [2], 0.5, [note("F", 3)], 0), 
    (UUID(), [3], 0.5, [note("F#", 3)], 0), 
    (UUID(), [3], 0.5, [note("F#", 3)], 0), 
    (UUID(), [1], 1, [note("C", 4)], 0), 

    (UUID(), [2], 0.5, [note("F", 3)], 0), 
    (UUID(), [2], 0.5, [note("F", 3)], 0), 
    (UUID(), [1], 0.5, [note("E", 3)], 0), 
    (UUID(), [2], 0.5, [note("F", 3)], 0), 
    (UUID(), [3], 0.5, [note("Bb", 3)], 0), 
    (UUID(), [3], 0.5, [note("Bb", 3)], 0), 
    (UUID(), [2], 0.5, [note("Ab", 3)], 0), 
    (UUID(), [2], 0.5, [note("Ab", 3)], 0), 
    (UUID(), [1], 1, [note("F", 3)], 0), 


    (UUID(), [2], 0.5, [note("C", 5)], 0),  // Main theme
    (UUID(), [3], 1, [note("Eb", 5)], 0), 
    (UUID(), [4], 1, [note("F", 5)], 0), 
    (UUID(), [1], 1.5, [note("Ab", 4)], 0), 
    (UUID(), [3], 0.5, [note("Eb", 5)], 0), 
    (UUID(), [4], 1, [note("F", 5)], 0), 
    (UUID(), [3], 0.5, [note("Eb", 5)], 0), 
    (UUID(), [2], 0.5, [note("Db", 5)], 0), 
    (UUID(), [1], 1.5, [note("C", 5)], 0), 
   
    (UUID(), [2], 0.5, [note("Db", 5)], 0), 
    (UUID(), [1], 1, [note("C", 5)], 0), 
    (UUID(), [4], 1, [note("Bb", 4)], 0), 
    (UUID(), [3], 1.5, [note("Ab", 4)], 0), 
    (UUID(), [4], 0.5, [note("Bb", 4)], 0), 
    (UUID(), [1], 1, [note("C", 5)], 0), 
    (UUID(), [4], 0.5, [note("Bb", 4)], 0), 
    (UUID(), [3], 0.5, [note("Ab", 4)], 0), 
    (UUID(), [1], 1.5, [note("G", 4)], 0), 
   
    (UUID(), [2], 0.5, [note("C", 5)], 0),  // Repeat
    (UUID(), [3], 1, [note("Eb", 5)], 0), 
    (UUID(), [4], 1, [note("F", 5)], 0), 
    (UUID(), [1], 1.5, [note("Ab", 4)], 0), 
    (UUID(), [3], 0.5, [note("Eb", 5)], 0), 
    (UUID(), [4], 1, [note("F", 5)], 0), 
    (UUID(), [3], 0.5, [note("Eb", 5)], 0), 
    (UUID(), [2], 0.5, [note("Db", 5)], 0), 
    (UUID(), [1], 1.5, [note("C", 5)], 0), 
   
    (UUID(), [2], 0.5, [note("Db", 5)], 0), 
    (UUID(), [1], 1, [note("C", 5)], 0), 
    (UUID(), [4], 1, [note("Bb", 4)], 0), 
    (UUID(), [3], 1.5, [note("Ab", 4)], 0), 
    (UUID(), [4], 0.5, [note("Bb", 4)], 0), 
    (UUID(), [1], 1, [note("C", 5)], 0), 
    (UUID(), [4], 0.5, [note("Bb", 4)], 0), 
    (UUID(), [3], 0.5, [note("Ab", 4)], 0), 
    (UUID(), [2], 1.5, [note("G", 4)], 0), 

    (UUID(), [3], 0.5, [note("Ab", 4)], 0),  // Theme 2
    (UUID(), [2], 1.5, [note("G", 4)], 0), 
    (UUID(), [3], 0.5, [note("Ab", 4)], 0), 
    (UUID(), [2], 1.5, [note("G", 4)], 0), 
    (UUID(), [3], 0.5, [note("Ab", 4)], 0), 
    (UUID(), [2], 1, [note("G", 4)], 0), 
    (UUID(), [3], 0.5, [note("Ab", 4)], 0), 
    (UUID(), [2], 0.5, [note("G", 4)], 0), 
    (UUID(), [2], 0.5, [note("G", 4)], 0), 
    (UUID(), [1], 1, [note("F", 4)], 0), 
   
    (UUID(), [3], 0.5, [note("Ab", 4)], 0),  // 2
    (UUID(), [2], 1.5, [note("G", 4)], 0), 
    (UUID(), [3], 0.5, [note("Ab", 4)], 0), 
    (UUID(), [2], 1.5, [note("G", 4)], 0), 
    (UUID(), [3], 0.5, [note("Ab", 4)], 0), 
    (UUID(), [2], 1, [note("G", 4)], 0), 
    (UUID(), [3], 0.5, [note("Ab", 4)], 0), 
    (UUID(), [2], 0.5, [note("G", 4)], 0), 
    (UUID(), [2], 0.5, [note("G", 4)], 0), 
    (UUID(), [1], 1, [note("F", 4)], 0), 
   
    (UUID(), [3], 0.5, [note("Ab", 4)], 0),  // 3
    (UUID(), [2], 1.5, [note("G", 4)], 0), 
    (UUID(), [3], 0.5, [note("Ab", 4)], 0), 
    (UUID(), [2], 1.5, [note("G", 4)], 0), 
    (UUID(), [3], 0.5, [note("Ab", 4)], 0), 
    (UUID(), [2], 1, [note("G", 4)], 0), 
    (UUID(), [3], 0.5, [note("Ab", 4)], 0), 
    (UUID(), [2], 0.5, [note("G", 4)], 0), 
    (UUID(), [2], 0.5, [note("G", 4)], 0), 
    (UUID(), [1], 1, [note("F", 4)], 0), 
   
    (UUID(), [3], 0.5, [note("Ab", 4)], 0),  // 4
    (UUID(), [2], 1.5, [note("G", 4)], 0), 
    (UUID(), [3], 0.5, [note("Ab", 4)], 0), 
    (UUID(), [2], 1.5, [note("G", 4)], 0), 
    (UUID(), [3], 0.5, [note("Ab", 4)], 0), 
    (UUID(), [2], 1, [note("G", 4)], 0), 
    (UUID(), [3], 0.5, [note("Ab", 4)], 0), 
    (UUID(), [2], 0.5, [note("G", 4)], 0), 
    (UUID(), [2], 1.5, [note("G", 4)], 0),  // should be 0.5 but adding to 1.5 for dramatic effect before final chord
    (UUID(), [1, 2], 8, [note("F", 3), note("C", 4), note("F", 4)], 4),
    (UUID(), [1, 2], 8, [note("F", 3), note("C", 4), note("F", 4)], -4),
]
let debug_pitch_bend: [(id: UUID, keys: [Int], noteDuration: Double, midiNotes: [UInt8], semitoneBend: Int)] = [
    (UUID(), [1, 2], 8, [note("F", 3), note("C", 4), note("F", 4)], -4),
    (UUID(), [1, 2], 8, [note("F", 3), note("C", 4), note("F", 4)], -4),
    (UUID(), [1, 2], 8, [note("F", 3), note("C", 4), note("F", 4)], -4),
    (UUID(), [1, 2], 8, [note("F", 3), note("C", 4), note("F", 4)], -4),
    (UUID(), [1, 2], 8, [note("F", 3), note("C", 4), note("F", 4)], -4),
    (UUID(), [1, 2], 8, [note("F", 3), note("C", 4), note("F", 4)], -4),
]



let time_floyd: [(id: UUID, keys: [Int], noteDuration: Double, midiNotes: [UInt8], semitoneBend: Int)] = [
    (UUID(), [1], 6.5, [note("F#", 4)], -4),  // Phrase 1
    (UUID(), [3], 0.7, [note("C#", 5)], 0),
    (UUID(), [2], 0.8, [note("B", 4)], 0), 

    (UUID(), [3], 6.5, [note("C#", 5)], -4),
    (UUID(), [3], 0.7, [note("C#", 5)], 0),
    (UUID(), [1], 0.8, [note("A",4)], 0), 

    (UUID(), [3], 0.6, [note("C#", 5)], 0), 
    (UUID(), [2], 5.5, [note("B", 4)], -4),
    (UUID(), [4], 2, [note("G", 4)], -4),
   
    (UUID(), [3], 3, [note("F#", 4)], -4),
    (UUID(), [2], 0.5, [note("C#", 5)], 0),
    (UUID(), [3], 0.5, [note("E", 5)], 0), 
    (UUID(), [3], 1, [note("E", 5)], 0), 
    (UUID(), [4], 0.5, [note("F#", 5)], 0), 
    (UUID(), [3], 0.5, [note("E", 5)], 0), 
    (UUID(), [4], 1, [note("A", 5)], 0), 
    (UUID(), [3], 1, [note("F#", 5)], 0), 


    (UUID(), [1], 3.5, [note("F#", 4)], -4),  // Phrase 2
    (UUID(), [3], 3.5, [note("C#", 5)], -4),
    (UUID(), [2], 0.5, [note("B",4)], 0),
    (UUID(), [1], 0.5, [note("A",4)], 0), 

    (UUID(), [3], 3, [note("C#", 5)], 0), 
    (UUID(), [1], 0.5, [note("E", 5)], 0), 
    (UUID(), [3], 0.5, [note("C#", 6)], 0), 
    (UUID(), [3], 1.5, [note("C#", 6)], 0), 
    (UUID(), [4], 1, [note("D", 6)], 0), 
    (UUID(), [3], 1.5, [note("C#", 6)], 0), 

    (UUID(), [2], 3, [note("B", 5)], 0), 
    (UUID(), [1], 0.5, [note("A", 5)], 0), 
    (UUID(), [4], 0.5, [note("G#", 5)], 0), 
    (UUID(), [4], 1.5, [note("G#", 5)], 0), 
    (UUID(), [1], 1, [note("A", 5)], 0), 
    (UUID(), [4], 0.5, [note("G#", 5)], 0), 
    (UUID(), [1], 1, [note("E", 5)], 0), 
   
    (UUID(), [2], 8, [note("F#", 5)], -4),
   
    (UUID(), [3], 2/3, [note("F#", 5)], 0),  // Phrase 3
    (UUID(), [1], 2/3, [note("A", 5)], 0), 
    (UUID(), [2], 2/3, [note("C#", 6)], 0), 
    (UUID(), [4], 3, [note("F#", 6)], 0), 
    (UUID(), [1], 0.5, [note("A", 6)], 0), 
    (UUID(), [4], 2.5, [note("F#", 6)], 0), 
   
    (UUID(), [3], 1.5, [note("E", 6)], 0), 
    (UUID(), [1], 4, [note("C#", 6)], 0), 
    (UUID(), [2], 1, [note("D", 6)], 0), 
    (UUID(), [1], 1.5, [note("C#", 6)], 0), 

    (UUID(), [1], 1.5, [note("C#", 6)], 0), 
    (UUID(), [4], 3, [note("B", 5)], -4),
    (UUID(), [3], 0.5, [note("E", 6)], 0),
    (UUID(), [3], 0.5, [note("E", 6)], 0), 
    (UUID(), [3], 0.5, [note("E", 6)], 0), 
    (UUID(), [4], 0.5, [note("C#", 6)], 0), 
    (UUID(), [3], 0.5, [note("B", 5)], 0), 
    (UUID(), [2], 1, [note("A", 5)], 0), 

    (UUID(), [1], 3, [note("F#", 5)], -4),
    (UUID(), [2], 0.5, [note("C#", 6)], 0),
    (UUID(), [4], 2.5, [note("B", 6)], -4),
    (UUID(), [3], 2, [note("A", 6)], -4),

    (UUID(), [1], 4.4, [note("F#", 6)], -4),  // Phrase 4
    (UUID(), [4], 1, [note("E", 6)], 0),
    (UUID(), [4], 0.5, [note("E", 6)], 0), 
    (UUID(), [2], 0.5, [note("B", 5)], 0), 
    (UUID(), [1], 0.5, [note("A", 5)], 0), 
    (UUID(), [2], 0.5, [note("B", 5)], 0), 
    (UUID(), [1], 0.5, [note("A", 5)], 0), 

    (UUID(), [2], 0.5, [note("B", 5)], 0), 
    (UUID(), [3], 4.5, [note("C#", 6)], 0), 
    (UUID(), [3], 0.5, [note("C#", 6)], 0), 
    (UUID(), [4], 2.5-0.1, [note("C#", 7)], -4),

    (UUID(), [4], 1.5, [note("C#", 7)], 0), 
    (UUID(), [2], 2.5, [note("B", 6)], -4),
    (UUID(), [2], 1.9/3, [note("B", 6)], 0),
    (UUID(), [1], 1.9/3, [note("G#", 6)], 0), 
    (UUID(), [4], 1.9/3, [note("E", 6)], 0), 
    (UUID(), [3], 1, [note("B", 5)], 0), 
    (UUID(), [4], 0.5, [note("E", 6)], 0), 
    (UUID(), [1], 0.5, [note("F#", 6)], 0), 

    (UUID(), [1], 2.9, [note("F#", 6)], -4),
    (UUID(), [4], 1, [note("E", 6)], 0),
    (UUID(), [4], 0.5, [note("E", 6)], 0), 
    (UUID(), [2], 3.4, [note("C#", 6)], -4),

    (UUID(), [1], 2/3*c, [note("F#", 4)], 0),  // Phrase 5, tempo change
    (UUID(), [2], 2/3*c, [note("A", 4)], 0), 
    (UUID(), [4], 2/3*c, [note("D", 5)], 0), 
    (UUID(), [1], 2/3*c, [note("F#", 5)], 0), 
    (UUID(), [2], 2/3*c, [note("A", 5)], 0), 
    (UUID(), [3], 2/3*c, [note("B", 5)], 0), 
    (UUID(), [2], 2.5*c, [note("A", 5)], 0), 
    (UUID(), [1], 1*c, [note("G#", 5)], 0), 
    (UUID(), [2], 0.5*c-0.05, [note("A", 5)], 0), 
   
    (UUID(), [1], 1.5*c, [note("G#", 5)], 0), 
    (UUID(), [3], 5*c, [note("E", 5)], 0), 
    (UUID(), [4], 1*c, [note("F#", 5)], 0), 
    (UUID(), [1], 0.5*c, [note("G#", 5)], 0), 
   
    (UUID(), [1], 3*c, [note("G#", 5)], -4),
    (UUID(), [4], 0.5*c, [note("F#", 5)], 0),
    (UUID(), [3], 0.5*c, [note("E", 5)], 0), 
    (UUID(), [4], 2*c, [note("F#", 5)], 0), 
    (UUID(), [3], 2/3*c, [note("E", 5)], 0), 
    (UUID(), [1], 2/3*c, [note("C#", 5)], 0), 
    (UUID(), [3], 2/3*c, [note("E", 5)], 0), 
   
    (UUID(), [1], 3*c, [note("C#", 5)], -4),
    (UUID(), [1], 5*c, [note("C#", 5)], -4),
   
    (UUID(), [2], 4*c, [note("D", 5)], -4),
    (UUID(), [1], 2*c, [note("C#", 5)], 0),
    (UUID(), [4], 1*c, [note("B", 4)], 0), 
    (UUID(), [3], 1*c, [note("A", 4)], 0), 
   
    (UUID(), [1], 7*c+0.13, [note("C#", 5)], -4),
    (UUID(), [3], 1*c, [note("A", 4)], 0),
   
    (UUID(), [4], 4*c, [note("B", 4)], -4),
    (UUID(), [3], 2*c+0.2, [note("A", 4)], -4),
    (UUID(), [2], 0.5*c, [note("G#", 4)], 0),
    (UUID(), [4], 0.5*c, [note("B", 4)], 0), 
    (UUID(), [3], 0.25*c, [note("G#", 4)], 0), 
    (UUID(), [2], 0.75*c+0.06, [note("F#", 4)], 0),

    (UUID(), [1], 8*c, [note("E", 4)], -4),        

]

//
//let noteWaves: [(id: UUID, keys: [Int], noteDuration: Double, midiNotes: [UInt8])] =
//
//[
//
//    (UUID(), [1], 2.5, [note("Bb", 4)]),
//
//    (UUID(), [2], 1.5, [note("G", 5)]),
//
//    (UUID(), [1], 0.25, [note("F", 5)]),
//
//    (UUID(), [2], 0.25, [note("Eb", 5)]),
//
//    (UUID(), [1], 3, [note("Bb", 5)]),
//
//    (UUID(), [2], 1, [note("G", 5)]),
//
//    (UUID(), [1], 4, [note("C", 6)]),
//
//
//    (UUID(), [2], 1, [note("C", 6)]),
//
//    (UUID(), [1], 0.5, [note("D", 6)]),
//
//    (UUID(), [2], 0.5, [note("Eb", 6)]),
//
//    (UUID(), [1], 1, [note("C", 6)]),
//
//    (UUID(), [2], 0.5, [note("D", 6)]),
//
//    (UUID(), [1], 0.5, [note("Eb", 6)]),
//
//    (UUID(), [2], 4, [note("F", 6)]),
//
//
//    (UUID(), [1], 0.5, [note("F", 6)]),
//
//    (UUID(), [2], 0.5, [note("G", 6)]),
//
//    (UUID(), [1], 0.5, [note("Ab", 6)]),
//
//    (UUID(), [1], 0.5, [note("Bb", 6)]),
//
//    (UUID(), [2], 2, [note("C", 7)]),
//
//
//    (UUID(), [1], 0.5, [note("Bb", 6)]), // Complex passage
//
//    (UUID(), [2], 0.5, [note("Ab", 6)]),
//
//
//    (UUID(), [1], 1/3, [note("G", 6)]),
//
//    (UUID(), [2], 1/3, [note("Ab", 6)]),
//
//    (UUID(), [1], 1/6, [note("G", 6)]),
//
//    (UUID(), [2], 1/6, [note("Ab", 6)]),
//
//
//    (UUID(), [1], 0.25, [note("G", 6)]),
//
//    (UUID(), [2], 0.25, [note("F", 6)]),
//
//    (UUID(), [1], 0.25, [note("G", 6)]),
//
//    (UUID(), [2], 0.25, [note("F", 6)]),
//
//
//    (UUID(), [1], 1/3, [note("Eb", 6)]),
//
//    (UUID(), [2], 1/3, [note("D", 6)]),
//
//    (UUID(), [1], 1/3, [note("Eb", 6)]),
//
//
//    (UUID(), [2], 1/6, [note("D", 6)]),
//
//    (UUID(), [1], 1/6, [note("Eb", 6)]),
//
//    (UUID(), [2], 1/3, [note("D", 6)]),
//
//    (UUID(), [1], 1/3, [note("D", 6)]),
//
//
//
//    (UUID(), [2], 0.25, [note("D", 6)]),
//
//    (UUID(), [1], 0.25, [note("C", 6)]),
//
//    (UUID(), [2], 2.5, [note("Bb", 5)]), // End of complex passage
//
//
//    (UUID(), [1], 2/3, [note("Bb", 5)]), //Triplet run 1
//
//    (UUID(), [2], 2/3, [note("Bb", 5)]),
//
//
//    (UUID(), [1], 1/3, [note("C", 6)]),
//
//    (UUID(), [2], 1/3, [note("D", 6)]),
//
//
//    (UUID(), [1], 1/3, [note("Eb", 6)]),
//
//    (UUID(), [2], 1/3, [note("F", 6)]),
//
//    (UUID(), [1], 1/3, [note("G", 6)]),
//
//
//    (UUID(), [2], 1/3, [note("Ab", 6)]),
//
//    (UUID(), [1], 1, [note("Bb", 6)]), //End of triplet run 1
//
//
//
//
//    (UUID(), [2], 1/3, [note("Bb", 5)]), //Triplet run 2
//
//    (UUID(), [1], 1/3, [note("C", 5)]),
//
//
//    (UUID(), [2], 1/3, [note("D", 6)]),
//
//    (UUID(), [1], 1/3, [note("Eb", 6)]),
//
//    (UUID(), [2], 1/3, [note("F", 6)]),
//
//
//    (UUID(), [1], 1/3, [note("G", 6)]),
//
//    (UUID(), [2], 1/3, [note("Ab", 6)]),
//
//    (UUID(), [1], 1/3, [note("Bb", 6)]),
//
//    (UUID(), [2], 4, [note("C", 7)]), //End of triplet run 2
//
//
//    (UUID(), [1], 0.5, [note("F", 5)]),
//
//    (UUID(), [2], 0.5, [note("G", 5)]),
//
//    (UUID(), [1], 2, [note("Ab", 5)]),
//
//    (UUID(), [2], 2, [note("F", 6)]),
//
//
//    (UUID(), [1], 7/3, [note("Ab", 5)]),
//
//    (UUID(), [2], 2/3, [note("Db", 6)]),
//
//    (UUID(), [1], 2/3, [note("Db", 6)]),
//
//    (UUID(), [2], 2, [note("Db", 6)]),
//
//    (UUID(), [1], 2, [note("Db", 5)]),
//
//    (UUID(), [2], 1, [note("A", 4)]),
//
//]
//
//
