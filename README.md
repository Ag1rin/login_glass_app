Glass Login Demo
A sleek Flutter application showcasing a modern glassmorphism login interface with subtle floating particle animations. Built with a monochromatic black-and-white theme, it features smooth interactions and responsive design for mobile devices.
Overview
This demo app provides a visually appealing login screen inspired by glassmorphism design principles. It includes a gradient background, animated floating particles, and a form with email/password inputs, visibility toggle, and a mock sign-in action. The particles respond to screen taps by changing animation speed, adding an interactive ambient effect.
The app is lightweight, performant, and ready for extension (e.g., integrating real authentication).
Features

Glassmorphism UI: Backdrop blur effects, semi-transparent cards, and subtle shadows for a frosted glass aesthetic.
Ambient Animation: 5 floating white circles that gently sway across the screen using trigonometric functions for natural motion.
Interactive Elements: Tap the background to toggle particle speed (normal to accelerated).
Login Form:

Email and password fields with icons and validation.
Password visibility toggle.
Sign-in button with success feedback (Snackbar).
Forgot password link (placeholder).


Responsive Design: Optimized for mobile screens with SafeArea and SingleChildScrollView.
Theme: Dark gradient (black to grey) with white accents for a minimalist look.

Screenshots











Light Mode (Default)Failed to load imageView link
(Add screenshots to the screenshots/ folder and update the links.)
Requirements

Flutter SDK: >= 3.0.0
Dart SDK: >= 2.19.0 (included with Flutter)
Development tools: Android Studio or VS Code with Flutter extension
Device/Emulator: Android/iOS for testing

Installation

Clone the Repository:
textgit clone https://github.com/your-username/glass-login-demo.git
cd glass-login-demo

Install Dependencies:
textflutter pub get

Run the App:
textflutter run

For a specific device: flutter run -d <device-id> (use flutter devices to list).



Usage

Launch the app on your device/emulator.
Enter sample credentials (e.g., any non-empty email/password) and tap Sign In to see the success message.
Tap anywhere on the background to accelerate the floating particles.
Customize animations or UI via the code in lib/main.dart.

Project Structure
textglass-login-demo/
├── lib/
│   └── main.dart          # Main app file with UI, animations, and logic
├── pubspec.yaml           # Dependencies (flutter, google_fonts)
├── screenshots/           # UI screenshots (optional)
├── README.md              # This file
└── analysis_options.yaml  # Lint rules (optional)
Customization

Colors & Theme: Modify the LinearGradient in the background Container (around line 150).
Particles:

Change count in initState() (line ~80).
Adjust sway amplitude in calculateX/Y methods (lines ~220-230).


Form Logic: Update _handleLogin() for real authentication (e.g., Firebase Auth).
Fonts: Replace GoogleFonts.poppins() with custom fonts if needed.
Add Features: Integrate navigation to a dashboard post-login using Navigator.

Contributing
Contributions are welcome! Please:

Fork the repository.
Create a feature branch (git checkout -b feature/amazing-feature).
Commit changes (git commit -m 'Add amazing feature').
Push to the branch (git push origin feature/amazing-feature).
Open a Pull Request.

Issues & Support

Report bugs or request features via GitHub Issues.
Ensure your Flutter environment is up-to-date: flutter doctor.

License
This project is licensed under the MIT License - see the LICENSE file for details.
Acknowledgments

Flutter Team for the framework.
Google Fonts for Poppins.
Design inspiration from glassmorphism trends.


Built with Flutter | Version: 1.0.0 | Last Updated: October 19, 2025
