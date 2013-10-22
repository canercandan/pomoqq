import QtQuick 2.1
import QtQuick.Controls 1.0
import QtQuick.Window 2.0
import QtQuick.Dialogs 1.0
import QtQuick.Layouts 1.0
import QtMultimedia 5.0
import QtQuick.LocalStorage 2.0

ApplicationWindow {
    id: pomoqq
    title: "PomoQQ"
    color: pomodoroColor
    flags: flags | Qt.Dialog | Qt.WindowStaysOnTopHint
    width: 222; height: 195
    maximumWidth: 222; maximumHeight: 300

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
    property bool progressTimeEditable: false

    signal changeColor
    signal changeState
    signal nextState
    signal reset

    onVisibleChanged: console.log('visible')

    onChangeColor: {
        if (!isBreak) {
            color = (setProgress.value < setNumber) ? shortBreakColor : longBreakColor
        } else {
            color = pomodoroColor
        }
    }

    onChangeState: {
        console.log('changeState');
        changeColor();
        if (!isBreak) {
            minutesProgress.maximumValue = (setProgress.value < setNumber) ? shortBreakTime : longBreakTime
        } else {
            minutesProgress.maximumValue = pomodoroTime;
        }
        reset()
        isBreak = !isBreak;
    }

    onNextState: {
        console.log('nextState');
        timer.stop();
        alarm.play();
        if (!isBreak) {
            setProgress.increment()
            pomodoroProgress.increment()
        } else {
            if (setProgress.value >= setNumber) { setProgress.reset() }
        }
        changeState()
        timer.start()
    }

    onReset: {
        minutesProgress.reset();
        secondsProgress.reset();
        secondsProgress.value = secondsProgress.maximumValue;
        point.reset()
    }

    Timer {
        id: timer
        interval: 500; running: false; repeat: true

        onTriggered: {
            point.countIn();
            ticking.play();
            console.log('timer ' + minutes.value + ':' + seconds.value)
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

        RowLayout {
            Display { id: minutes; pointSize: pointSize; value: { minutesProgress.countDown() } }
            Point { id: point; pointSize: pointSize; onCountOut: secondsProgress.countIn() }
            Display { id: seconds; pointSize: pointSize; value: { secondsProgress.countDown() } }
        }

        ColumnLayout {
            TimeProgress {
                id: minutesProgress
                maximumValue: pomodoroTime
                Layout.fillWidth: true
                onCountOut: nextState()
                editable: pomoqq.progressTimeEditable
                visible: pomoqq.progressTimeEditable
            }

            TimeProgress {
                id: secondsProgress
                maximumValue: 59
                value: 59
                Layout.fillWidth: true
                onCountOut: minutesProgress.countIn()
                editable: pomoqq.progressTimeEditable
                visible: pomoqq.progressTimeEditable
            }
        }

        RowLayout {
            Button {
                id: startButton
                text: { !timer.running ? "Start" : "Interrupt" }
                Layout.fillWidth: true

                onClicked: {
                    timer.running = !timer.running;
                    if (!timer.running) { reset() }
                }
            }

            Button {
                id: switchButton
                text: { isBreak ? "Pomodoro" : "Break" }
                Layout.fillWidth: true

                onClicked: {
                    changeState()
                }
            }
        }

        Progress { id: pomodoroProgress; maximumValue: pomodoroNumber; Layout.fillWidth: true }
        Progress { id: setProgress; maximumValue: setNumber; Layout.fillWidth: true }
    }
}
