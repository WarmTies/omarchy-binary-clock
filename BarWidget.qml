import QtQuick
import Quickshell
import qs.Commons
import qs.Ui

BarWidget {
  id: root

  moduleName: "binaryclock.clock"

  implicitWidth: vertical ? bar.barSize : 38
  implicitHeight: vertical ? 38 : bar.barSize

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

  // Omarchy calendar panel
  readonly property bool opened:
    panelLoader.item ? panelLoader.item.opened === true : false

  function open() {
    if (panelLoader.item)
      panelLoader.item.open()
  }

  function close() {
    if (panelLoader.item)
      panelLoader.item.close()
  }

  function togglePanel() {
    if (panelLoader.item)
      panelLoader.item.toggle()
  }

  function closeForPopoutSwitch() {
    if (panelLoader.item)
      panelLoader.item.closeForPopoutSwitch()
  }

  readonly property bool popoutSwitchClosing:
    panelLoader.item
      ? panelLoader.item.popoutSwitchClosing === true
      : false

  function injectPanel() {
    var target = panelLoader.item

    if (!target)
      return

    if ("bar" in target)
      target.bar = root.bar

    if ("settings" in target)
      target.settings = root.settings

    if ("anchorItem" in target)
      target.anchorItem = clickArea

    if ("hostWidget" in target)
      target.hostWidget = root
  }

  onBarChanged: injectPanel()
  onSettingsChanged: injectPanel()

  Loader {
    id: panelLoader
    active: true
    source: Qt.resolvedUrl("Panel.qml")
    visible: false

    onLoaded: {
      root.injectPanel()
      Qt.callLater(root.injectPanel)
    }
  }

  Item {
    id: clickArea
    anchors.fill: parent

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

    MouseArea {
      anchors.fill: parent
      cursorShape: Qt.PointingHandCursor

      onClicked: root.togglePanel()
    }
  }
}