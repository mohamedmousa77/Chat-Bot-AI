// ignore: file_names
import 'package:chatbot/massage-model.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _userInput = TextEditingController();
  final apiKey = "AIzaSyCNOvk6bdawkp9k_z7evPSx6axYTupYi34";
  List<MassageModel> messages = [];
  Future<void> talkWithGemini() async {
    final model = GenerativeModel(model: 'gemini-pro', apiKey: apiKey);
    String message = _userInput.text;
    setState(() {
      messages.add(MassageModel(
          isUser: true, massage: message, dateTime: DateTime.now()));
    });

    final content = Content.text(message);

    final response = await model.generateContent([content]);

    setState(() {
      messages.add(MassageModel(
          isUser: false,
          massage: response.text ?? "",
          dateTime: DateTime.now()));
    });
    debugPrint('response from gemini ai ${response.text}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: LinearGradient(
      //     colors: [
      //       Color(0xFF336699),
      //       Color(0xFF0099CC),
      //     ],
      //     begin: Alignment.topLeft,
      //     end: Alignment.bottomRight,
      //   ),
      //   actions: [
      //     Container(
      //       decoration: const BoxDecoration(
      //         color: Colors.white,
      //         shape: BoxShape.circle,
      //       ),
      //       child: const Icon(Icons.language),
      //     )
      //   ],
      // ),
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/BG-3.jpeg'), fit: BoxFit.fill)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              height: 80,
              width: double.infinity,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(top: 15, right: 20, left: 20),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(50),
                    bottomRight: Radius.circular(50)),
                gradient: LinearGradient(
                  colors: [
                    Color.fromRGBO(5, 38, 88, 1),
                    Color(0xFF0099CC),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.menu,
                    color: Colors.white,
                    size: 25,
                  ),
                  Spacer(),
                  const Text(
                    'Gemini AI',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                  Spacer(),
                  Icon(
                    Icons.language,
                    color: Colors.white,
                    size: 25,
                  ),
                ],
              ),
            ),
            // Msg space
            Expanded(
                child: ListView.builder(
                    itemCount: messages.length,
                    itemBuilder: (content, index) {
                      return Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(15),
                        margin: const EdgeInsets.symmetric(vertical: 15)
                            .copyWith(
                                left: messages[index].isUser ? 100 : 10,
                                right: messages[index].isUser ? 10 : 100),
                        decoration: BoxDecoration(
                            color: messages[index].isUser
                                ? Colors.blueAccent
                                : Colors.grey.shade400,
                            borderRadius: BorderRadius.only(
                                topLeft: const Radius.circular(10),
                                bottomLeft: messages[index].isUser
                                    ? const Radius.circular(10)
                                    : Radius.zero,
                                topRight: const Radius.circular(10),
                                bottomRight: messages[index].isUser
                                    ? Radius.zero
                                    : const Radius.circular(10))),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              messages[index].massage,
                              style: TextStyle(
                                  fontSize: 16,
                                  color: messages[index].isUser
                                      ? Colors.white
                                      : Colors.black),
                            ),
                            Text(
                              DateFormat('HH:mm')
                                  .format(messages[index].dateTime),
                              style: TextStyle(
                                fontSize: 10,
                                color: messages[index].isUser
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            )
                          ],
                        ),
                      );
                    })),
            // Input text:
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  height: 70,
                  width: MediaQuery.of(context).size.width * 0.85,
                  // padding: const EdgeInsets.all(10),
                  child: TextFormField(
                    controller: _userInput,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                        focusColor: const Color(0xFF0099CC),
                        border: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: Color(0xFF0099CC)),
                            borderRadius: BorderRadius.circular(25)),
                        labelText: 'Enter your text',
                        labelStyle: const TextStyle(color: Color(0xFF0099CC))),
                  ),
                ),
                // const Spacer(),
                Container(
                  margin: const EdgeInsets.only(right: 10),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: IconButton(
                    onPressed: () {
                      talkWithGemini();
                      _userInput.clear();
                    },
                    icon: const Icon(Icons.send),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
