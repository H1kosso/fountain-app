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
)

qt_add_executable( fountain
    main.cpp
)

qt_add_resources(fountain "fountain_assets"
    PREFIX "/"
    BIG_RESOURCES
    FILES
        assets/img/dog.jpg

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
