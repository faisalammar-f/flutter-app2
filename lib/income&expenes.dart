import 'package:flutter/material.dart';
import 'Income.dart';
import 'Expenses.dart';

class Inex extends StatefulWidget {
  Inex({super.key});
  State<Inex> createState() => Income_expenses();
}

class Income_expenses extends State<Inex> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Income & Expenses"),
          bottom: TabBar(
            tabs: [
              Tab(text: "Income"),
              Tab(text: "Expenses"),
            ],
          ),
        ),
        body: Column(
          children: [
            Expanded(child: TabBarView(children: [Income_w(), Expenses_w()])),
          ],
        ),
      ),
    );
  }
}
