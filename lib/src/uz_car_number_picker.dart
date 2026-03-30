import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:glassmorphism/glassmorphism.dart';

class UzCarNumberPicker extends StatefulWidget {
  final String? languageCode;
  final Color activeColor, plateColor, regionTextColor;
  final double? width, height;

  final String? customJismoniy, customYuridik, customHint, customSelectRegion;

  const UzCarNumberPicker({
    super.key,
    this.languageCode,
    this.activeColor = Colors.blueAccent,
    this.plateColor = Colors.white,
    this.regionTextColor = Colors.blueAccent,
    this.width,
    this.height,
    this.customJismoniy,
    this.customYuridik,
    this.customHint,
    this.customSelectRegion,
  });

  @override
  State<UzCarNumberPicker> createState() => _UzCarNumberPickerState();
}

class _UzCarNumberPickerState extends State<UzCarNumberPicker> {
  final ValueNotifier<bool> isJismoniy = ValueNotifier<bool>(true);
  final ValueNotifier<String> selectedRegion = ValueNotifier<String>("01");

  // Controllerlar va FocusNode'lar
  final TextEditingController _jMidCtrl = TextEditingController();
  final TextEditingController _jNumCtrl = TextEditingController();
  final TextEditingController _jSuffixCtrl = TextEditingController();
  final TextEditingController _yNumCtrl = TextEditingController();
  final TextEditingController _ySuffixCtrl = TextEditingController();

  final FocusNode _jMidFocus = FocusNode(), _jNumFocus = FocusNode(), _jSuffixFocus = FocusNode();
  final FocusNode _yNumFocus = FocusNode(), _ySuffixFocus = FocusNode();

  // --- LOKALIZATSIYA LUG'ATI ---
  final Map<String, dynamic> _i18n = {
    'uz': {
      'jismoniy': 'Jismoniy',
      'yuridik': 'Yuridik',
      'hint': 'RAQAMNI KIRITING',
      'select': 'Viloyatni tanlang',
      'regions': {
        "01": "Toshkent shahri", "10": "Toshkent viloyati", "20": "Sirdaryo viloyati",
        "25": "Jizzax viloyati", "30": "Samarqand viloyati", "40": "Farg'ona viloyati",
        "50": "Namangan viloyati", "60": "Andijon viloyati", "70": "Qashqadaryo viloyati",
        "75": "Surxondaryo viloyati", "80": "Buxoro viloyati", "85": "Navoiy viloyati",
        "90": "Xorazm viloyati", "95": "Qoraqalpog'iston Resp.",
      }
    },
    'ru': {
      'jismoniy': 'Физ. лицо',
      'yuridik': 'Юр. лицо',
      'hint': 'ВВЕДИТЕ НОМЕР',
      'select': 'Выберите регион',
      'regions': {
        "01": "Город Ташкент", "10": "Ташкентская область", "20": "Сырдарьинская область",
        "25": "Джизакская область", "30": "Самаркандская область", "40": "Ферганская область",
        "50": "Наманганская область", "60": "Андижанская область", "70": "Кашкадарьинская область",
        "75": "Сурхандарьинская область", "80": "Бухарская область", "85": "Навоийская область",
        "90": "Хорезмская область", "95": "Респ. Каракалпакстан",
      }
    },
    'en': {
      'jismoniy': 'Private',
      'yuridik': 'Business',
      'hint': 'ENTER PLATE NUMBER',
      'select': 'Select Region',
      'regions': {
        "01": "Tashkent City", "10": "Tashkent Region", "20": "Syrdarya",
        "25": "Jizzakh", "30": "Samarkand", "40": "Fergana",
        "50": "Namangan", "60": "Andijan", "70": "Kashkadarya",
        "75": "Surkhandarya", "80": "Bukhara", "85": "Navoi",
        "90": "Khorezm", "95": "Karakalpakstan",
      }
    }
  };

  // Hozirgi tilni aniqlash (Parametrdan yoki Tizimdan)
  String get _currentLang {
    if (widget.languageCode != null && _i18n.containsKey(widget.languageCode)) {
      return widget.languageCode!;
    }
    // Tizim tilini olish (masalan: 'uz_UZ' -> 'uz')
    String systemLang = ui.PlatformDispatcher.instance.locale.languageCode;
    return _i18n.containsKey(systemLang) ? systemLang : 'uz';
  }

  // Matnlarni olish yordamchisi
  String _t(String key) {
    if (key == 'jismoniy') return widget.customJismoniy ?? _i18n[_currentLang]['jismoniy'];
    if (key == 'yuridik') return widget.customYuridik ?? _i18n[_currentLang]['yuridik'];
    if (key == 'hint') return widget.customHint ?? _i18n[_currentLang]['hint'];
    if (key == 'select') return widget.customSelectRegion ?? _i18n[_currentLang]['select'];
    return "";
  }

  void _showRegionPicker() {
    Map<String, String> regions = Map<String, String>.from(_i18n[_currentLang]['regions']);
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A1A1A),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        height: 400,
        child: Column(
          children: [
            Text(_t('select'), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 15),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, childAspectRatio: 2, mainAxisSpacing: 10, crossAxisSpacing: 10,
                ),
                itemCount: regions.length,
                itemBuilder: (context, index) {
                  String code = regions.keys.elementAt(index);
                  return InkWell(
                    onTap: () {
                      selectedRegion.value = code;
                      Navigator.pop(context);
                      Future.delayed(const Duration(milliseconds: 50), () {
                        if (isJismoniy.value) _jMidFocus.requestFocus(); else _yNumFocus.requestFocus();
                      });
                    },
                    child: ValueListenableBuilder(
                      valueListenable: selectedRegion,
                      builder: (context, val, child) => Container(
                        decoration: BoxDecoration(
                          color: val == code ? widget.activeColor : Colors.white10,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(child: Text(code, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold))),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double currentHeight = widget.height ?? constraints.maxHeight;
        double currentWidth = widget.width ?? constraints.maxWidth;

        return GlassmorphicContainer(
          width: currentWidth, height: currentHeight,
          borderRadius: 30, blur: 20, alignment: Alignment.center, border: 2,
          linearGradient: LinearGradient(colors: [Colors.white.withOpacity(0.1), Colors.white.withOpacity(0.05)]),
          borderGradient: LinearGradient(colors: [widget.activeColor.withOpacity(0.5), Colors.purple.withOpacity(0.5)]),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildToggle(),
                  const SizedBox(height: 30),
                  _buildPlate(),
                  const SizedBox(height: 20),
                  _buildRegionName(currentWidth),
                  const SizedBox(height: 5),
                  Text(_t('hint'), style: const TextStyle(color: Colors.white38, fontSize: 10, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPlate() => FittedBox(
    fit: BoxFit.contain,
    child: Container(
      height: 100, width: 500,
      decoration: BoxDecoration(
        color: widget.plateColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.black, width: 3.5),
        boxShadow: [BoxShadow(color: Colors.black54, offset: const Offset(0, 10), blurRadius: 20)],
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: _showRegionPicker,
            child: Container(
              width: 85, alignment: Alignment.center,
              child: ValueListenableBuilder(
                valueListenable: selectedRegion,
                builder: (context, val, _) => Text(val, style: const TextStyle(color: Colors.black, fontSize: 44, fontWeight: FontWeight.w900)),
              ),
            ),
          ),
          Container(width: 3.5, color: Colors.black),
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: isJismoniy,
              builder: (context, jismoniy, _) => AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: Row(
                  key: ValueKey(jismoniy),
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: jismoniy ? _jismoniyFields() : _yuridikFields(),
                ),
              ),
            ),
          ),
          _buildFlag(),
        ],
      ),
    ),
  );

  Widget _buildRegionName(double currentWidth) => ValueListenableBuilder(
    valueListenable: selectedRegion,
    builder: (context, val, _) {
      String regionName = _i18n[_currentLang]['regions'][val] ?? val;
      return AnimatedDefaultTextStyle(
        duration: const Duration(milliseconds: 300),
        style: TextStyle(color: widget.regionTextColor, fontWeight: FontWeight.w900, fontSize: currentWidth < 300 ? 12 : 16, letterSpacing: 2),
        child: Text(regionName.toUpperCase()),
      );
    },
  );

  Widget _buildToggle() => Container(
    height: 45, width: 260, padding: const EdgeInsets.all(4),
    decoration: BoxDecoration(color: Colors.black38, borderRadius: BorderRadius.circular(15)),
    child: Row(
      children: [
        _tab(_t('jismoniy'), true),
        _tab(_t('yuridik'), false),
      ],
    ),
  );

  // --- Qolgan yordamchi metodlar (o'zgarmadi) ---

  Widget _tab(String title, bool forJismoniy) => Expanded(
    child: ValueListenableBuilder(
      valueListenable: isJismoniy,
      builder: (context, val, _) {
        bool active = (val == forJismoniy);
        return GestureDetector(
          onTap: () => isJismoniy.value = forJismoniy,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            decoration: BoxDecoration(color: active ? widget.activeColor : Colors.transparent, borderRadius: BorderRadius.circular(12)),
            child: Center(child: Text(title, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: active ? Colors.white : Colors.white54))),
          ),
        );
      },
    ),
  );

  List<Widget> _jismoniyFields() => [
    _inputField(_jMidCtrl, _jMidFocus, _jNumFocus, "A", 1, TextInputType.text, 55),
    _inputField(_jNumCtrl, _jNumFocus, _jSuffixFocus, "777", 3, TextInputType.number, 110),
    _inputField(_jSuffixCtrl, _jSuffixFocus, null, "AA", 2, TextInputType.text, 100),
  ];

  List<Widget> _yuridikFields() => [
    _inputField(_yNumCtrl, _yNumFocus, _ySuffixFocus, "777", 3, TextInputType.number, 120),
    _inputField(_ySuffixCtrl, _ySuffixFocus, null, "AAA", 3, TextInputType.text, 120),
  ];

  Widget _inputField(TextEditingController ctrl, FocusNode current, FocusNode? next, String hint, int len, TextInputType type, double width) {
    return SizedBox(
      width: width,
      child: TextField(
        controller: ctrl,
        focusNode: current,
        textAlign: TextAlign.center,
        keyboardType: type,
        textCapitalization: TextCapitalization.characters,
        inputFormatters: [
          LengthLimitingTextInputFormatter(len),
          FilteringTextInputFormatter.allow(type == TextInputType.number ? RegExp(r'[0-9]') : RegExp(r'[A-Z]'))
        ],
        style: const TextStyle(color: Colors.black, fontSize: 44, fontWeight: FontWeight.w900, fontFamily: 'Courier'),
        decoration: InputDecoration(hintText: hint, border: InputBorder.none, counterText: "", hintStyle: TextStyle(color: Colors.black.withOpacity(0.1))),
        onChanged: (val) { if (val.length == len && next != null) FocusScope.of(context).requestFocus(next); },
      ),
    );
  }

  Widget _buildFlag() => Container(
    width: 60, padding: const EdgeInsets.only(right: 8),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 35, height: 20, decoration: BoxDecoration(border: Border.all(color: Colors.black, width: 1.5)),
          child: Column(children: [
            Expanded(child: Container(color: Colors.blue)), Container(height: 1.5, color: Colors.red),
            Expanded(child: Container(color: Colors.white)), Container(height: 1.5, color: Colors.red),
            Expanded(child: Container(color: Colors.green)),
          ]),
        ),
        const SizedBox(height: 4),
        const Text("UZ", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900, fontSize: 16)),
      ],
    ),
  );

  @override
  void dispose() {
    isJismoniy.dispose(); selectedRegion.dispose();
    _jMidCtrl.dispose(); _jNumCtrl.dispose(); _jSuffixCtrl.dispose();
    _yNumCtrl.dispose(); _ySuffixCtrl.dispose();
    _jMidFocus.dispose(); _jNumFocus.dispose(); _jSuffixFocus.dispose();
    _yNumFocus.dispose(); _ySuffixFocus.dispose();
    super.dispose();
  }
}