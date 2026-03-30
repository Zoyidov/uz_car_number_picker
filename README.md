# Uzbekistan Car Number Picker 🇺🇿

A highly customizable and elegant Flutter widget for picking Uzbekistan car license plates. Designed with Glassmorphism and supports both physical and legal entity plate formats.

[![pub package](https://img.shields.io/pub/v/uz_car_number_picker.svg)](https://pub.dev/packages/uz_car_number_picker)
[![likes](https://img.shields.io/pub/likes/uz_car_number_picker.svg)](https://pub.dev/packages/uz_car_number_picker/score)

## Features 🚀

* **Glassmorphism Design:** Modern and sleek UI out of the box.
* **Dual Mode:** Supports both Physical (01 A 777 AA) and Legal (01 777 AAA) entity formats.
* **Region Picker:** Built-in bottom sheet to select from all 14 regions of Uzbekistan.
* **Localization:** Supports Uzbek (UZ), Russian (RU), and English (EN).
* **Customizable:** Change colors, height, width, and labels to match your brand.
* **Auto-focus:** Smart focus management between input fields.

## Preview 📸

![Uz Car Number Picker Preview](https://raw.githubusercontent.com/username/uz_car_number_picker/main/screenshots/preview.gif)
*(Eslatma: GitHub'dagi screenshots papkasiga rasm yoki GIF yuklab, linkini shu yerga qo'ying)*

## Installation 📦

Add this to your `pubspec.yaml`:

```yaml
dependencies:
  uz_car_number_picker: ^1.0.1

##Usage 🛠️

```dart
import 'package:uz_car_number_picker/uz_car_number_picker.dart';

UzCarNumberPicker(
  activeColor: Colors.blueAccent,
  onChanged: (String fullNumber) {
    print("Selected Number: $fullNumber");
  },
)

Localization 🌍

UzCarNumberPicker(
  languageCode: 'uz', // 'uz', 'ru', or 'en'
)

