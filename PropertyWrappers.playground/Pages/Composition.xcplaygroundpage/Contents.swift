import UIKit

@propertyWrapper
struct Formatter {

    private var value: String
    private var format: String

    init(wrappedValue: String, format: String) {

        self.value = wrappedValue
        self.format = format
    }

    var wrappedValue: String {

        get { value }
        set {

            var string = ""
            var newValue = newValue
            for character in format {

                if character == "X" {

                    let character = newValue.removeFirst()
                    string += String(character)
                } else {

                    string += String(character)
                }
            }
            value = string
        }
    }
}

struct Something {

    @Formatter(format: "XXX-XXX-XXX") @Formatter(format: "oXXXXXXXXXXXo") var formatted: String = ""
}

var something = Something()
something.formatted = "123-456-789"
something.formatted

