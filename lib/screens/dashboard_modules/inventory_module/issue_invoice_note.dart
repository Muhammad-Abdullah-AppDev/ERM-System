import 'package:flutter/material.dart';

class IssueInvoiceNote extends StatefulWidget {
  const IssueInvoiceNote({super.key});

  @override
  State<IssueInvoiceNote> createState() => _IssueInvoiceNoteState();
}

class _IssueInvoiceNoteState extends State<IssueInvoiceNote> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade200,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Issue Note',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
            //resetFields();
          },
          icon: const Padding(
            padding: EdgeInsets.only(left: 14.0),
            child: Icon(
              Icons.close_rounded,
              size: 30,
              color: Colors.green,
            ),
          ),
        ),
      ),
    );
  }
}
