import 'package:flutter/material.dart';

class LeaderboardPage extends StatelessWidget {
  const LeaderboardPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEBEBEB),
      appBar: AppBar(
        title: Text('Papan Markah'),
        backgroundColor: const Color(0xFF82618B),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Leaderboard Title
            Text(
              'Weekly Leaderboard',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),

            // Leaderboard List
            Expanded(
              child: ListView.builder(
                itemCount: leaderboardData.length,
                itemBuilder: (context, index) {
                  final item = leaderboardData[index];
                  return LeaderboardItem(index: index + 1, name: item['name'], score: item['score']);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LeaderboardItem extends StatelessWidget {
  final int index;
  final String name;
  final int score;

  LeaderboardItem({
    required this.index,
    required this.name,
    required this.score,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Text(
          '$index',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        title: Text(
          name,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: Text(
          'Score: $score',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

// Sample data for leaderboard
List<Map<String, dynamic>> leaderboardData = [
  {'name': 'User A', 'score': 100},
  {'name': 'User B', 'score': 95},
  {'name': 'User C', 'score': 90},
  {'name': 'User D', 'score': 85},
  {'name': 'User E', 'score': 80},
  {'name': 'User F', 'score': 75},
  {'name': 'User G', 'score': 70},
];
