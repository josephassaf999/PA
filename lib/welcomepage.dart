import 'package:flutter/material.dart';
import 'login_page.dart'; // Import the LoginPage widget
import 'sign_up_page.dart'; // Import the SignUpPage widget

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Fetch the current theme
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Welcome!',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red, // Adapt to current theme
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome to PA Personal Assistant!',
              style: theme.textTheme.headline6?.copyWith(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ), // Adapt text style to current theme
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            // Login Button
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: MaterialButton(
                onPressed: () {
                  // Navigate to LoginPage
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                },
                minWidth: double.infinity,
                height: 60,
                color: Colors.red, // Use primary color from the theme
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                child: const Text(
                  'Login',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight:
                          FontWeight.w600), // Adapt text color to current theme
                ),
              ),
            ),
            const SizedBox(height: 15),
            // Sign Up Button
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: MaterialButton(
                onPressed: () {
                  // Navigate to SignUpPage
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SignUpPage()),
                  );
                },
                minWidth: double.infinity,
                height: 60,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                  side: BorderSide(
                    color:
                        theme.dividerColor, // Adapt border color based on theme
                    width: 2.0,
                  ),
                ),
                child: Text(
                  'Sign Up',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    color: theme.textTheme.bodyText1
                        ?.color, // Adapt text color based on theme
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
