import Foundation

struct Exercise {
    var name: String
    var duration: Int
}

enum TrainingExercises {
    static let WarmUp: [Exercise] = [
        Exercise(name: "Pushups", duration: 60),
        Exercise(name: "Break", duration: 30),
        Exercise(name: "Jumping Jacks", duration: 60),
        Exercise(name: "Break", duration: 30),
        Exercise(name: "Situps", duration: 30),
        Exercise(name: "Break", duration: 30),
        Exercise(name: "Squats", duration: 30),
        Exercise(name: "Break", duration: 30),
        Exercise(name: "Lunges", duration: 30)]
    
    static let Toprock: [Exercise] = [
        Exercise(name: "Toprock 1", duration: 100),
        Exercise(name: "Toprock 2", duration: 100),
        Exercise(name: "Toprock 3", duration: 100),
        ]
    
    static let Footwork: [Exercise] = [
        Exercise(name: "Footwork 1", duration: 30),
        Exercise(name: "Footwork 2", duration: 30)]
    
    static let Freezes: [Exercise] = [
        Exercise(name: "Freeze 1", duration: 30),
        Exercise(name: "Freeze 2", duration: 30)]
    
    static let Powermoves: [Exercise] = [
        Exercise(name: "Windmills", duration: 100),
        Exercise(name: "Backspin", duration: 100)]
    
    static let Stamina = [
        Exercise(name: "Toprock", duration: 60),
        Exercise(name: "Footwork", duration: 60),
        Exercise(name: "Power Moves", duration: 60),
        Exercise(name: "Freeze", duration: 60)]
    
    static let Battle = [
        Exercise(name: "Set 1", duration: 11),
        Exercise(name: "Set 2", duration: 11),
        Exercise(name: "Set 3", duration: 11),
        Exercise(name: "Set 4", duration: 11),
        Exercise(name: "Set 5", duration: 11)]


}
