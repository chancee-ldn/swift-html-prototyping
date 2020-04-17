# swift-html-prototyping
A way to rapidly prototype data led design layouts

This is my method for executing big hairy data led layouts using only a html template and one swift file.

Todays web design process goes something like this:

1. Draw/concieve a layout
2. Execute this in Sketch/Illustrator/Affinity
3. Publish to a Zeplin/Adobe
4. Developer ignores majority of finesse and builds what they see
5. Rounds of iteration between designer and developer to tweak front end
6. Designer sees the real thing and decides to change it. Which is natural.

There's a lot of suck in here. Let's remove some.

### The set up

We are going to write a script in swift to take a html template, and inject some data. So you can test how your design will hold up with extreme title lengths, or change heading sizes and see it reflect across the layout. Think Sketch symbols that put down the pizza and hit the gym.

The objective is to get to step six as soon as possible so more time is spent polishing a design than getting it over the line. Swift tries to be friendly, so even if you have never written a lot of code you should find it readable. If you've ever done some wordpress or janked around in myspace - you got this.

1. You're going to want some data that repeats. If it's a layout design this will happen as part of your UX process, you'll identify points of data and what importance should be where. In this example we'll use Pokemon. So names, types, dex entries.


2. Pull together some bare bones HTML - this depends on the fidelity of your prototype and your html chops. If you are purely messing with layout at different breakpoints you can get away with less. Although I don't think defining some good css typography should be beyond any designer today.

But to get started, this is enough:

```html
<html>
    <head></head>

    <body>
	%@
    </body>

</html>
```

The `%@` is the magic incarnation. Swift can target that and inject our content.


3. Make a swift file. You can make this in any text editor. Xcode will give you helpful syntax highlighting, or if you are sadistic you can use vim. Nano is used here for variety. Also, command line stuff is dope.

```bash
nano assemble.swift
```

Then we need to import the Foundation framework, which is one line:
```swift
import Foundation
```


3. Structs. Think of this like a template for data, you define the slots and what shape they are: Numbers, Strings, Dates. Swift is type safe, so you need to be upfront about what goes where. 

```swift
struct Pokemon {
	var name: String
	var number: Int
	var type = [String]() // Pokemon can have many types, so use an array
	var dexEntry: String
}
```

4. And start defining some content like this:

```swift
var venusaur = Pokemon(name: "Venusaur", number: 1, type: ["Grass", "Poison"], dexEntry: "It can go for days without eating a single morsel. In the bulb on its back, it stores energy.")
var charmander = Pokemon(name: "Charmander", number: 4, type: ["Fire"], dexEntry: "The flame at the tip of its tail makes a sound as it burns. You can only hear it in quiet places.")
var squirtle = Pokemon(name: "Squirtle", number: 7, type: ["Water"], dexEntry: "Shoots water at prey while in the water. Withdraws into its shell when in danger.")

```


5. A content loop. Create an array, and feed it all the structs we created. Then we iterate (a fancy word for 'go through one by one') the array and create some html - this is what we will inject into the html template.

```swift
// 3.   An array of data for us to use
var pokemonArray = [venusaur, charmander, squirtle]

// 4.   Build some content by adding strings, and then returning it for use elsewhere
func assembleTeam() -> String {
    var content = ""
    for pokemon in pokemonArray {
        
        var name = "\t<h2>%@</h2>\n"
        name = String(format: name, pokemon.name)
        content.append(name)
        
        var number = "\t<p>%@</p>\n"
        number = String(format: number, String(pokemon.number))
        content.append(number)
        
        var entry = "\t<p>%@</p>\n"
        entry = String(format: entry, String(pokemon.dexEntry))
        content.append(entry)
        
    }
    return content
}
```


6. Don't be intimidated. Nearly done. This snippet is receiving the `content` the function above returns and looks for `template.html` which contains the magic `%@` incarnation - it then swaps `%@` for our `content` and writes out `index.html`.

```swift
// 5.   Feed some content to be injected into a template
func writeTemplate(content: String) {
    // the location of our template containing '%@'
    let path = String(NSString(string:"template.html"))
    do {
        let template = try String(contentsOfFile: path, encoding: String.Encoding.utf8)
        let file = String("output.html") // the file we will export
        do {
            try content.write(toFile: file, atomically: false, encoding: String.Encoding.utf8)
            print ("🔥 boom. successfully wrote: \(file)")
        }
        catch {
            print ("🤨 dang. unable to write \(file)")
        }
    } catch {
        print("🤨 can't find \(path)")
    }
}
```

8. Then we call the function we just wrote and give it some content to parse:

```swift
// This function will write index.html using template.html as it's source, and calling assembleTeam() to return a string of content
writeTemplate(content: assembleTeam())
```

9. Save and close your swift file and we're kind of done. All being well you can run this from your command line and it will write `output.html`:

```bash
swift assemble.swift
```


For clean codes sake all this happens in the directory the script is being executed from. Github also has fancy code highlighting and you can [download the files](http://github.com).

I've tried to keep this as self contained as possible, but if anything has gone whoosh feel free to [HMU](http://twitter.com) on twitter or insta.


## Review

At this point we have an array of data that can be any length we wish, and a way to render it in html. Now we are free to get on with our design jobs, tweaking spacing between cells, adjusting heading sizes - checking the balance between desktop and mobile. Without hassling developers or raising tickets. 

Depending on the fidelity of your prototype you can hand that over, or you can take your learnings and document them with confidence in your design app of choice.
