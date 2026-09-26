import QtQuick

Item {
  id: root
  property bool useColorIcon: false

  Image {
    anchors.fill: parent
    source: Qt.resolvedUrl(root.useColorIcon ? "dlms-icon.png" : "dlms-icon-mono.png")
    fillMode: Image.PreserveAspectFit
    smooth: true
  }
}
