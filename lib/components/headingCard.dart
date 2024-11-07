import 'package:flutter/material.dart';

typedef Callbackk = void Function();

class HeadingCard extends StatelessWidget {
  final BuildContext context;
  final String? name;
  final String? debit;
  final String? credit;
  final String? balance;
  final Color color;
  final Callbackk? onTap;

  const HeadingCard({
    required this.context,
    required this.name,
    required this.debit,
    required this.credit,
    required this.balance,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: InkWell(
              onTap: onTap,
              child: Card(
                color: color,
                elevation: 5,
                child: SizedBox(
                  height: 50,
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Align(
                      child: Center(
                        child: Text(
                          '$name',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).brightness == Brightness.light
                                ? Theme.of(context).colorScheme.onPrimary
                                : Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: InkWell(
              onTap: onTap,
              child: Card(
                color: color,
                elevation: 5,
                child: SizedBox(
                  height: 50,
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Align(
                      alignment: Alignment.center,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          '$debit',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).brightness == Brightness.light
                                ? Theme.of(context).colorScheme.onPrimary
                                : Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: InkWell(
              onTap: onTap,
              child: Card(
                color: color,
                elevation: 5,
                child: SizedBox(
                  height: 50,
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Align(
                      alignment: Alignment.center,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          '$credit',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).brightness == Brightness.light
                                ? Theme.of(context).colorScheme.onPrimary
                                : Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: InkWell(
              onTap: onTap,
              child: Card(
                color: color,
                elevation: 5,
                child: SizedBox(
                  height: 50,
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Align(
                      alignment: Alignment.center,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          '$balance',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).brightness == Brightness.light
                                ? Theme.of(context).colorScheme.onPrimary
                                : Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
