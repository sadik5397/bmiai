# 🧠 BMI AI

<div align="center">

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)

**An AI-Powered Body Mass Index Calculator with ChatGPT-style Insights**

[Features](#-features) • [Installation](#-installation) • [Usage](#-usage) • [Screenshots](#-screenshots) • [Contributing](#-contributing)

</div>

---

## 🌟 Overview

BMI AI is a modern, intuitive Flutter application that goes beyond simple BMI calculation. With an elegant dark-themed interface and AI-powered insights, it provides personalized health recommendations in a ChatGPT-style typewriter animation.

## ✨ Features

### 🎯 Core Functionality
- **Accurate BMI Calculation** - Industry-standard BMI computation
- **Multi-Unit Support** - Switch between Metric (cm/kg) and Imperial (ft-in/lbs)
- **7 BMI Categories** - From Severely Underweight to Obese Class III
- **Single-File Architecture** - Easy to integrate and customize

### 🤖 AI-Powered Insights
- **50+ Contextual Tips** - Personalized health, nutrition, and exercise advice
- **ChatGPT-Style Typewriter Effect** - Smooth, engaging word-by-word animation
- **Auto-Scroll Feature** - Automatically follows the typing cursor
- **Smart Recommendations** - Tailored suggestions based on your BMI category

### 🎨 Design Excellence
- **Modern Dark Theme** - Professional gradient design with purple & teal accents
- **Glassmorphism Effects** - Contemporary UI with depth and elegance
- **Smooth Animations** - Fade transitions and loading states
- **Responsive Layout** - Optimized for all screen sizes
- **Bouncing Physics** - Natural scroll behavior

## 📱 Screenshots

```
┌─────────────────────────────────┐
│  🧠 BMI AI                      │
│  AI-Powered Calculator          │
│                                 │
│  ┌───────────────────────────┐ │
│  │ Height     [cm] [ft/in]   │ │
│  │ ▢ Enter height            │ │
│  │                           │ │
│  │ Weight     [kg] [lbs]     │ │
│  │ ▢ Enter weight            │ │
│  └───────────────────────────┘ │
│                                 │
│  [Calculate BMI]                │
│                                 │
│  ┌───────────────────────────┐ │
│  │    Your BMI: 22.5         │ │
│  │    ● Normal Weight         │ │
│  └───────────────────────────┘ │
│                                 │
│  ┌───────────────────────────┐ │
│  │ ✨ AI Insights            │ │
│  │ • Typing insights...▋     │ │
│  └───────────────────────────┘ │
└─────────────────────────────────┘
```

## 🚀 Installation

### Prerequisites
- Flutter SDK (3.0.0 or higher)
- Dart SDK (2.17.0 or higher)
- Android Studio / VS Code with Flutter extensions

### Quick Start

1. **Clone or Download** the `main.dart` file

2. **Create a new Flutter project**
   ```bash
   flutter create bmi_ai
   cd bmi_ai
   ```

3. **Replace the main.dart file**
   ```bash
   # Copy the provided main.dart to lib/main.dart
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

That's it! No dependencies, no packages, just pure Flutter magic! ✨

## 📖 Usage

### Basic Operation

1. **Select Units** - Toggle between Metric/Imperial using the unit switches
2. **Enter Height**
    - Metric: Enter height in centimeters (e.g., 175)
    - Imperial: Enter feet and inches (e.g., 5 ft 9 in)
3. **Enter Weight**
    - Metric: Enter weight in kilograms (e.g., 70)
    - Imperial: Enter weight in pounds (e.g., 154)
4. **Calculate** - Tap the "Calculate BMI" button
5. **Review Results** - Watch as AI insights appear with typewriter effect

### BMI Categories

| Category | BMI Range | Color Indicator |
|----------|-----------|-----------------|
| Severely Underweight | < 16.0 | 🔴 Red |
| Underweight | 16.0 - 18.4 | 🟠 Orange |
| Normal Weight | 18.5 - 24.9 | 🟢 Teal |
| Overweight | 25.0 - 29.9 | 🟠 Orange |
| Obese Class I | 30.0 - 34.9 | 🔴 Red |
| Obese Class II | 35.0 - 39.9 | 🔴 Red |
| Obese Class III | ≥ 40.0 | 🔴 Red |

## 🎨 Customization

### Color Scheme
```dart
// Primary Colors
scaffoldBackgroundColor: Color(0xFF0A0E21)
primaryColor: Color(0xFF1A1F3A)
accentColor: Color(0xFF6C63FF)
secondaryColor: Color(0xFF4ECDC4)
```

### Typewriter Speed
```dart
// Adjust typing speed (default: 20ms per character)
Timer.periodic(const Duration(milliseconds: 20), (timer) { ... }
```

### AI Insights
Add custom insights in the `_getAIInsights()` method:
```dart
insights.addAll([
  '💡 Your custom health tip here',
  '🎯 Another personalized recommendation',
]);
```

## 🧩 Architecture

```
main.dart
├── BMIAIApp (MaterialApp)
├── BMICalculator (StatefulWidget)
│   ├── Input Fields (Height & Weight)
│   ├── Unit Toggles (Metric/Imperial)
│   ├── Calculate Button
│   ├── Result Card
│   └── TypewriterAIInsights Widget
│       ├── Typewriter Animation Logic
│       ├── Auto-Scroll Mechanism
│       └── Dynamic Insights Rendering
```

## 🛠️ Technical Details

- **State Management** - Built-in Flutter state management with `StatefulWidget`
- **Animations** - `AnimationController` and `Timer` for smooth effects
- **Scroll Control** - `ScrollController` for auto-scroll functionality
- **Responsive Design** - Flexible layouts with `MediaQuery` considerations
- **No External Dependencies** - 100% native Flutter code

## 🎯 Key Features Breakdown

### Multi-Unit Conversion
```dart
// Imperial to Metric conversion
height_cm = (feet × 30.48) + (inches × 2.54)
weight_kg = pounds × 0.453592
```

### Typewriter Effect
- Character-by-character rendering
- Animated cursor indicator
- Smooth transitions between insights
- Auto-scroll to keep content visible

### AI Dataset
50+ pre-defined insights covering:
- 🏥 Health risks and medical advice
- 🥗 Nutrition and dietary recommendations
- 💪 Exercise and fitness tips
- 🎯 Goal-setting strategies
- 🧘 Mental health and wellness
- 📊 Personalized weight analysis

## 🤝 Contributing

Contributions are welcome! Here's how you can help:

1. **Fork** the repository
2. **Create** a feature branch (`git checkout -b feature/AmazingFeature`)
3. **Commit** your changes (`git commit -m 'Add some AmazingFeature'`)
4. **Push** to the branch (`git push origin feature/AmazingFeature`)
5. **Open** a Pull Request

### Ideas for Contribution
- 🌍 Add more language translations
- 📊 Integrate BMI history tracking
- 📈 Add weight goal calculator
- 🎨 Create light theme variant
- 📱 Add tablet-optimized layout
- 🔔 Implement reminder notifications

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## ⚠️ Disclaimer

**Important Medical Notice:**

BMI AI is a screening tool and educational resource. It should NOT be used as a substitute for professional medical advice, diagnosis, or treatment.

- BMI does not directly measure body fat percentage
- It may not be accurate for athletes, pregnant women, elderly, or children
- Always consult healthcare professionals for personalized medical guidance
- The AI insights are general recommendations, not medical prescriptions

## 💡 Inspiration

This project was inspired by:
- Modern health and fitness applications
- ChatGPT's engaging typewriter interface
- Material Design 3 principles
- Glassmorphism design trends

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- The open-source community for inspiration
- Health organizations for BMI guidelines (WHO, CDC)

## 📬 Contact & Support

- **Issues** - Report bugs via GitHub Issues
- **Questions** - Open a discussion on GitHub
- **Feature Requests** - Submit via GitHub Issues with [Feature] tag

---

<div align="center">

**Made with ❤️ and Flutter**

If you found this helpful, please give it a ⭐️!

[⬆ Back to Top](#-bmi-ai)

</div>
