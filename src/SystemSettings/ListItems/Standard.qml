import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Layouts 1.0

BaseListItem {
    id: base

    BaseLayout {
        title.text: base.text
    }
}
