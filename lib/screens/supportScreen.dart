import 'dart:io';
import 'package:elive/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class SupportScreen extends StatefulWidget {
  @override
  _SupportScreenState createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  TextEditingController email, text;

  var smtpServer;
  final GlobalKey<ScaffoldState> globKeySupport =
      new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    email = TextEditingController();
    text = TextEditingController();
    smtpServer = gmail(username, password);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: globKeySupport,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
        title: Text(
          'Support',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Stack(
        children: [
          Opacity(
            opacity: 0.05,
            child: Image.asset(
              "assets/images/bg.png",
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
            ),
          ),
          ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: email,
                        keyboardType: TextInputType.number,
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                          hintText: 'Enter email',
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black)),
                        ),
                        onChanged: (val) {
                          // username = val;
                        },
                      ),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: text,
                        keyboardType: TextInputType.number,
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                          hintText: 'Enter problem',
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black)),
                        ),
                        onChanged: (val) {
                          // username = val;
                        },
                      ),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Center(
                      child: Container(
                        height: 40,
                        width: 120,
                        child: RaisedButton(
                          onPressed: () async {
                            showToast("Sending Email",Colors.green);
                            final message = Message()
                              ..from = Address(username, 'Elive')
                              ..recipients.add('elivebeautyspotdubai@gmail.com')
                              ..subject = 'Elive Support'
                              ..text = '${text.text}'
                              ..html =
                                  "<h1>Support</h1>\n<p>Hey! ${email.text} need support </p>\n"
                                      "${text.text}";
                            try {
                              final sendReport =
                                  await send(message, smtpServer);
                              //print('Message sent: ' + sendReport.toString());
                              showToast("Success", Colors.green);
                            } on MailerException catch (e) {
                              //print('Message not sent.');
                              for (var p in e.problems) {
                                //print('Problem: ${p.code}: ${p.msg}');
                              }
                            }
                          },
                          color: Colors.black,
                          child: Center(
                              child: Text(
                            'Send',
                            style: TextStyle(color: Colors.white),
                          )),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
