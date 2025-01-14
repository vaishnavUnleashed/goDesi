import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import '../models/Transaction.dart';
import 'package:intl/intl.dart';


class HomeScreen extends StatelessWidget {
  final List<Transaction> transactions = [
    Transaction(
        "t1", DateTime(2024, 12, 1), 450, "Ram"
    ),
    Transaction(
        "t2", DateTime(2024, 12, 1), -450, "Rajesh"
    ),
    Transaction(
        "t3", DateTime(2024, 12, 1), 2000, "Sia"
    ),
    Transaction(
        "t4", DateTime(2024, 12, 1), -750, "Vishal"
    ),
  ];
  HomeScreen({super.key});



  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 50),
              child: GoDutchBalanceCard(totalBalance: 7210, moneyLent: 9214, moneyBorrowed: 2000,)
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
            child: Text(
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,


              ),

              "Your Top unresolved Transactions,",
            ),
          ),

          Expanded(
            child: ListView.builder(
              itemCount: transactions.length,
                itemBuilder:  (BuildContext context, int index) {
                  return TransactionWidget(transaction: transactions[index]);
            }),
          )

        ],
      ),
    );
  }
}




class GoDutchBalanceCard extends StatefulWidget {
  final double totalBalance;
  final double moneyLent;
  final double moneyBorrowed;

  const GoDutchBalanceCard({
    Key? key,
    required this.totalBalance,
    required this.moneyLent,
    required this.moneyBorrowed,
  }) : super(key: key);

  @override
  _GoDutchBalanceCardState createState() => _GoDutchBalanceCardState();
}

class _GoDutchBalanceCardState extends State<GoDutchBalanceCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _totalBalanceAnimation;
  late Animation<double> _moneyLentAnimation;
  late Animation<double> _moneyBorrowedAnimation;

  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();

    // Initialize animation controller
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    // Set up animations
    _totalBalanceAnimation = Tween<double>(begin: 0, end: widget.totalBalance)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _moneyLentAnimation = Tween<double>(begin: 0, end: widget.moneyLent)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _moneyBorrowedAnimation = Tween<double>(begin: 0, end: widget.moneyBorrowed)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    // Start the animation after the widget is built
    SchedulerBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _isInitialized = true;
      });
      _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const SizedBox();
    }

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      color: Colors.black,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Animated Total Balance
            AnimatedBuilder(
              animation: _totalBalanceAnimation,
              builder: (context, child) {
                return Text(
                  '₹${_totalBalanceAnimation.value.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.normal,
                    color: widget.totalBalance >= 0
                        ? Colors.green
                        : Colors.red,
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            // Money Lent and Borrowed with Animations
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Animated Money Lent
                AnimatedBuilder(
                  animation: _moneyLentAnimation,
                  builder: (context, child) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Money Lent',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey[400],
                          ),
                        ),
                        Text(
                          '₹${_moneyLentAnimation.value.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    );
                  },
                ),
                // Animated Money Borrowed
                AnimatedBuilder(
                  animation: _moneyBorrowedAnimation,
                  builder: (context, child) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Money Borrowed',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey[400],
                          ),
                        ),
                        Text(
                          '₹${_moneyBorrowedAnimation.value.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


class TransactionWidget extends StatelessWidget {
  final Transaction transaction;

  const TransactionWidget({Key? key, required this.transaction}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Format the date
    String formattedDate = DateFormat("dd/MM/yyyy").format(transaction.dateTime);

    // Set the amount text (You owe or You get)
    String amountText = transaction.amount >= 0 ? "You get ${transaction.amount} Rs" : "You owe ${transaction.amount} Rs";

    return Card(
      margin: EdgeInsets.symmetric(vertical: 2, horizontal: 3),
      elevation: 0,
      color: Colors.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        title: Text(
          "${transaction.paidBy} added the expense",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 10,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              amountText,
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
              ),
            ),
            SizedBox(height: 4),
            Text(
              "Date: $formattedDate",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 10,
              ),
            ),
          ],
        ),
        trailing: Icon(
          transaction.amount >= 0 ? Icons.arrow_downward : Icons.arrow_upward,
          color: transaction.amount >= 0 ? Colors.green : Colors.red,
        ),
      ),
    );
  }
}