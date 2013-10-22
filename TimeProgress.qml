import QtQuick 2.0

Progress {
    id: timeProgress

    signal countOut

    function countIn() {
        if (value < maximumValue) {
            increment()
        } else {
            reset();
            countOut()
        }
    }

    function countDown() { return maximumValue - value }
}
