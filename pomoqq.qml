import QtQuick 2.1
import QtQuick.Controls 1.0
import QtQuick.Window 2.0
import QtQuick.Dialogs 1.0
import QtQuick.Layouts 1.0
import QtMultimedia 5.0

ApplicationWindow {
    id: pomoqq
    title: "PomoQQ"
    color: pomodoroColor

    property string pomodoroColor: "#8F3D3D"
    property string shortBreakColor: "#547d14"
    property string longBreakColor: "#0088aa"

    property int pointSize: 42
    property int pomodoroTime: 25
    property int shortBreakTime: 5
    property int longBreakTime: 15
    property int setNumber: 4
    property int pomodoroNumber: 48
    property bool isBreak: false

    signal changeColor
    signal nextState

    onChangeColor: {
        if (!isBreak) {
            color = (setProgress.value < setNumber-1) ? shortBreakColor : longBreakColor
        } else {
            color = pomodoroColor
        }
    }

    onNextState: {
        console.log('nextState');
        timer.stop();
        alarm.play();
        changeColor();
        if (!isBreak) {
            minutesProgress.maximumValue = (setProgress.value < setNumber-1) ? shortBreakTime : longBreakTime
            setProgress.increment()
            pomodoroProgress.increment()
        } else {
            minutesProgress.maximumValue = pomodoroTime;
            if (setProgress.value >= setNumber) { setProgress.reset() }
        }
        isBreak = !isBreak;
        timer.start()
    }

    Timer {
        id: timer
        interval: 500; running: false; repeat: true

        onTriggered: {
            point.countIn();
            ticking.play();
            console.log('timer ' + minutes.times + ':' + seconds.times)
        }
    }

    SoundEffect { id: ticking; source: "sounds/ticking.wav" }
    SoundEffect { id: alarm;   source: "sounds/alarm.wav" }

    ColumnLayout {
        Text {
            text: "PomoQQ"
            font.bold: true
            font.pointSize: 15
            color: "white"
            horizontalAlignment: Text.AlignHCenter
            Layout.fillWidth: true
        }

        Progress { id: pomodoroProgress; maximumValue: pomodoroNumber; Layout.fillWidth: true }
        Progress { id: setProgress; maximumValue: setNumber; Layout.fillWidth: true }

        RowLayout {
            Display { id: minutes; pointSize: pointSize; value: { minutesProgress.value } }
            Point { id: point; pointSize: pointSize; onCountOut: secondsProgress.countIn(); }
            Display { id: seconds; pointSize: pointSize; value: { secondsProgress.value } }
        }

        ColumnLayout {
            TimeProgress {
                id: minutesProgress
                maximumValue: pomodoroTime
                Layout.fillWidth: true
                onCountOut: nextState()
            }

            TimeProgress {
                id: secondsProgress
                maximumValue: 59
                Layout.fillWidth: true
                onCountOut: minutesProgress.countIn()
            }
        }

        // StartButton { Layout.fillWidth: true }
        Button {
            id: startButton
            text: { !timer.running ? "Start pomodoro" : "Interrupt" }
            onClicked: { timer.running = !timer.running }
            Layout.fillWidth: true
        }
    }
}
