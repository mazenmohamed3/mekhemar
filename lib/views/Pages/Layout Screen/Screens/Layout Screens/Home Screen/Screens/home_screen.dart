import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:mekhemar/controllers/Pages/Layout/Controllers/Layout%20Pages%20Controllers/Home/Controllers/home_controller.dart';
import '../../../../../../../controllers/Generated/Assets/assets.dart';
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
    widget.homeController.setState = setState;
    widget.homeController.loadChatHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder:
              (context) => IconButton(
                icon: Image.asset(Assets.drawer, width: 24.w, height: 24.h),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
        ),
        title: CustomText(
          text: 'Mekhemar AI Services',
          fontSize: 20.sp,
          textAlign: TextAlign.center,
        ),
        centerTitle: false,
        actionsPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 7.h),
        actions: [
          IconButton(
            icon: SvgPicture.asset(Assets.create),
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
              decoration: const BoxDecoration(color: Color(0xFFB39DDB)),
              child: const Text(
                'Chat History',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            for (var session in widget.homeController.chatHistory.values)
              ListTile(
                title: Text(session.title),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed:
                      () => widget.homeController.deleteChatSession(session.id),
                ),
                onTap: () {
                  Navigator.pop(context);
                  widget.homeController.loadChatSession(session);
                },
              ),
          ],
        ),
      ),
      body: DashChat(
        currentUser: widget.homeController.currentUser,
        onSend: (message) {
          widget.homeController.getChatResponse(
            message: message,
            setState: setState,
          );
        },
        messageOptions: MessageOptions(
          showCurrentUserAvatar: true,
          containerColor: const Color(0xFFB39DDB), // LLaMA branding color
          currentUserContainerColor: Theme.of(context).colorScheme.primary,
          textColor: Colors.black,
        ),
        typingUsers:
            widget.homeController.isTyping
                ? [widget.homeController.grokChatUser]
                : [],
        // No typing indicator needed here
        messages: widget.homeController.messages,
        inputOptions: InputOptions(
          leading: <Widget>[
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.upload, size: 24),
            ),
          ],
        ),
      ),
    );
  }
}
