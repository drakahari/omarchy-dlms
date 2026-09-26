import QtQuick
import qs.Commons
import qs.Ui

Panel {
  id: root
  moduleName: "drakahari.dlms"
  manageIpc: false
  property var anchorItem: null
  property var hostWidget: null
  property int selectedAction: 0
  readonly property color foreground: bar ? bar.foreground : Color.foreground

  function open() {
    selectedAction = 0;
    controller.show();
    if (hostWidget) hostWidget.refresh();
  }
  function close() { controller.hide(); }
  function toggle() { opened ? close() : open(); }
  function launch(path) {
    if (hostWidget) hostWidget.openPage(path);
  }

  KeyboardPanel {
    id: popup
    bar: root.bar
    anchorItem: root.anchorItem
    owner: root.hostWidget || root
    open: root.opened
    focusTarget: keyCatcher
    contentWidth: popup.fittedContentWidth(Style.space(290))
    contentHeight: popup.fittedContentHeight(contents.implicitHeight)

    PanelKeyCatcher {
      id: keyCatcher
      anchors.fill: parent
      onCloseRequested: root.close()
      onTabRequested: function(direction) { root.selectedAction = 1 - root.selectedAction; }
      onMoveRequested: function(dx, dy) {
        if (dx !== 0 || dy !== 0) root.selectedAction = 1 - root.selectedAction;
      }
      onActivateRequested: root.launch(root.selectedAction === 0 ? "/#dailyReviewHeading" : "/")

      Column {
        id: contents
        width: parent.width
        spacing: Style.spacing.rowGap

        Text {
          width: parent.width
          text: "DLMS"
          textFormat: Text.PlainText
          color: root.foreground
          font.family: Style.font.family
          font.pixelSize: Style.font.title
          font.bold: true
        }

        Text {
          width: parent.width
          wrapMode: Text.WordWrap
          textFormat: Text.PlainText
          text: !root.hostWidget || root.hostWidget.status === "unconfigured"
            ? "Set the DLMS server URL in the widget settings."
            : root.hostWidget.status === "loading" ? "Checking DLMS…"
            : root.hostWidget.status === "offline" ? "DLMS unavailable"
            : root.hostWidget.status === "stale" ? "DLMS status needs refreshing"
            : root.hostWidget.dueQuestions + " questions due"
          color: root.foreground
          font.family: Style.font.family
          font.pixelSize: Style.font.body
        }

        Repeater {
          model: root.hostWidget && root.hostWidget.status === "ready"
            ? root.hostWidget.recommendations : []
          delegate: Text {
            required property string modelData
            width: contents.width
            wrapMode: Text.WordWrap
            textFormat: Text.PlainText
            text: "• " + modelData
            color: root.foreground
            font.family: Style.font.family
            font.pixelSize: Style.font.bodySmall
          }
        }

        Repeater {
          model: [
            { label: "Open Today's Review", path: "/#dailyReviewHeading" },
            { label: "Open DLMS", path: "/" }
          ]
          delegate: Rectangle {
            required property var modelData
            required property int index
            width: contents.width
            height: Style.spacing.popupRowHeight
            radius: Style.cornerRadius
            color: root.selectedAction === index
              ? Qt.rgba(Color.accent.r, Color.accent.g, Color.accent.b, 0.22)
              : "transparent"

            Text {
              anchors.centerIn: parent
              text: modelData.label
              textFormat: Text.PlainText
              color: root.foreground
              font.family: Style.font.family
              font.pixelSize: Style.font.body
            }
            MouseArea {
              anchors.fill: parent
              enabled: !!root.hostWidget && !!root.hostWidget.serverBase
              hoverEnabled: true
              cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
              onEntered: root.selectedAction = index
              onClicked: root.launch(modelData.path)
            }
          }
        }
      }
    }
  }
}
