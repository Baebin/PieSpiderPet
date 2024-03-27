//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <flutter_auto_gui_windows/flutter_auto_gui_windows.h>
#include <mouse_event/mouse_event_plugin.h>
#include <screen_retriever/screen_retriever_plugin.h>
#include <window_manager/window_manager_plugin.h>

void RegisterPlugins(flutter::PluginRegistry* registry) {
  FlutterAutoGuiWindowsRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("FlutterAutoGuiWindows"));
  MouseEventPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("MouseEventPlugin"));
  ScreenRetrieverPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("ScreenRetrieverPlugin"));
  WindowManagerPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("WindowManagerPlugin"));
}
