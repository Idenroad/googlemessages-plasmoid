import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtWebEngine 1.15
import org.kde.plasma.plasmoid 2.0

PlasmoidItem {
    id: root

    property WebEngineProfile webProfile: WebEngineProfile {
        httpUserAgent: getUserAgent()
        storageName: "GoogleMessages"
        offTheRecord: false
        httpCacheType: WebEngineProfile.DiskHttpCache
        persistentCookiesPolicy: WebEngineProfile.ForcePersistentCookies
    }

    toolTipMainText: i18n("Google Messages Plasmoid")
    toolTipSubText: i18n("SMS messages from Android Phone")

    fullRepresentation: Item {
        width: 400
        height: 300

        Rectangle {
            anchors.fill: parent
            color: "transparent" // Set the background to transparent
            opacity: 0.8 // Adjust opacity for transparency effect

            ColumnLayout {
                anchors.fill: parent
                spacing: 10

                Text {
                    Layout.alignment: Qt.AlignHCenter
                    text: i18n("Google Messages")
                    font.pointSize: 14
                    color: "white"
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    color: "white"

                    WebEngineView {
                        id: webView
                        anchors.fill: parent
                        url: "https://messages.google.com/web/"
                        profile: root.webProfile

                        settings.javascriptCanAccessClipboard: true

                        onLinkHovered: hoveredUrl => {
                            if (hoveredUrl.toString() !== "") {
                                mouseArea.cursorShape = Qt.PointingHandCursor;
                            } else {
                                mouseArea.cursorShape = Qt.ArrowCursor;
                            }
                        }

                        onContextMenuRequested: request => {
                            if (request.mediaType === ContextMenuRequest.MediaTypeNone && request.linkUrl.toString() !== "") {
                                linkContextMenu.link = request.linkUrl;
                                linkContextMenu.open(request.position.x, request.position.y);
                                request.accepted = true;
                            }
                        }
                    }

                    BusyIndicator {
                        anchors.centerIn: parent
                        running: webView.loading
                        visible: webView.loading
                    }
                }

                Slider {
                    id: opacitySlider
                    Layout.fillWidth: true
                    from: 0.1
                    to: 1.0
                    stepSize: 0.1
                    value: 0.8
                    onValueChanged: {
                        root.opacity = value // Adjust the plasmoid's opacity
                    }
                }
            }
        }
    }

    compactRepresentation: Item {
        width: 100
        height: 50

        Text {
            anchors.centerIn: parent
            text: i18n("WebView")
            font.pixelSize: 18
            color: "white"
        }
    }
}



