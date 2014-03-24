import QtQuick 2.1
import QtQuick.Controls 1.0
import QtQuick.Controls.Styles 1.0
import QtQuick.Window 2.0
import QtQuick.Dialogs 1.0
import QtQuick.Layouts 1.0
import QtMultimedia 5.0

ApplicationWindow {
    id: pomoqq
    title: "PomoQQ"
    color: pomodoroColor
    flags: flags | Qt.Dialog | Qt.WindowStaysOnTopHint
    width: 222; height: 225

    property string pomodoroColor: "#8F3D3D"
    property string shortBreakColor: "#547d14"
    property string longBreakColor: "#0088aa"

    property int pointSize: 42
    property int pomodoroTime: 25
    property int shortBreakTime: 5
    property int longBreakTime: 15
    property int setNumber: 4
    property int interruptionNumber: 10
    property int pomodoroNumber: 25
    property int projectNumber: 1
    property bool isBreak: false
    property bool progressTimeEditable: false

    SoundEffect { id: ticking; source: "sounds/ticking.wav"; muted: { unmuteTickingCheckbox.checked == false } }
    SoundEffect { id: break_ticking; source: "sounds/break_ticking.wav"; muted: { setProgress.value == setNumber || unmuteTickingCheckbox.checked == false } }
    SoundEffect { id: alarm;   source: "sounds/alarm.wav"; muted: { unmuteAlarmCheckbox.checked == false } }
    SoundEffect { id: fiveminuteleft;   source: "sounds/5left.wav"; muted: { setProgress.value == setNumber || unmuteAlarmCheckbox.checked == false } }

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
            interruptionProgress.reset();
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
            projectProgress.increment()
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
            if ((minutes.value < 5 || !(minutes.value % 5)) && !seconds.value) {
                fiveminuteleft.play();
            } else if (!isBreak) {
                ticking.play();
            } else {
                break_ticking.play();
            }
            console.log('timer ' + minutes.value + ':' + seconds.value)
        }
    }

    ColumnLayout {
        width: parent.width
        height: parent.height

        Text {
            text: "PomoQQ"
            font.bold: true
            font.pointSize: 15
            color: "white"
            horizontalAlignment: Text.AlignHCenter
            Layout.fillWidth: true
        }

        RowLayout {
            Display { Layout.fillWidth: true; Layout.fillHeight: true; id: minutes; pointSize: parent.width/4; value: { minutesProgress.countDown() } }
            Point { Layout.fillWidth: true; Layout.fillHeight: true; id: point; pointSize: parent.width/4; onCountOut: secondsProgress.countIn() }
            Display { Layout.fillWidth: true; Layout.fillHeight: true; id: seconds; pointSize: parent.width/4; value: { secondsProgress.countDown() } }
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

            CheckBox {
                id: unmuteTickingCheckbox
                checked: true
                style: CheckBoxStyle {
                    label: Label {
                        color: "white"
                        text: "Tick"
                    }
                }
                Layout.fillWidth: true

                onClicked: {
                    console.log("unmute tick");
                }
            }

            CheckBox {
                id: unmuteAlarmCheckbox
                checked: true
                style: CheckBoxStyle {
                    label: Label {
                        color: "white"
                        text: "Alarm"
                    }
                }
                Layout.fillWidth: true

                onClicked: {
                    console.log("unmute alarm");
                }
            }
        }

        RowLayout {
            Text { text: "#p"; font.bold: true; color: "white"; Layout.preferredWidth: 20 }
            Progress { id: pomodoroProgress; maximumValue: pomodoroNumber; Layout.fillWidth: true }
            Button {
                text: "R"
                onClicked: {
                    console.log("reset")
                    pomodoroProgress.reset()
                }
                Layout.preferredWidth: 30
                Layout.maximumHeight: 23
            }
        }

        RowLayout {
            Text { text: "#b"; font.bold: true; color: "white"; Layout.preferredWidth: 20 }
            Progress { id: setProgress; maximumValue: setNumber; Layout.fillWidth: true }
            // Button {
            //     text: "-"
            //     onClicked: {
            //         console.log("-")
            //         setProgress.maximumValue--
            //     }
            //     Layout.preferredWidth: 30
            //     Layout.maximumHeight: 23
            // }
            // Button {
            //     text: "+"
            //     onClicked: {
            //         console.log("+")
            //         setProgress.maximumValue++
            //     }
            //     Layout.preferredWidth: 30
            //     Layout.maximumHeight: 23
            // }
            Button {
                text: "R"
                onClicked: {
                    console.log("reset")
                    setProgress.reset()
                }
                Layout.preferredWidth: 30
                Layout.maximumHeight: 23
            }
        }

        RowLayout {
            Text { text: "#i"; font.bold: true; color: "white"; Layout.preferredWidth: 20 }
            Progress { id: interruptionProgress; maximumValue: interruptionNumber; Layout.fillWidth: true }
            Button {
                text: "R"
                onClicked: {
                    console.log("reset")
                    interruptionProgress.reset()
                }
                Layout.preferredWidth: 30
                Layout.maximumHeight: 23
            }
        }

        RowLayout {
            Text { text: "#P"; font.bold: true; color: "white"; Layout.preferredWidth: 20 }
            Progress { id: projectProgress; maximumValue: projectNumber; Layout.fillWidth: true }
            Button {
                text: "-"
                onClicked: {
                    console.log("-")
                    projectProgress.maximumValue--
                }
                Layout.preferredWidth: 30
                Layout.maximumHeight: 23
            }
            Button {
                text: "+"
                onClicked: {
                    console.log("+")
                    projectProgress.maximumValue++
                }
                Layout.preferredWidth: 30
                Layout.maximumHeight: 23
            }
            Button {
                text: "R"
                onClicked: {
                    console.log("reset")
                    projectProgress.reset()
                    projectProgress.maximumValue = projectNumber
                }
                Layout.preferredWidth: 30
                Layout.maximumHeight: 23
            }
        }
    }
}
