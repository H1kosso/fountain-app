cmake_minimum_required(VERSION 3.27)

find_package(Qt6 6.5 REQUIRED COMPONENTS Gui Quick Sql Bluetooth)

qt_standard_project_setup(REQUIRES 6.5)

set(QML_FILES
    main.qml
    qml/components/Home.qml
    qml/components/Menu.qml
    qml/components/PaintAnimation.qml
    qml/components/Settings.qml
    qml/components/Toolbar.qml
    qml/components/Gallery.qml
    qml/components/Bluetooth.qml
    qml/components/Login.qml
    qml/components/DeviceMemoryImage.qml
    qml/components/Logs.qml
    qml/components/About.qml


    qml/components/gallery/RowDelegate.qml
    qml/components/settings/EmailDelegate.qml
    qml/components/settings/Divider.qml

    qml/utils/MyTheme.qml
    qml/utils/ApiManager.qml

    qml/utils/ImageInfo.qml

    qml/controls/MenuButton.qml
    qml/controls/CustomButton.qml
    qml/controls/ColorPicker.qml
    qml/controls/CustomTextInput.qml
)

qt_add_executable( fountain
    main.cpp
)

if(ANDROID)
    set_property(TARGET fountain APPEND PROPERTY
        QT_ANDROID_PACKAGE_SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/android
    )
    include(3rdparty/android-openssl/android_openssl.cmake)
    add_android_openssl_libraries(fountain)
endif()



qt_add_resources(fountain "fountain_assets"
    PREFIX "/"
    BIG_RESOURCES
    FILES
    assets/img/preview.jfif
    assets/img/ki.jpg

    assets/icons/info.png
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
    assets/icons/add.png
    assets/icons/paint-brush.png
    assets/icons/eraser.png
    assets/icons/refresh.png
    assets/icons/confirmation.png
    assets/icons/terminal.png
    assets/icons/eye.png
    assets/icons/undo.png
    assets/icons/paint-brush1.png
    assets/icons/paint-brush2.png
    assets/icons/paint-brush3.png
    assets/icons/logout.png
    assets/icons/no-pictures.png
    assets/icons/play-button.png
    assets/icons/log.png
    assets/icons/on.png
    assets/icons/off.png
    assets/icons/bt-upload.png


)

qt_add_qml_module(fountain
    URI com.fountain
    VERSION 1.0
    NO_RESOURCE_TARGET_PATH
    DEPENDENCIES QtQuick
    QML_FILES ${QML_FILES}
    SOURCES
    singleimage.cpp singleimage.h
    bledevice.cpp bledevice.h
    deviceinfo.cpp deviceinfo.h

)



include_directories(${CMAKE_CURRENT_SOURCE_DIR})
set_target_properties(fountain PROPERTIES
    WIN32_EXECUTABLE TRUE
)
target_link_libraries(fountain PRIVATE Qt6::Gui Qt6::Quick Qt::Bluetooth)

if (APPLE)
    if (IOS)
        set_target_properties(fountain PROPERTIES
            MACOSX_BUNDLE_INFO_PLIST "${CMAKE_CURRENT_SOURCE_DIR}/Info.cmake.ios.plist"
        )
else()
    set_target_properties(fountain PROPERTIES
        MACOSX_BUNDLE_INFO_PLIST "${CMAKE_CURRENT_SOURCE_DIR}/Info.cmake.macos.plist"
    )
endif()
endif()
# TODO REPLACE PATH
if (ANDROID)
    include(C:/Users/Marcin/AppData/Local/Android/Sdk/android_openssl/CMakeLists.txt)
endif()
