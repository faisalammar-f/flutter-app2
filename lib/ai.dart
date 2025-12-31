import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class Ai extends StatefulWidget {
  Ai({super.key});
  State<Ai> createState() => Ai_ass();
}

class Ai_ass extends State<Ai> {
  bool isopen = false;
  @override
  Widget build(BuildContext context) {
    final a = Provider.of<ai_prov>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("AI Assistant".tr),
        centerTitle: true,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,

            children: [
              Text(
                "Smart Insights for you".tr,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black,
                  fontSize: 22,
                ),
              ),
              Text(
                "based on your recent tasks and spending , here are personalized tips: "
                    .tr,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedSuperellipseBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  elevation: 2,
                ),
                icon: Icon(Icons.lightbulb, color: Colors.white, size: 24),
                onPressed: () {
                  setState(() {
                    isopen = !isopen;
                  });
                },
                label: Text(
                  "Get New Suggestions".tr,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w300,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 20),

              if (isopen)
                Card(
                  elevation: 5,
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  color: Theme.of(context).brightness == Brightness.dark
                      ? const Color(0xFF121212) // لون داكن
                      : Colors.blue.shade50,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.analytics,
                              size: 30,
                              color: Colors.white,
                            ),
                            Text(
                              "Your financial report:".tr,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color:
                                    Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Colors.white
                                    : Colors.black,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "💰Total Income:".tr,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color:
                                    Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                            Text(
                              "${a.totalincome.toStringAsFixed(2)} JOD",
                              style: TextStyle(
                                color:
                                    Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "📉 Total Expenses:".tr,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color:
                                    Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                            Text(
                              "${a.totalexp.toStringAsFixed(2)} JOD",
                              style: TextStyle(
                                color:
                                    Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "📊Financial Score:".tr,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color:
                                    Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                            Text(
                              "${a.financialScore} ${a.financialLabel}",
                              style: TextStyle(
                                color:
                                    Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12),

                        Text(
                          "💡 Main Insight:".tr,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                        SizedBox(height: 6),

                        // ignore: unnecessary_string_interpolations
                        Text(
                          "${a.mainInsight}",
                          softWrap: true,
                          style: TextStyle(
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),

                        SizedBox(height: 12),
                        Text(
                          "💸 Saving Opportunity:".tr,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                        SizedBox(height: 6),

                        Text(
                          // ignore: unnecessary_string_interpolations
                          "${a.savingOpportunity}",
                          softWrap: true,
                          style: TextStyle(
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),

                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "⚖️ Balance:".tr,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color:
                                    Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                            SizedBox(width: 10),
                            // ignore: unnecessary_string_interpolations
                            Flexible(
                              child: Text(
                                "${a.balance}",
                                softWrap: true,
                                style: TextStyle(
                                  color:
                                      Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12),

                        Text(
                          "📝 Summary:".tr,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                        SizedBox(height: 6),

                        // ignore: unnecessary_string_interpolations
                        Text(
                          "${a.summary}",
                          softWrap: true,
                          style: TextStyle(
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class ai_prov extends ChangeNotifier {
  final dynamic income;
  final dynamic expenses;
  ai_prov({required this.expenses, required this.income}) {
    init();
  }
  void init() {
    _listenToStreams();
  }

  double totalincome = 0;
  double totalexp = 0;
  String topcat = '';
  double topcatamount = 0;
  double balance = 0;
  StreamSubscription? _incomeSub;
  StreamSubscription? _expSub;
  StreamSubscription? _topCatSub;
  StreamSubscription? _topCatAmtSub;

  // ignore: unused_element
  void _listenToStreams() {
    _incomeSub?.cancel();
    _expSub?.cancel();
    _topCatSub?.cancel();
    _topCatAmtSub?.cancel();
    _incomeSub = income.sumIncome.listen((value) {
      totalincome = value;
      calculatefinscore();
    });

    _expSub = expenses.sumExpenses.listen((value) {
      totalexp = value;
      calculatefinscore();
    });

    _topCatSub = expenses.topcategory.listen((value) {
      topcat = value;
      calculatefinscore();
    });
    _topCatAmtSub = expenses.topCategoryAmount.listen((value) {
      topcatamount = value;
      calculatefinscore();
    });
  }

  String financialLabel = "Unknown";
  String savingOpportunity = "";
  String mainInsight = "";
  String summary = "";
  int financialScore = 0;
  void calculatefinscore() {
    if (totalincome == 0) {
      financialScore = 0;
      financialLabel = "Risk".tr;
      mainInsight = "no income data available.".tr;
      savingOpportunity = "";
      summary = "You have no income recorded for this month.".tr;
      balance = -totalexp;
      notifyListeners();
      return;
    }
    balance = totalincome - totalexp;
    financialScore = financialScore =
        ((100 - (totalexp / totalincome) * 50 - (topcatamount / totalexp) * 30))
            .round()
            .clamp(0, 100);
    if (financialScore >= 70) {
      financialLabel = "Excellent".tr;
    } else if (financialScore >= 50) {
      financialLabel = "Moderate".tr;
    } else {
      financialLabel = "High risk".tr;
    }

    if (topcat.isEmpty) {
      mainInsight = "No expense category data.".tr;
    } else {
      double percent = (totalincome == 0)
          ? 0
          : (topcatamount / totalincome) * 100;
      mainInsight =
          "Most of your spending went to $topcat,consuming ${percent.toStringAsFixed(0)}% of your income. ";
    }
    if (topcat.isEmpty || totalexp == 0) {
      savingOpportunity = "";
    } else {
      double possiblesaving = 0.1 * topcatamount;
      savingOpportunity =
          "You can save ${possiblesaving.toStringAsFixed(0)} JOD by reducing $topcat expenses by 10%. ";
    }
    summary = (financialScore >= 70)
        ? "Your monthly financial health is good.".tr
        : (financialScore >= 50)
        ? "Your financial situation is moderate and needs monitoring.".tr
        : "Your expenses are high and need control.".tr;

    notifyListeners();
  }

  @override
  void dispose() {
    _incomeSub?.cancel();
    _expSub?.cancel();
    _topCatSub?.cancel();
    _topCatAmtSub?.cancel();
    super.dispose();
  }

  void clearData() {
    _incomeSub?.cancel();
    _expSub?.cancel();
    _topCatSub?.cancel();
    _topCatAmtSub?.cancel();

    totalincome = 0;
    totalexp = 0;
    topcat = '';
    topcatamount = 0;
    balance = 0;
    financialScore = 0;
    financialLabel = "Unknown";
    savingOpportunity = "";
    mainInsight = "";
    summary = "";
    notifyListeners();
  }
}
