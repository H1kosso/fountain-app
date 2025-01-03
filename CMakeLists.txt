cmake_minimum_required(VERSION 3.27)

find_package(Qt6 6.5 REQUIRED COMPONENTS Gui Quick Sql)

qt_standard_project_setup(REQUIRES 6.5)

set(QML_FILES
    main.qml
    qml/components/Home.qml
    qml/components/Menu.qml
    qml/components/PaintAnimation.qml
    qml/components/Settings.qml
    qml/components/Toolbar.qml
    qml/components/Gallery.qml

    qml/components/gallery/ImagePreview.qml
    qml/components/gallery/RowDelegate.qml
    qml/components/settings/EmailDelegate.qml
    qml/components/settings/Divider.qml

    qml/utils/MyTheme.qml
    qml/utils/ApiManager.qml
    qml/utils/WebSocketManager.qml
    qml/utils/ImageInfo.qml
    qml/controls/MenuButton.qml
    qml/controls/ToolbarButton.qml
    qml/controls/ColorPicker.qml
)

qt_add_executable( fountain
    main.cpp
)

qt_add_resources(fountain "fountain_assets"
    PREFIX "/"
    BIG_RESOURCES
    FILES
    assets/img/dog.jpg

    assets/icons/bluetooth.png
    assets/icons/clock.png
    assets/icons/close.png
    assets/icons/delete.png
    assets/icons/email.png
    assets/icons/fountain.png
    assets/icons/gallery.png
    assets/icons/home.png
    assets/icons/menu.png
    assets/icons/paint.png
    assets/icons/save.png
    assets/icons/settings.png

)

qt_add_qml_module(fountain
    URI com.fountain
    VERSION 1.0
    NO_RESOURCE_TARGET_PATH
    DEPENDENCIES QtQuick
    QML_FILES ${QML_FILES}
    SOURCES
    singleimage.cpp singleimage.h
)
include_directories(${CMAKE_CURRENT_SOURCE_DIR})
set_target_properties(fountain PROPERTIES
    WIN32_EXECUTABLE TRUE
)
target_link_libraries(fountain PRIVATE Qt6::Gui Qt6::Quick)
