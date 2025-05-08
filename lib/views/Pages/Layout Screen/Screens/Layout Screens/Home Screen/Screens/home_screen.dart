import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:go_router/go_router.dart';
import '../../../../../../../controllers/Generated/Assets/assets.dart';
import '../../../../../../../controllers/Pages/Layout/Controllers/Layout Pages Controllers/Home/Controllers/home_controller.dart';
import '../../../../../../../controllers/Theme/Theme Data/theme.dart';
import '../../../../../../components/Text/custom_text.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.homeController});

  final HomeController homeController;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    widget.homeController.initState(setState);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder:
              (context) => IconButton(
                icon: Image.asset(
                  Assets.drawer,
                  width: 24.w,
                  height: 24.h,
                  color: Theme.of(context).iconTheme.color, // ADAPT COLOR HERE
                ),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
        ),
        title: CustomText(
          text: 'appTitle',
          fontSize: 20.sp,
          textAlign: TextAlign.center,
        ),
        centerTitle: false,
        actionsPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 7.h),
        actions: [
          IconButton(
            icon: Image.asset(
              Assets.create,
              color: Theme.of(context).iconTheme.color!, // ADAPT COLOR HERE
            ),
            onPressed: widget.homeController.saveCurrentChatSession,
          ),
        ],
      ),
      drawer: Drawer(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topRight: Radius.circular(20)),
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
              ),
              child: CustomText(
                text: 'chatHistory',
                color: Colors.white,
                fontSize: 24.sp,
              ),
            ),
            for (var session in widget.homeController.chatHistory.values)
              ListTile(
                title: CustomText(text: session.title),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed:
                      () => widget.homeController.deleteChatSession(session.id),
                ),
                onTap: () {
                  context.pop();
                  widget.homeController.loadChatSession(session);
                },
              ),
          ],
        ),
      ),
      body: DashChat(
        currentUser: widget.homeController.currentUser,
        typingUsers:
            widget.homeController.isTyping
                ? [widget.homeController.grokChatUser]
                : [],
        messages: widget.homeController.messages,
        onSend: (message) {
          widget.homeController.getChatResponse(
            message: message,
            setState: setState,
          );
        },
        messageOptions: MessageOptions(
          showCurrentUserAvatar: true,
          containerColor: const Color(0xFFB39DDB),
          // LLaMA branding color
          timeFormat: DateFormat(DateFormat.HOUR_MINUTE),
          showTime: true,
          currentUserTextColor: AppTheme.defaultTextColor(context),
          currentUserContainerColor: Theme.of(context).colorScheme.primary,
          textColor: Colors.black,
        ),
        messageListOptions: MessageListOptions(
          dateSeparatorFormat: DateFormat(DateFormat.HOUR_MINUTE),
          showDateSeparator: true,
          separatorFrequency: SeparatorFrequency.hours,
        ),
        scrollToBottomOptions: ScrollToBottomOptions(
          scrollToBottomBuilder:
              (scrollController) => Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 1),
                  child: MaterialButton(
                    onPressed:
                        () => widget.homeController.scrollToBottom(
                          scrollController,
                        ),
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: (0.9 * 255)),
                    elevation: 4,
                    height: 30,
                    shape: const CircleBorder(),
                    child: Icon(
                      Icons.arrow_downward_rounded,
                      size: 18,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ),
        ),
        inputOptions: InputOptions(
          inputDisabled: widget.homeController.isRecording,
          leading: [
            IconButton(
              onPressed:
                  () => widget.homeController.toggleVoiceRecording(context),
              icon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    widget.homeController.isRecording ? Icons.stop : Icons.mic,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  if (widget.homeController.isRecording)
                    StreamBuilder(
                      stream: Stream.periodic(Duration(seconds: 1)),
                      builder: (context, snapshot) {
                        final startTime =
                            widget.homeController.recordingStartTime;
                        if (startTime == null) return SizedBox.shrink();

                        final duration = DateTime.now().difference(startTime);
                        return CustomText(text: '${duration.inSeconds}s');
                      },
                    ),
                ],
              ),
            ),
          ],
          sendOnEnter: true,
          sendButtonBuilder:
              (send) => IconButton(
                onPressed: send,
                icon: Icon(
                  Icons.send,
                  color: Theme.of(context).colorScheme.primary,
                  size: 24.dg,
                ),
              ),
          inputDecoration: InputDecoration(
            filled: true,
            fillColor: Theme.of(context).colorScheme.surface,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 12.h,
            ),
            hintText:
                widget.homeController.isRecording
                    ? 'recordMessage'.tr()
                    : 'typeMessage'.tr(),
          ).applyDefaults(Theme.of(context).inputDecorationTheme),
        ),
      ),
    );
  }
}
