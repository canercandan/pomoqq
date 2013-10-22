import QtQuick 2.0

Item {
    id: display
    width: 100; height: 62

    property int pointSize: 42
    property int value: 0

    Text {
        text: { value < 10 ? '0' + value : value }
        font.pointSize: parent.pointSize
        font.bold: true
        font.family: "Courier"
        color: "white"
        anchors.centerIn: parent
    }
}
