import 'package:flutter/material.dart';

class ChartBar extends StatelessWidget {
  const ChartBar({
    required this.label,
    required this.value,
    required this.percentage,
    super.key,
  });

  final String label;
  final double value;
  final double percentage;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 20,
          child: FittedBox(
            child: Padding(
              padding: const EdgeInsets.all(2),
              child: Text(
                'R\$ ${value.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 12),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        SizedBox(
          height: 60,
          width: 10,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                    width: 1,
                  ),
                  color: const Color.fromRGBO(220, 220, 200, 1),
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              FractionallySizedBox(
                heightFactor: percentage,
                child: Container(
                  decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(5),
                )),
              )
            ],
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        Text(label),
      ],
    );
  }
}
