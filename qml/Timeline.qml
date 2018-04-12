import QtQuick 2.2

QtObject {
    // Internal properties
    property int rowHeight: 48
    property int rows: Math.floor((maxY - minY) / rowHeight)
    property int topBound: minY + (maxY - minY) / 3
    property int bottomBound: minY + rowHeight * Math.ceil(rows * 2 / 3)
    property int gap: width / 5

    // Properties
    property int minY
    property int maxY
    property int width
    property var comments: []

    // Functions
    function register(item) {
        // Allocate layout
        if (item.position === "top") {
            item.y = minY
            comments.forEach(function(i) {
                if (i.position !== "top") return
                if (i.overlaps(item)) {
                    item.y += rowHeight
                    if (item.y >= (topBound - rowHeight))
                        item.y = minY
                }
            })
        } else if (item.position === "bottom") {
            item.y = maxY - rowHeight
            comments.forEach(function(i) {
                if (i.position !== "bottom") return
                if (i.overlaps(item)) {
                    item.y -= rowHeight
                    if (item.y < bottomBound)
                        item.y = maxY - rowHeight
                }
            })
        } else { // item.position === "scroll"
            item.y = minY + Math.floor(Math.random() * rows) * rowHeight
            comments.forEach(function(i) {
                if (i.overlaps(item) && (item.x - i.x) < gap) {
                    item.y += rowHeight
                    if (item.y >= (maxY - rowHeight))
                        item.y = minY
                }
            })
        }

        comments.push(item)
    }

    function unregister(item) {
        var index = comments.indexOf(item)
        if (index < 0) return
        comments.splice(index, 1)
    }
}
