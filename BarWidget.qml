import QtQuick
import Quickshell.Io
import qs.Commons
import qs.Ui
import "Model.js" as Model

BarWidget {
  id: root
  moduleName: "drakahari.dlms"

  readonly property string serverBase: Model.baseUrl(setting("serverUrl", ""))
  property string status: "unconfigured" // unconfigured, loading, ready, offline, stale
  property int dueQuestions: 0
  property var recommendations: []
  property string requestBase: ""
  property double lastSuccessAt: 0

  readonly property bool opened: panelLoader.item ? panelLoader.item.opened : false
  readonly property bool popoutSwitchClosing: panelLoader.item ? panelLoader.item.popoutSwitchClosing : false

  function refresh() {
    if (request.running) return;
    recommendations = [];
    dueQuestions = 0;
    lastSuccessAt = 0;
    if (!serverBase) {
      status = "unconfigured";
      return;
    }
    status = "loading";
    requestBase = serverBase;
    request.command = ["curl", "--fail", "--silent", "--show-error", "--max-time", "5",
      "--max-filesize", "1048576", "--proto", "=http,https",
      requestBase + "/api/daily-review-plan"];
    request.running = true;
  }

  function openPage(path) {
    var url = Model.pageUrl(serverBase, path);
    if (!url) return;
    browser.command = ["xdg-open", url];
    browser.running = true;
    close();
  }

  function saveServerUrl(base) {
    if (serverBase === base) return true;
    if (!bar || !bar.shell || !bar.shell.updateEntryInline) return false;
    var next = {};
    var current = settings || {};
    for (var key in current) next[key] = current[key];
    next.serverUrl = base;
    return bar.shell.updateEntryInline(moduleName, next);
  }

  function injectPanel() {
    if (!panelLoader.item) return;
    panelLoader.item.bar = root.bar;
    panelLoader.item.anchorItem = button;
    panelLoader.item.hostWidget = root;
  }

  function open() {
    if (panelLoader.item) panelLoader.item.open();
  }
  function close() {
    if (panelLoader.item) panelLoader.item.close();
  }
  function togglePanel() {
    if (panelLoader.item) panelLoader.item.toggle();
  }
  function toggle() { togglePanel(); }
  function closeForPopoutSwitch() {
    if (panelLoader.item) panelLoader.item.closeForPopoutSwitch();
  }

  implicitWidth: button.implicitWidth
  implicitHeight: button.implicitHeight
  onBarChanged: injectPanel()
  onServerBaseChanged: {
    dueQuestions = 0;
    recommendations = [];
    lastSuccessAt = 0;
    status = serverBase ? "loading" : "unconfigured";
    Qt.callLater(refresh);
  }
  Component.onCompleted: refresh()

  Timer {
    interval: 10 * 60 * 1000
    repeat: true
    running: true
    onTriggered: root.refresh()
  }

  Timer {
    interval: 60 * 1000
    repeat: true
    running: true
    onTriggered: {
      if (root.status === "ready" && Date.now() - root.lastSuccessAt > 10 * 60 * 1000) {
        root.dueQuestions = 0;
        root.recommendations = [];
        root.status = "stale";
      }
    }
  }

  Process {
    id: request
    onExited: {
      if (root.requestBase !== root.serverBase) Qt.callLater(root.refresh);
    }
    stdout: StdioCollector {
      waitForEnd: true
      onStreamFinished: {
        if (root.requestBase !== root.serverBase) {
          Qt.callLater(root.refresh);
          return;
        }
        try {
          var result = Model.reviewPlan(String(text || ""));
          root.dueQuestions = result.due;
          root.recommendations = result.recommendations;
          root.lastSuccessAt = Date.now();
          root.status = "ready";
        } catch (error) {
          root.dueQuestions = 0;
          root.recommendations = [];
          root.status = "offline";
        }
      }
    }
  }

  Process { id: browser }

  Loader {
    id: panelLoader
    active: true
    source: Qt.resolvedUrl("Panel.qml")
    visible: false
    onLoaded: {
      root.injectPanel();
      Qt.callLater(root.injectPanel);
    }
  }

  WidgetButton {
    id: button
    anchors.fill: parent
    bar: root.bar
    text: countLabel
    labelVisible: false
    fixedWidth: root.vertical ? -1 : labelRow.implicitWidth + scaledHorizontalMargin * 2
    fixedHeight: root.vertical ? labelColumn.implicitHeight + scaledVerticalPadding * 2 : -1
    tooltipText: root.status === "ready"
      ? "DLMS: " + root.dueQuestions + " questions due"
      : root.status === "unconfigured" ? "Set the DLMS URL" : "DLMS " + root.status
    readonly property string countLabel: root.status === "ready" ? String(root.dueQuestions)
      : root.status === "loading" ? "…"
      : root.status === "unconfigured" ? "setup" : "—"

    Row {
      id: labelRow
      visible: !root.vertical
      anchors.centerIn: parent
      spacing: Style.space(4)
      Item {
        width: Style.space(18)
        height: Style.space(18)
        Image {
          anchors.fill: parent
          source: Qt.resolvedUrl("dlms-icon.png")
          fillMode: Image.PreserveAspectFit
          smooth: true
        }
      }
      Text {
        text: "· " + button.countLabel
        textFormat: Text.PlainText
        color: button.foreground
        font.family: button.fontFamily
        font.pixelSize: button.fontSize
      }
    }
    Column {
      id: labelColumn
      visible: root.vertical
      anchors.centerIn: parent
      spacing: Style.space(2)
      Item {
        width: Style.space(18)
        height: Style.space(18)
        anchors.horizontalCenter: parent.horizontalCenter
        Image {
          anchors.fill: parent
          source: Qt.resolvedUrl("dlms-icon.png")
          fillMode: Image.PreserveAspectFit
          smooth: true
        }
      }
      Text {
        anchors.horizontalCenter: parent.horizontalCenter
        text: button.countLabel
        textFormat: Text.PlainText
        color: button.foreground
        font.family: button.fontFamily
        font.pixelSize: button.fontSize
      }
    }
    onPressed: function(buttonCode) {
      if (buttonCode === Qt.LeftButton) root.togglePanel();
    }
  }
}
