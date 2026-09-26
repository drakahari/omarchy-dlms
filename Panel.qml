import QtQuick
import Quickshell.Io
import qs.Commons
import qs.Ui
import "Model.js" as Model

Panel {
  id: root
  moduleName: "drakahari.dlms"
  manageIpc: false
  property var anchorItem: null
  property var hostWidget: null
  property int selectedAction: 0
  property bool settingsOpen: false
  property string settingsFeedback: ""
  property string testUrl: ""
  readonly property color foreground: bar ? bar.foreground : Color.foreground

  function open() {
    selectedAction = 0;
    settingsOpen = false;
    controller.show();
    if (hostWidget) hostWidget.refresh();
  }
  function close() { controller.hide(); }
  function toggle() { opened ? close() : open(); }
  function launch(path) {
    if (hostWidget) hostWidget.openPage(path);
  }
  function showSettings() {
    settingsOpen = true;
    settingsFeedback = "";
    urlField.text = hostWidget ? String(hostWidget.setting("serverUrl", "")) : "";
    Qt.callLater(function() { urlField.forceActiveFocus(); });
  }
  function testConnection() {
    var base = Model.baseUrl(urlField.text);
    if (!base) { settingsFeedback = "Enter an HTTP or HTTPS base URL."; return; }
    if (testRequest.running) return;
    settingsFeedback = "Testing…";
    testUrl = base;
    testRequest.command = ["curl", "--fail", "--silent", "--max-time", "5",
      "--max-filesize", "1048576", "--proto", "=http,https",
      base + "/api/daily-review-plan"];
    testRequest.running = true;
  }
  function saveUrl() {
    var base = Model.baseUrl(urlField.text);
    if (!base) { settingsFeedback = "Enter an HTTP or HTTPS base URL."; return; }
    if (!hostWidget || !hostWidget.saveServerUrl(base)) {
      settingsFeedback = "Could not save the DLMS URL.";
      return;
    }
    urlField.text = base;
    settingsFeedback = "Saved.";
    Qt.callLater(function() { if (root.hostWidget) root.hostWidget.refresh(); });
  }

  Process {
    id: testRequest
    stdout: StdioCollector {
      waitForEnd: true
      onStreamFinished: {
        if (root.testUrl !== Model.baseUrl(urlField.text)) return;
        try {
          Model.reviewPlan(String(text || ""));
          root.settingsFeedback = "Connection successful.";
        } catch (error) {
          root.settingsFeedback = "DLMS unavailable or invalid response.";
        }
      }
    }
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
      blocked: root.settingsOpen && urlField.activeFocus
      onCloseRequested: root.close()
      onTabRequested: function(direction) { root.selectedAction = (root.selectedAction + direction + 3) % 3; }
      onMoveRequested: function(dx, dy) {
        if (dx !== 0 || dy !== 0) root.selectedAction = (root.selectedAction + 1) % 3;
      }
      onActivateRequested: {
        if (root.settingsOpen) root.saveUrl();
        else if (root.selectedAction === 2) root.showSettings();
        else root.launch(root.selectedAction === 0 ? "/#dailyReviewHeading" : "/");
      }

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

        Column {
          width: parent.width
          spacing: Style.spacing.rowGap
          visible: root.settingsOpen

          Text {
            text: "DLMS URL"
            textFormat: Text.PlainText
            color: root.foreground
            font.family: Style.font.family
            font.pixelSize: Style.font.body
          }
          TextField {
            id: urlField
            width: parent.width
            placeholderText: "http://127.0.0.1:9001"
            foreground: root.foreground
            onTextChanged: root.settingsFeedback = ""
            onAccepted: root.saveUrl()
            Keys.onEscapePressed: {
              root.settingsOpen = false;
              keyCatcher.forceActiveFocus();
            }
          }
          Row {
            spacing: Style.spacing.rowGap
            Repeater {
              model: ["Test Connection", "Save", "Back"]
              delegate: Rectangle {
                required property string modelData
                width: actionText.implicitWidth + Style.space(16)
                height: Style.spacing.popupRowHeight
                radius: Style.cornerRadius
                color: Qt.rgba(Color.accent.r, Color.accent.g, Color.accent.b, 0.22)
                Text {
                  id: actionText
                  anchors.centerIn: parent
                  text: modelData
                  textFormat: Text.PlainText
                  color: root.foreground
                  font.family: Style.font.family
                  font.pixelSize: Style.font.bodySmall
                }
                MouseArea {
                  anchors.fill: parent
                  cursorShape: Qt.PointingHandCursor
                  onClicked: {
                    if (modelData === "Test Connection") root.testConnection();
                    else if (modelData === "Save") root.saveUrl();
                    else { root.settingsOpen = false; keyCatcher.forceActiveFocus(); }
                  }
                }
              }
            }
          }
          Text {
            width: parent.width
            visible: root.settingsFeedback !== ""
            text: root.settingsFeedback
            textFormat: Text.PlainText
            wrapMode: Text.WordWrap
            color: root.foreground
            font.family: Style.font.family
            font.pixelSize: Style.font.bodySmall
          }
        }

        Text {
          visible: !root.settingsOpen
          width: parent.width
          wrapMode: Text.WordWrap
          textFormat: Text.PlainText
          text: !root.hostWidget || root.hostWidget.status === "unconfigured"
            ? "Set the DLMS URL in Settings."
            : root.hostWidget.status === "loading" ? "Checking DLMS…"
            : root.hostWidget.status === "offline" ? "DLMS unavailable"
            : root.hostWidget.status === "stale" ? "DLMS status needs refreshing"
            : root.hostWidget.dueQuestions + " questions due"
          color: root.foreground
          font.family: Style.font.family
          font.pixelSize: Style.font.body
        }

        Repeater {
          model: !root.settingsOpen && root.hostWidget && root.hostWidget.status === "ready"
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
          model: root.settingsOpen ? [] : [
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

        Rectangle {
          visible: !root.settingsOpen
          width: contents.width
          height: Style.spacing.popupRowHeight
          radius: Style.cornerRadius
          color: root.selectedAction === 2
            ? Qt.rgba(Color.accent.r, Color.accent.g, Color.accent.b, 0.22) : "transparent"
          Text {
            anchors.centerIn: parent
            text: "⚙ Settings"
            textFormat: Text.PlainText
            color: root.foreground
            font.family: Style.font.family
            font.pixelSize: Style.font.bodySmall
          }
          MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onEntered: root.selectedAction = 2
            onClicked: root.showSettings()
          }
        }
      }
    }
  }
}
