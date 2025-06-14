import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:metropass/ai/rules_based_ai.dart';
import 'package:metropass/apps/router/router_name.dart';
import 'package:metropass/models/ticket_type_model.dart';
import 'package:metropass/pages/payment/payment_page.dart';
import 'package:metropass/themes/colors/colors.dart';

class ChatBoxPage extends StatefulWidget {
  const ChatBoxPage({super.key});

  @override
  State<ChatBoxPage> createState() => _ChatBoxPageState();
}

class _ChatBoxPageState extends State<ChatBoxPage> {
  final TextEditingController _controller = TextEditingController();
  final List<_ChatMessage> _messages = [];

  Future<void> _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add(_ChatMessage(text: text, isUser: true));
      _controller.clear();
    });
    final aiReply = await getAIResponse(text);
    setState(() {
      _messages.add(_ChatMessage(text: aiReply, isUser: false));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Trợ lý AI'), centerTitle: true,),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];

                if (!msg.isUser && msg.text.contains('"action":"payment"')) {
                  try {
                    final data = jsonDecode(msg.text);
                    final message = data['message'] ?? '';
                    final ticket = data['ticket'];
                    return Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(message),
                            const SizedBox(height: 8),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(MyColor.pr8),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                                elevation: 2,
                              ),
                              onPressed: () {
                                final ticketModel = TicketTypeModel.fromMap(ticket, '');
                                final currentUser = FirebaseAuth.instance.currentUser;
                                  if (currentUser == null) {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        title: Row(
                                          children: [
                                            Icon(Icons.lock_outline, color: Theme.of(context).primaryColor),
                                            const SizedBox(width: 4),
                                            const Text("Bạn chưa đăng nhập", style: TextStyle(fontSize: 20, color: Color(MyColor.pr9)),),
                                          ],
                                        ),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: const [
                                            Text(
                                              "Bạn cần đăng nhập để tiếp tục!",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Color(MyColor.pr8),
                                              ),
                                            ),
                                          ],
                                        ),
                                        actionsAlignment: MainAxisAlignment.center,
                                        actions: [
                                          TextButton(
                                            style: TextButton.styleFrom(
                                              foregroundColor: Colors.grey[600],
                                            ),
                                            onPressed: () => Navigator.pop(context),
                                            child: const Text("Hủy"),
                                          ),
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Theme.of(context).primaryColor,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                            ),
                                            onPressed: () {
                                              Navigator.pop(context);
                                              context.goNamed(RouterName.login);
                                            },
                                            child: const Text(
                                              "Đăng nhập",
                                              style: TextStyle(fontSize: 16, color: Colors.white),
                                            )
                                          ),
                                        ],
                                      ),
                                    );
                                    return;
                                  }
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PaymentPage(ticket: ticketModel),
                                  ),
                                );
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  Icon(Icons.payment, size: 20, color: Colors.white),
                                  SizedBox(width: 8),
                                  Text('Đặt vé', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  } catch (_) {
                    return Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(msg.text),
                      ),
                    );
                  }
                }
                return Align(
                  alignment: msg.isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: msg.isUser ? Color(MyColor.pr3) : Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(msg.text.replaceAll('[BUTTON:PAYMENT]', '').trim()),
                  ),
                );
              },
            ),
          ),
          Divider(height: 1),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            margin: const EdgeInsets.only(bottom: 15),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Nhập tin nhắn...',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                  color: Color(MyColor.pr8),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatMessage {
  final String text;
  final bool isUser;
  _ChatMessage({required this.text, required this.isUser});
}