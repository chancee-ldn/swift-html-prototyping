import Foundation

// 1. Define a structure to hold our data, we'll do fancy things with it later
struct Pokemon {
    var name: String
    var number: Int
    var type = [String]()
    var dexEntry: String
}

// 2.   Define some pokemon!
var bulbasaur = Pokemon(name: "Bulbasaur", number: 1, type: ["Grass", "Poison"], dexEntry: "It can go for days without eating a single morsel. In the bulb on its back, it stores energy.")
var ivysaur = Pokemon(name: "Ivysaur", number: 2, type: ["Grass", "Poison"], dexEntry: "The bulb on its back grows by drawing energy. It gives off an aroma when it is ready to bloom.")
var venusaur = Pokemon(name: "Venusaur", number: 3, type: ["Grass", "Poison"], dexEntry: "The flower on its back catches the sun's rays. The sunlight is then absorbed and used for energy.")
var charmander = Pokemon(name: "Charmander", number: 4, type: ["Fire"], dexEntry: "The flame at the tip of its tail makes a sound as it burns. You can only hear it in quiet places.")
var charmeleon = Pokemon(name: "Charmeleon", number: 5, type: ["Fire"], dexEntry: "When expelling a blast of super hot fire, the red flame at the tip of its tail burns more intensely.")
var charizard = Pokemon(name: "Charizard", number: 6, type: ["Fire", "Dragon"], dexEntry: "The flame at the tip of its tail makes a sound as it burns. You can only hear it in quiet places.")
var squirtle = Pokemon(name: "Squirtle", number: 7, type: ["Water"], dexEntry: "Shoots water at prey while in the water. Withdraws into its shell when in danger.")
var weedle = Pokemon(name: "Weedle", number: 13, type: ["Bug", "Poison"], dexEntry: "Beware of the sharp stinger on its head. It hides in grass and bushes where it eats leaves.")


// 3.   An array of data for us to use
var pokemonArray = [bulbasaur, ivysaur, venusaur, charmander, charmeleon, charizard, squirtle, weedle]
// 4.   Build some content by adding strings, and then returning it for use elsewhere
func assembleTeam() -> String {
    var content = ""
    for pokemon in pokemonArray {
        
        content.append("<div>") // hi, i'm a div so we can do some fancy css later
        
        var number = "\t<h4>%@</h4>\n"
        number = String(format: number, String(pokemon.number))
        content.append(number)
        
        var name = "\t<h2>%@</h2>\n"
        name = String(format: name, pokemon.name)
        content.append(name)
        
        var entry = "\t<p>%@</p>\n"
        entry = String(format: entry, String(pokemon.dexEntry))
        content.append(entry)
        
        for type in pokemon.type {
            var typeName = "\t<span>%@</span>\n"
            typeName = String(format: typeName, type)
            content.append(typeName)
        }
        
        content.append("</div>") // close the div
        
        
    }
    return content
}
// 5.   Feed some content to be injected into a template
func writeTemplate(content: String) {
    // the location of our template containing '%@'
    let path = String(NSString(string:"template.html"))
    do {
        let template = try String(contentsOfFile: path, encoding: String.Encoding.utf8)
        let output = String(format: template, content)
        let file = String("output.html") // the file we will export
        do {
            try output.write(toFile: file, atomically: false, encoding: String.Encoding.utf8)
            print ("🔥 boom. successfully wrote: \(file)")
        }
        catch {
            print ("🤨 dang. unable to write \(file)")
        }
    } catch {
        print("🤨 can't find \(path)")
    }
}
// This function will write index.html using template.html as it's source, and calling assembleTeam() to return a string of content
writeTemplate(content: assembleTeam())
