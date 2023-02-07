import 'package:chat_gpt_flutter/chat_gpt_flutter.dart';
import 'package:flutter/material.dart';
import 'package:url_strategy/url_strategy.dart';

void main() {
  setPathUrlStrategy();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Comm Checker',
      theme: ThemeData.dark(),
      home: const MyHomePage(),
    );
  }
}

const apiKey = "apiKey";

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _txt = TextEditingController();
  String? answer;
  final chatGpt = ChatGpt(apiKey: apiKey);
  bool loading = false;
  String testPrompt = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Comm Checker"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            //crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.4,
                // height: MediaQuery.of(context).size.height * 0.4,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextField(
                      maxLines: 20,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 3, color: Colors.greenAccent),
                          ),
                          hintText: "Paste Your mail here"),
                      controller: _txt,
                      onChanged: (value) {
                        setState(() {
                          testPrompt = _txt.text;
                        });
                      },
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              setState(() {
                                testPrompt = "";
                                answer = "";
                                _txt.text = "";
                              });
                            },
                            child: const Text("Reset")),
                        const SizedBox(
                          width: 24,
                        ),
                        ElevatedButton(
                            onPressed: () async {
                              setState(() {
                                loading = true;
                              });
                              final testRequest = CompletionRequest(
                                  prompt:
                                      "$testPrompt -Please fix the above email grammatically, paraphrase it professionally and also remove the extra spacing",
                                  model: ChatGptModel.textDavinci003.key,
                                  maxTokens: 200);
                              final result =
                                  await chatGpt.createCompletion(testRequest);
                              setState(() {
                                print(testPrompt);
                                answer = result;
                                loading = false;
                              });
                            },
                            child: const Text("Check my mail")),
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(
                width: 42,
              ),
              Card(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.8,
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          if (loading)
                            const Center(child: CircularProgressIndicator())
                          else if (answer != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 16.0),
                              child: SelectableText('$answer'),
                            ),
                        ]),
                  ),
                ),
              ),
              //Text('Q: $testPrompt'),
            ],
          ),
        ),
      ),
      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: () async {
      //     setState(() {
      //       loading = true;
      //     });
      //     final testRequest = CompletionRequest(
      //         prompt: testPrompt,
      //         model: ChatGptModel.textDavinci003.key,
      //         maxTokens: 200);
      //     final result = await chatGpt.createCompletion(testRequest);
      //     setState(() {
      //       print(result);
      //       answer = result;
      //       loading = false;
      //     });
      //   },

      //   //child: Text("Check"),
      //   label: const Text("Check my mail"),
      // ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
