Thread: Render thread
Stacktrace:
	at java.nio.file.Path.toFile(Path.java:771) ~[?:?] {re:computing_frames}
	at net.optifine.util.ResUtils.collectFiles(ResUtils.java:88) ~[preview_OptiFine_1.20.1_HD_U_I6_pre6.jar%23293!/:?] {re:classloading}
	at net.optifine.util.ResUtils.collectFiles(ResUtils.java:63) ~[preview_OptiFine_1.20.1_HD_U_I6_pre6.jar%23293!/:?] {re:classloading}
	at net.optifine.CustomItems.update(CustomItems.java:163) ~[preview_OptiFine_1.20.1_HD_U_I6_pre6.jar%23293!/:?] {re:classloading}
	at net.optifine.CustomItems.update(CustomItems.java:117) ~[preview_OptiFine_1.20.1_HD_U_I6_pre6.jar%23293!/:?] {re:classloading}
	at net.optifine.util.TextureUtils.resourcesPreReload(TextureUtils.java:310) ~[preview_OptiFine_1.20.1_HD_U_I6_pre6.jar%23293!/:?] {re:classloading}
	at net.minecraft.server.packs.resources.ReloadableResourceManager.m_142463_(ReloadableResourceManager.java:56) ~[client-1.20.1-20230612.114412-srg.jar%23238!/:?] {re:classloading,xf:OptiFine:default}
	at net.minecraft.client.Minecraft.m_168019_(Minecraft.java:879) ~[client-1.20.1-20230612.114412-srg.jar%23238!/:?] {re:mixin,pl:accesstransformer:B,pl:runtimedistcleaner:A,re:classloading,pl:accesstransformer:B,pl:mixin:A,pl:runtimedistcleaner:A}
	at net.minecraft.client.Minecraft.m_91391_(Minecraft.java:861) ~[client-1.20.1-20230612.114412-srg.jar%23238!/:?] {re:mixin,pl:accesstransformer:B,pl:runtimedistcleaner:A,re:classloading,pl:accesstransformer:B,pl:mixin:A,pl:runtimedistcleaner:A}
	at net.minecraft.client.Options.m_274546_(Options.java:958) ~[client-1.20.1-20230612.114412-srg.jar%23238!/:?] {re:mixin,pl:accesstransformer:B,xf:OptiFine:default,re:classloading,pl:accesstransformer:B,xf:OptiFine:default}
	at net.minecraft.client.gui.screens.OptionsScreen.m_274373_(OptionsScreen.java:97) ~[client-1.20.1-20230612.114412-srg.jar%23238!/:?] {re:classloading,pl:runtimedistcleaner:A}
	at net.minecraft.client.gui.screens.packs.PackSelectionModel.m_99923_(PackSelectionModel.java:59) ~[client-1.20.1-20230612.114412-srg.jar%23238!/:?] {re:classloading,pl:runtimedistcleaner:A}
	at net.minecraft.client.gui.screens.packs.PackSelectionScreen.m_7379_(PackSelectionScreen.java:73) ~[client-1.20.1-20230612.114412-srg.jar%23238!/:?] {re:classloading,pl:runtimedistcleaner:A}
	at net.minecraft.client.gui.screens.packs.PackSelectionScreen.m_100035_(PackSelectionScreen.java:99) ~[client-1.20.1-20230612.114412-srg.jar%23238!/:?] {re:classloading,pl:runtimedistcleaner:A}
	at net.minecraft.client.gui.components.Button.m_5691_(Button.java:38) ~[client-1.20.1-20230612.114412-srg.jar%23238!/:?] {re:classloading,pl:runtimedistcleaner:A,re:mixin,pl:runtimedistcleaner:A}
	at net.minecraft.client.gui.components.AbstractButton.m_5716_(AbstractButton.java:55) ~[client-1.20.1-20230612.114412-srg.jar%23238!/:?] {re:mixin,pl:runtimedistcleaner:A,re:classloading,pl:mixin:APP:tacz.mixins.json:client.AbstractButtonMixin,pl:mixin:A,pl:runtimedistcleaner:A}
	at net.minecraft.client.gui.components.AbstractWidget.m_6375_(AbstractWidget.java:175) ~[client-1.20.1-20230612.114412-srg.jar%23238!/:?] {re:mixin,pl:accesstransformer:B,pl:runtimedistcleaner:A,re:classloading,pl:accesstransformer:B,pl:runtimedistcleaner:A}
	at net.minecraft.client.gui.components.events.ContainerEventHandler.m_6375_(ContainerEventHandler.java:38) ~[client-1.20.1-20230612.114412-srg.jar%23238!/:?] {re:computing_frames,re:mixin,re:classloading}
	at net.minecraft.client.MouseHandler.m_168084_(MouseHandler.java:92) ~[client-1.20.1-20230612.114412-srg.jar%23238!/:?] {re:mixin,pl:runtimedistcleaner:A,re:classloading,pl:mixin:APP:cgm.mixins.json:client.MouseHandlerMixin,pl:mixin:APP:tacz.mixins.json:client.MouseHandlerMixin,pl:mixin:APP:balm.mixins.json:MouseHandlerAccessor,pl:mixin:A,pl:runtimedistcleaner:A}
	at net.minecraft.client.gui.screens.Screen.m_96579_(Screen.java:437) ~[client-1.20.1-20230612.114412-srg.jar%23238!/:?] {re:mixin,pl:accesstransformer:B,pl:runtimedistcleaner:A,re:computing_frames,pl:accesstransformer:B,pl:runtimedistcleaner:A,re:classloading,pl:accesstransformer:B,pl:mixin:APP:journeymap.mixins.json:client.ScreenAccessor,pl:mixin:APP:journeymap.mixins.json:client.ScreenTooltipMixin,pl:mixin:APP:balm.mixins.json:ScreenAccessor,pl:mixin:A,pl:runtimedistcleaner:A}
	at net.minecraft.client.MouseHandler.m_91530_(MouseHandler.java:89) ~[client-1.20.1-20230612.114412-srg.jar%23238!/:?] {re:mixin,pl:runtimedistcleaner:A,re:classloading,pl:mixin:APP:cgm.mixins.json:client.MouseHandlerMixin,pl:mixin:APP:tacz.mixins.json:client.MouseHandlerMixin,pl:mixin:APP:balm.mixins.json:MouseHandlerAccessor,pl:mixin:A,pl:runtimedistcleaner:A}
	at net.minecraft.client.MouseHandler.m_168091_(MouseHandler.java:189) ~[client-1.20.1-20230612.114412-srg.jar%23238!/:?] {re:mixin,pl:runtimedistcleaner:A,re:classloading,pl:mixin:APP:cgm.mixins.json:client.MouseHandlerMixin,pl:mixin:APP:tacz.mixins.json:client.MouseHandlerMixin,pl:mixin:APP:balm.mixins.json:MouseHandlerAccessor,pl:mixin:A,pl:runtimedistcleaner:A}
	at net.minecraft.util.thread.BlockableEventLoop.execute(BlockableEventLoop.java:118) ~[client-1.20.1-20230612.114412-srg.jar%23238!/:?] {re:mixin,pl:accesstransformer:B,xf:OptiFine:default,re:computing_frames,pl:accesstransformer:B,xf:OptiFine:default,re:classloading,pl:accesstransformer:B,xf:OptiFine:default}
	at net.minecraft.client.MouseHandler.m_91565_(MouseHandler.java:188) ~[client-1.20.1-20230612.114412-srg.jar%23238!/:?] {re:mixin,pl:runtimedistcleaner:A,re:classloading,pl:mixin:APP:cgm.mixins.json:client.MouseHandlerMixin,pl:mixin:APP:tacz.mixins.json:client.MouseHandlerMixin,pl:mixin:APP:balm.mixins.json:MouseHandlerAccessor,pl:mixin:A,pl:runtimedistcleaner:A}
	at org.lwjgl.glfw.GLFWMouseButtonCallback$Container.invoke(GLFWMouseButtonCallback.java:81) ~[lwjgl-glfw-3.3.1.jar%23131!/:build 7] {}
	at bre2el.fpsreducer.handler.glfw.InputEventHandler$MouseButtonEventHandler.invoke(InputEventHandler.java:133) ~[FpsReducer2-forge-1.20.1-2.5.1.jar%23214!/:1.20.1-2.5.1] {re:classloading}
	at org.lwjgl.glfw.GLFWMouseButtonCallbackI.callback(GLFWMouseButtonCallbackI.java:43) ~[lwjgl-glfw-3.3.1.jar%23131!/:build 7] {}
	at org.lwjgl.system.JNI.invokeV(Native Method) ~[lwjgl-3.3.1.jar%23143!/:build 7] {}
	at org.lwjgl.glfw.GLFW.glfwPollEvents(GLFW.java:3403) ~[lwjgl-glfw-3.3.1.jar%23131!/:build 7] {re:mixin}
	at com.mojang.blaze3d.systems.RenderSystem.pollEvents(RenderSystem.java:210) ~[client-1.20.1-20230612.114412-srg.jar%23238!/:?] {re:mixin,xf:OptiFine:default,re:classloading,xf:OptiFine:default,pl:mixin:APP:fpsreducer.mixins.json:RenderSystemMixin,pl:mixin:A}
	at com.mojang.blaze3d.systems.RenderSystem.flipFrame(RenderSystem.java:221) ~[client-1.20.1-20230612.114412-srg.jar%23238!/:?] {re:mixin,xf:OptiFine:default,re:classloading,xf:OptiFine:default,pl:mixin:APP:fpsreducer.mixins.json:RenderSystemMixin,pl:mixin:A}
-- Affected screen --
Details:
	Screen name: net.minecraft.client.gui.screens.packs.PackSelectionScreen
Stacktrace:
	at net.minecraft.client.gui.screens.Screen.m_96579_(Screen.java:437) ~[client-1.20.1-20230612.114412-srg.jar%23238!/:?] {re:mixin,pl:accesstransformer:B,pl:runtimedistcleaner:A,re:computing_frames,pl:accesstransformer:B,pl:runtimedistcleaner:A,re:classloading,pl:accesstransformer:B,pl:mixin:APP:journeymap.mixins.json:client.ScreenAccessor,pl:mixin:APP:journeymap.mixins.json:client.ScreenTooltipMixin,pl:mixin:APP:balm.mixins.json:ScreenAccessor,pl:mixin:A,pl:runtimedistcleaner:A}
	at net.minecraft.client.MouseHandler.m_91530_(MouseHandler.java:89) ~[client-1.20.1-20230612.114412-srg.jar%23238!/:?] {re:mixin,pl:runtimedistcleaner:A,re:classloading,pl:mixin:APP:cgm.mixins.json:client.MouseHandlerMixin,pl:mixin:APP:tacz.mixins.json:client.MouseHandlerMixin,pl:mixin:APP:balm.mixins.json:MouseHandlerAccessor,pl:mixin:A,pl:runtimedistcleaner:A}
	at net.minecraft.client.MouseHandler.m_168091_(MouseHandler.java:189) ~[client-1.20.1-20230612.114412-srg.jar%23238!/:?] {re:mixin,pl:runtimedistcleaner:A,re:classloading,pl:mixin:APP:cgm.mixins.json:client.MouseHandlerMixin,pl:mixin:APP:tacz.mixins.json:client.MouseHandlerMixin,pl:mixin:APP:balm.mixins.json:MouseHandlerAccessor,pl:mixin:A,pl:runtimedistcleaner:A}
	at net.minecraft.util.thread.BlockableEventLoop.execute(BlockableEventLoop.java:118) ~[client-1.20.1-20230612.114412-srg.jar%23238!/:?] {re:mixin,pl:accesstransformer:B,xf:OptiFine:default,re:computing_frames,pl:accesstransformer:B,xf:OptiFine:default,re:classloading,pl:accesstransformer:B,xf:OptiFine:default}
	at net.minecraft.client.MouseHandler.m_91565_(MouseHandler.java:188) ~[client-1.20.1-20230612.114412-srg.jar%23238!/:?] {re:mixin,pl:runtimedistcleaner:A,re:classloading,pl:mixin:APP:cgm.mixins.json:client.MouseHandlerMixin,pl:mixin:APP:tacz.mixins.json:client.MouseHandlerMixin,pl:mixin:APP:balm.mixins.json:MouseHandlerAccessor,pl:mixin:A,pl:runtimedistcleaner:A}
	at org.lwjgl.glfw.GLFWMouseButtonCallback$Container.invoke(GLFWMouseButtonCallback.java:81) ~[lwjgl-glfw-3.3.1.jar%23131!/:build 7] {}
	at bre2el.fpsreducer.handler.glfw.InputEventHandler$MouseButtonEventHandler.invoke(InputEventHandler.java:133) ~[FpsReducer2-forge-1.20.1-2.5.1.jar%23214!/:1.20.1-2.5.1] {re:classloading}
	at org.lwjgl.glfw.GLFWMouseButtonCallbackI.callback(GLFWMouseButtonCallbackI.java:43) ~[lwjgl-glfw-3.3.1.jar%23131!/:build 7] {}
	at org.lwjgl.system.JNI.invokeV(Native Method) ~[lwjgl-3.3.1.jar%23143!/:build 7] {}
	at org.lwjgl.glfw.GLFW.glfwPollEvents(GLFW.java:3403) ~[lwjgl-glfw-3.3.1.jar%23131!/:build 7] {re:mixin}
	at com.mojang.blaze3d.systems.RenderSystem.pollEvents(RenderSystem.java:210) ~[client-1.20.1-20230612.114412-srg.jar%23238!/:?] {re:mixin,xf:OptiFine:default,re:classloading,xf:OptiFine:default,pl:mixin:APP:fpsreducer.mixins.json:RenderSystemMixin,pl:mixin:A}
	at com.mojang.blaze3d.systems.RenderSystem.flipFrame(RenderSystem.java:221) ~[client-1.20.1-20230612.114412-srg.jar%23238!/:?] {re:mixin,xf:OptiFine:default,re:classloading,xf:OptiFine:default,pl:mixin:APP:fpsreducer.mixins.json:RenderSystemMixin,pl:mixin:A}
	at com.mojang.blaze3d.platform.Window.m_85435_(Window.java:376) ~[client-1.20.1-20230612.114412-srg.jar%23238!/:?] {re:mixin,xf:OptiFine:default,re:classloading,xf:OptiFine:default,pl:mixin:APP:fpsreducer.mixins.json:WindowMixin,pl:mixin:A}
	at net.minecraft.client.Minecraft.m_91383_(Minecraft.java:1170) ~[client-1.20.1-20230612.114412-srg.jar%23238!/:?] {re:mixin,pl:accesstransformer:B,pl:runtimedistcleaner:A,re:classloading,pl:accesstransformer:B,pl:mixin:A,pl:runtimedistcleaner:A}
	at net.minecraft.client.Minecraft.m_91374_(Minecraft.java:718) ~[client-1.20.1-20230612.114412-srg.jar%23238!/:?] {re:mixin,pl:accesstransformer:B,pl:runtimedistcleaner:A,re:classloading,pl:accesstransformer:B,pl:mixin:A,pl:runtimedistcleaner:A}
	at net.minecraft.client.main.Main.main(Main.java:218) ~[tac.jar:?] {re:classloading,pl:runtimedistcleaner:A}
	at jdk.internal.reflect.NativeMethodAccessorImpl.invoke0(Native Method) ~[?:?] {}
	at jdk.internal.reflect.NativeMethodAccessorImpl.invoke(NativeMethodAccessorImpl.java:77) ~[?:?] {}
	at jdk.internal.reflect.DelegatingMethodAccessorImpl.invoke(DelegatingMethodAccessorImpl.java:43) ~[?:?] {}
	at java.lang.reflect.Method.invoke(Method.java:569) ~[?:?] {}
	at net.minecraftforge.fml.loading.targets.CommonLaunchHandler.runTarget(CommonLaunchHandler.java:111) ~[fmlloader-1.20.1-47.4.10.jar:?] {}
	at net.minecraftforge.fml.loading.targets.CommonLaunchHandler.clientService(CommonLaunchHandler.java:99) ~[fmlloader-1.20.1-47.4.10.jar:?] {}
	at net.minecraftforge.fml.loading.targets.CommonClientLaunchHandler.lambda$makeService$0(CommonClientLaunchHandler.java:25) ~[fmlloader-1.20.1-47.4.10.jar:?] {}
	at cpw.mods.modlauncher.LaunchServiceHandlerDecorator.launch(LaunchServiceHandlerDecorator.java:30) ~[modlauncher-10.0.9.jar:?] {}
	at cpw.mods.modlauncher.LaunchServiceHandler.launch(LaunchServiceHandler.java:53) ~[modlauncher-10.0.9.jar:?] {}
	at cpw.mods.modlauncher.LaunchServiceHandler.launch(LaunchServiceHandler.java:71) ~[modlauncher-10.0.9.jar:?] {}
	at cpw.mods.modlauncher.Launcher.run(Launcher.java:108) ~[modlauncher-10.0.9.jar:?] {}
	at cpw.mods.modlauncher.Launcher.main(Launcher.java:78) ~[modlauncher-10.0.9.jar:?] {}
	at cpw.mods.modlauncher.BootstrapLaunchConsumer.accept(BootstrapLaunchConsumer.java:26) ~[modlauncher-10.0.9.jar:?] {}
	at cpw.mods.modlauncher.BootstrapLaunchConsumer.accept(BootstrapLaunchConsumer.java:23) ~[modlauncher-10.0.9.jar:?] {}
	at cpw.mods.bootstraplauncher.BootstrapLauncher.main(BootstrapLauncher.java:141) ~[bootstraplauncher-1.1.2.jar:?] {}


-- Affected level --
Details:
	All players: 1 total; [LocalPlayer['yudhioktavian'/86, l='ClientLevel', x=49.89, y=63.00, z=-259.41]]
	Chunk stats: 361, 201
	Level dimension: minecraft:overworld
	Level spawn location: World: (48,70,32), Section: (at 0,6,0 in 3,4,2; chunk contains blocks 48,-64,32 to 63,319,47), Region: (0,0; contains chunks 0,0 to 31,31, blocks 0,-64,0 to 511,319,511)
	Level time: 8974 game time, 8974 day time
	Server brand: forge
	Server type: Integrated singleplayer server
Stacktrace:
	at net.minecraft.client.multiplayer.ClientLevel.m_6026_(ClientLevel.java:590) ~[client-1.20.1-20230612.114412-srg.jar%23238!/:?] {re:mixin,pl:accesstransformer:B,xf:OptiFine:default,re:classloading,pl:accesstransformer:B,xf:OptiFine:default,pl:mixin:APP:journeymap.mixins.json:client.ClientLevelMixin,pl:mixin:APP:architectury.mixins.json:MixinClientLevel,pl:mixin:A}
	at net.minecraft.client.Minecraft.m_91354_(Minecraft.java:2319) ~[client-1.20.1-20230612.114412-srg.jar%23238!/:?] {re:mixin,pl:accesstransformer:B,pl:runtimedistcleaner:A,re:classloading,pl:accesstransformer:B,pl:mixin:A,pl:runtimedistcleaner:A}
	at net.minecraft.client.Minecraft.m_91374_(Minecraft.java:735) ~[client-1.20.1-20230612.114412-srg.jar%23238!/:?] {re:mixin,pl:accesstransformer:B,pl:runtimedistcleaner:A,re:classloading,pl:accesstransformer:B,pl:mixin:A,pl:runtimedistcleaner:A}
	at net.minecraft.client.main.Main.main(Main.java:218) ~[tac.jar:?] {re:classloading,pl:runtimedistcleaner:A}
	at jdk.internal.reflect.NativeMethodAccessorImpl.invoke0(Native Method) ~[?:?] {}
	at jdk.internal.reflect.NativeMethodAccessorImpl.invoke(NativeMethodAccessorImpl.java:77) ~[?:?] {}
	at jdk.internal.reflect.DelegatingMethodAccessorImpl.invoke(DelegatingMethodAccessorImpl.java:43) ~[?:?] {}
	at java.lang.reflect.Method.invoke(Method.java:569) ~[?:?] {}
	at net.minecraftforge.fml.loading.targets.CommonLaunchHandler.runTarget(CommonLaunchHandler.java:111) ~[fmlloader-1.20.1-47.4.10.jar:?] {}
	at net.minecraftforge.fml.loading.targets.CommonLaunchHandler.clientService(CommonLaunchHandler.java:99) ~[fmlloader-1.20.1-47.4.10.jar:?] {}
	at net.minecraftforge.fml.loading.targets.CommonClientLaunchHandler.lambda$makeService$0(CommonClientLaunchHandler.java:25) ~[fmlloader-1.20.1-47.4.10.jar:?] {}
	at cpw.mods.modlauncher.LaunchServiceHandlerDecorator.launch(LaunchServiceHandlerDecorator.java:30) ~[modlauncher-10.0.9.jar:?] {}
	at cpw.mods.modlauncher.LaunchServiceHandler.launch(LaunchServiceHandler.java:53) ~[modlauncher-10.0.9.jar:?] {}
	at cpw.mods.modlauncher.LaunchServiceHandler.launch(LaunchServiceHandler.java:71) ~[modlauncher-10.0.9.jar:?] {}
	at cpw.mods.modlauncher.Launcher.run(Launcher.java:108) ~[modlauncher-10.0.9.jar:?] {}
	at cpw.mods.modlauncher.Launcher.main(Launcher.java:78) ~[modlauncher-10.0.9.jar:?] {}
	at cpw.mods.modlauncher.BootstrapLaunchConsumer.accept(BootstrapLaunchConsumer.java:26) ~[modlauncher-10.0.9.jar:?] {}
	at cpw.mods.modlauncher.BootstrapLaunchConsumer.accept(BootstrapLaunchConsumer.java:23) ~[modlauncher-10.0.9.jar:?] {}
	at cpw.mods.bootstraplauncher.BootstrapLauncher.main(BootstrapLauncher.java:141) ~[bootstraplauncher-1.1.2.jar:?] {}

