import QtQuick 2.0
import QtQuick.Controls 1.0

ProgressBar {
    id: progress
    maximumValue: 4
    value: 0

    signal reset
    signal increment

    property bool editable: true

    onReset: { value = 0 }
    onIncrement: {
        if (value < maximumValue) {
            value++
        } else {
            reset()
        }
    }

    Text {
        text: { parent.maximumValue-parent.value + '/' + parent.maximumValue + ' (' + parent.value + ')' }
        anchors.centerIn: parent
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            if (!editable) return;
            increment();
            console.log('progress manually changed ' + value + '/' + maximumValue)
        }
    }
}
