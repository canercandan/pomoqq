import QtQuick 2.0

Item {
    id: point
    width: 10; height: 62

    property int pointSize: 42
    property bool makeVisible: true

    signal countOut

    function countIn() {
        makeVisible = !makeVisible;
        if (!makeVisible) { countOut() }
    }

    function reset() { makeVisible = true }

    Text {
        text: { makeVisible ? ':' : '' }
        font.pointSize: parent.pointSize
        font.family: "Courier"
        color: "white"
        anchors.centerIn: parent
    }
}
