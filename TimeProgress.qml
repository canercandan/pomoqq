import QtQuick 2.0

Progress {
    id: timeProgress

    signal countOut

    function countIn() {
        if (value < maximumValue-1) {
            increment()
        } else {
            reset();
            countOut()
        }
    }
}
