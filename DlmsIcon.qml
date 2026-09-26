import QtQuick
import QtQuick.Shapes

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

  // Paths from the DLMS dashboard brand mark in templates/dashboard/index.html.
  Shape {
    width: 24
    height: 24
    anchors.centerIn: parent
    scale: root.width / 20
    visible: !root.useColorIcon

    ShapePath {
      strokeColor: root.foreground
      strokeWidth: 1.7
      fillColor: "transparent"
      PathSvg { path: "M4 5.5 12 3l8 2.5v5.7c0 4.9-3.3 8.1-8 9.8-4.7-1.7-8-4.9-8-9.8V5.5Z" }
    }
    ShapePath {
      strokeColor: root.foreground
      strokeWidth: 1.7
      fillColor: "transparent"
      capStyle: ShapePath.RoundCap
      joinStyle: ShapePath.RoundJoin
      PathSvg { path: "m8 12 2.3-2.4 2.1 2.1L16 8" }
    }
  }
}
