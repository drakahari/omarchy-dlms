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

  Shape {
    visible: !root.useColorIcon
    width: 64
    height: 64
    transformOrigin: Item.TopLeft
    scale: Math.min(root.width, root.height) / 64
    x: (root.width - 64 * scale) / 2
    y: (root.height - 64 * scale) / 2

    ShapePath {
      strokeColor: "transparent"
      fillColor: root.foreground
      // Derived from the bundled DLMS favicon: ring, DLMS lettering, and swoosh.
      PathSvg { path: "M28 4h8v1h-8zM24 5h16v1h-16zM21 6h22v1h-22zM19 7h10v1h-10zM35 7h10v1h-10zM18 8h7v1h-7zM40 8h7v1h-7zM16 9h6v1h-6zM42 9h6v1h-6zM15 10h5v1h-5zM44 10h5v1h-5zM14 11h4v1h-4zM46 11h4v1h-4zM13 12h4v1h-4zM47 12h5v1h-5zM12 13h4v1h-4zM48 13h4v1h-4zM11 14h4v1h-4zM49 14h4v1h-4zM10 15h4v1h-4zM50 15h4v1h-4zM9 16h4v1h-4zM51 16h4v1h-4zM9 17h3v1h-3zM52 17h3v1h-3zM8 18h4v1h-4zM53 18h3v1h-3zM8 19h3v1h-3zM53 19h4v1h-4zM7 20h3v2h-3zM54 20h3v2h-3zM6 22h3v3h-3zM55 22h3v3h-3zM13 24h7v1h-7zM24 24h2v1h-2zM32 24h3v2h-3zM40 24h3v1h-3zM45 24h7v1h-7zM5 25h3v13h-3zM13 25h8v1h-8zM23 25h3v3h-3zM39 25h4v1h-4zM44 25h8v1h-8zM56 25h3v13h-3zM13 26h2v1h-2zM19 26h3v5h-3zM31 26h5v2h-5zM38 26h5v1h-5zM44 26h2v2h-2zM12 27h3v4h-3zM37 27h5v1h-5zM23 28h2v3h-2zM31 28h8v1h-8zM40 28h2v3h-2zM44 28h6v1h-6zM31 29h2v2h-2zM35 29h3v2h-3zM44 29h8v1h-8zM49 30h3v2h-3zM12 31h2v1h-2zM18 31h3v1h-3zM22 31h3v1h-3zM30 31h3v3h-3zM39 31h3v3h-3zM12 32h9v1h-9zM22 32h7v2h-7zM43 32h9v1h-9zM11 33h9v1h-9zM43 33h8v1h-8zM29 34h1v1h-1zM31 34h2v1h-2zM40 34h2v1h-2zM51 34h2v1h-2zM48 35h4v1h-4zM28 36h22v1h-22zM19 37h27v1h-27zM6 38h3v3h-3zM16 38h23v1h-23zM55 38h3v3h-3zM14 39h18v1h-18zM14 40h12v1h-12zM7 41h3v2h-3zM15 41h6v1h-6zM54 41h3v2h-3zM8 43h3v1h-3zM53 43h3v2h-3zM8 44h4v1h-4zM9 45h3v1h-3zM52 45h3v1h-3zM9 46h4v1h-4zM51 46h4v1h-4zM10 47h4v1h-4zM50 47h4v1h-4zM11 48h4v1h-4zM49 48h4v1h-4zM12 49h4v1h-4zM48 49h4v1h-4zM13 50h4v1h-4zM47 50h4v1h-4zM14 51h4v1h-4zM46 51h4v1h-4zM15 52h5v1h-5zM44 52h5v1h-5zM16 53h6v1h-6zM42 53h6v1h-6zM18 54h7v1h-7zM40 54h6v1h-6zM20 55h9v1h-9zM35 55h9v1h-9zM22 56h20v1h-20zM25 57h14v1h-14z" }
    }
  }
}
