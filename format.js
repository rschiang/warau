.pragma library

var sizes = {
    small: "small", little: "small",
    medium: "medium",
    large: "large", big: "large"
}

var colors = {
    white: "white", black: "black", gray: "#9e9e9e",
    red: "#f44336", pink: "#e91e63", purple: "#9c27b0",
    indigo: "#3f51b5", green: "#4caf50", blue: "#2196f3",
    cyan: "#00bcd4", teal: "#009688", yellow: "#ffeb3b",
    orange: "#ff9800", brown: "#795548"
}

var positions = {
    scroll: "scroll", naka: "scroll",
    top: "top", ue: "top",
    bottom: "bottom", shita: "bottom"
}

var fonts = {
    sans: "sans", gothic: "sans",
    serif: "serif", mincho: "serif",
    cursive: "cursive"
}

function parse(fmt) {
    var format = {}
    var flags = fmt.split(" ")
    flags.forEach(function(i) {
        if (i in sizes)
            format.size = sizes[i]
        else if (i in colors)
            format.color = colors[i]
        else if (i in positions)
            format.position = positions[i]
        else if (i in fonts)
            format.font = fonts[i]
    })
    return format
}

// Helper functions

function choice(obj) {
    var keys = Object.keys(obj)
    return keys[Math.floor(Math.random() * keys.length)]
}

function random() {
    return [choice(sizes), choice(colors), choice(positions)].join(" ")
}
