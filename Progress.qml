import QtQuick 2.0
import QtQuick.Controls 1.0

ProgressBar {
    id: progress
    maximumValue: 4
    value: 0

    signal reset
    signal increment

    onReset: { value = 0 }
    onIncrement: {
        if (value < maximumValue) {
            value++
        } else {
            reset()
        }
    }

    Text {
        text: { parent.value + '/' + parent.maximumValue }
        anchors.centerIn: parent
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            increment()
            console.log('progress manually changed ' + value + '/' + maximumValue)
        }
    }
}
