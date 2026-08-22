import QtQuick
import Quickshell

Item {
  id: root

  property var bar
  property string moduleName
  property var settings

  implicitWidth: bar && bar.vertical ? bar.barSize : 38
  implicitHeight: bar && bar.vertical ? 38 : (bar ? bar.barSize : 26)

  function digit(column) {
    var hour = clock.date.getHours()
    var minute = clock.date.getMinutes()

    switch (column) {
      case 0: return Math.floor(hour / 10)
      case 1: return hour % 10
      case 2: return Math.floor(minute / 10)
      case 3: return minute % 10
    }

    return 0
  }

  function bitEnabled(cell) {
    var row = Math.floor(cell / 4)
    var column = cell % 4
    var weight = 1 << (3 - row)

    return (digit(column) & weight) !== 0
  }

  SystemClock {
    id: clock
    precision: SystemClock.Minutes
  }

  Grid {
    anchors.centerIn: parent

    columns: 4
    rows: 4

    columnSpacing: 2
    rowSpacing: 2

    Repeater {
      model: 16

      Rectangle {
        required property int index

        width: 4
        height: 4
        radius: 2

        color: root.bar
          ? root.bar.foreground
          : "white"

        opacity: root.bitEnabled(index)
          ? 1.0
          : 0.18
      }
    }
  }
}