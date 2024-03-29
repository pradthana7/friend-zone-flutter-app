import 'package:dating_app/widgets/loading_indicator.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/blocs/blocs.dart';
import '/repositories/repositories.dart';
import '/models/models.dart';

class ChatScreen extends StatelessWidget {
  static const String routeName = '/chat';
  final Match match;

  const ChatScreen({
    Key? key,
    required this.match,
  }) : super(key: key);

  static Route route({required Match match}) {
    // print('route');
    // print(match.chat);
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => BlocProvider<ChatBloc>(
        create: (context) => ChatBloc(
          databaseRepository: context.read<DatabaseRepository>(),
        )..add(LoadChat(match.chat.id)),
        child: ChatScreen(match: match),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _CustomAppBar(match: match),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg_sut.png'),
            fit: BoxFit.fitWidth,
          ),
        ),
        child: BlocBuilder<ChatBloc, ChatState>(
          builder: (context, state) {
            if (state is ChatLoading) {
              return Center(
                child: LoadingIndicator(),
              );
            }
            if (state is ChatLoaded) {
              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      reverse: true,
                      shrinkWrap: true,
                      itemCount: state.chat.messages.length,
                      itemBuilder: (context, index) {
                        List<Message> messages = state.chat.messages;
                        return ListTile(
                          title: _Message(
                            message: messages[index].message,
                            isFromCurrentUser: messages[index].senderId ==
                                context.read<AuthBloc>().state.authUser!.uid,
                          ),
                        );
                      },
                    ),
                  ),
                  // const Spacer(flex: 1),
                  _MessageInput(match: match)
                ],
              );
            } else {
              return const Text('Something went wrong.');
            }
          },
        ),
      ),
    );
  }
}

class _MessageInput extends StatelessWidget {
  const _MessageInput({
    Key? key,
    required this.match,
  }) : super(key: key);

  final Match match;

  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController();

    void sendMessage() {
      if (controller.text.isNotEmpty) {
        context.read<ChatBloc>().add(
              AddMessage(
                userId: match.userId,
                matchUserId: match.matchUser.id!,
                message: controller.text,
              ),
            );
        controller.clear();
      }
    }

    return Container(
      padding: const EdgeInsets.all(20.0),
      height: 80,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              onSubmitted: (_) {
                sendMessage();
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Theme.of(context).primaryColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Theme.of(context).primaryColor),
                ),
                suffixIcon: IconButton(
                  onPressed: sendMessage,
                  icon: const Icon(Icons.send_rounded),
                ),
                filled: true,
                fillColor: const Color(0xffffffff),
                hintText: 'Message',
                contentPadding:
                    const EdgeInsets.only(left: 16, bottom: 5, top: 5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Message extends StatelessWidget {
  const _Message({
    Key? key,
    required this.message,
    required this.isFromCurrentUser,
  }) : super(key: key);

  final String message;
  final bool isFromCurrentUser;

  @override
  Widget build(BuildContext context) {
    AlignmentGeometry alignment =
        isFromCurrentUser ? Alignment.topRight : Alignment.topLeft;
    Color color =
        isFromCurrentUser ? const Color(0xffdfd6c7) : const Color(0xffffffff);
    TextStyle? textStyle = isFromCurrentUser
        ? Theme.of(context).textTheme.bodyLarge
        : Theme.of(context).textTheme.bodyLarge;
    

    return Align(
      alignment: alignment,
      child: Container(
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: isFromCurrentUser ? const Radius.circular(8.0) : Radius.zero,
              topRight: isFromCurrentUser ? Radius.zero : const Radius.circular(8.0),
              bottomLeft: const Radius.circular(8.0),
              bottomRight: const Radius.circular(8.0)),
          color: color,
        ),
        child: Text(
          message,
          style: textStyle,
        ),
      ),
    );
  }
}

class _CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _CustomAppBar({
    Key? key,
    required this.match,
  }) : super(key: key);

  final Match match;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xffC4B6A6),
      shadowColor: const Color(0xff8A8D8F),
      elevation: 1,
      iconTheme: const IconThemeData(color: Colors.black87),
      title: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundImage: NetworkImage(match.matchUser.imageUrls[0]),
          ),
          const SizedBox(width: 10),
          Text(
            match.matchUser.name,
            style: Theme.of(context).textTheme.titleLarge,
          )
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56.0);
}
