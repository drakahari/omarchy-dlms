import QtQuick
import QtQuick.Shapes
import qs.Commons

Item {
  id: root
  property bool useColorIcon: false
  property color foreground: "white"

  Image {
    anchors.fill: parent
    visible: root.useColorIcon
    source: Qt.resolvedUrl("dlms-icon.png")
    fillMode: Image.PreserveAspectFit
    smooth: true
  }

  // Favicon badge silhouette and swoosh; the tiny wordmark is reduced to D.
  Item {
    anchors.fill: parent
    visible: !root.useColorIcon

    Rectangle {
      anchors.fill: parent
      anchors.margins: root.width / 12
      radius: width / 2
      color: "transparent"
      border.color: root.foreground
      border.width: Math.max(1, root.width / 14)
    }
    Text {
      anchors.centerIn: parent
      anchors.verticalCenterOffset: -root.height / 18
      text: "D"
      textFormat: Text.PlainText
      color: root.foreground
      font.family: Style.font.family
      font.pixelSize: root.height * 0.55
      font.bold: true
      font.italic: true
      renderType: Text.NativeRendering
    }
    Shape {
      width: 18
      height: 18
      anchors.centerIn: parent
      scale: root.width / 18
      ShapePath {
        strokeColor: root.foreground
        strokeWidth: 0.8
        fillColor: "transparent"
        capStyle: ShapePath.RoundCap
        PathSvg { path: "M3.5 13.1 C7 11.8 11 12.5 14.7 10.9" }
      }
    }
  }
}
