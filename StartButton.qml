import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0

Button {
    id: startbutton
    text: start_title

    property string start_title: "Start pomodoro"
    property string stop_title: "Interrupt"

    onClicked: {
        if (!ticking.playing) {
            ticking.play();
            timer.start();
            text = stop_title;
            pressed = true
        } else {
            ticking.stop();
            timer.start();
            text = start_title
        }
    }
}
