import 'package:flutter/widgets.dart';

import '../data/recipe.dart';

/// Lightweight TH/EN string table. Access via `S.of(context)`.
class S {
  const S(this.lang);

  final String lang;

  static S of(BuildContext context) =>
      S(Localizations.localeOf(context).languageCode);

  bool get isThai => lang == 'th';

  String _t(String en, String th) => isThai ? th : en;

  String get appName => 'Easy Cooking';
  String get home => _t('Home', 'หน้าหลัก');
  String get favorites => _t('Saved', 'บันทึกไว้');
  String get settings => _t('Settings', 'ตั้งค่า');

  String greeting(int hour) {
    if (hour < 11) return _t('Good morning', 'อรุณสวัสดิ์');
    if (hour < 17) return _t('Good afternoon', 'สวัสดีตอนบ่าย');
    return _t('Good evening', 'สวัสดีตอนเย็น');
  }

  String get headline => _t('What would you\nlike to cook today?', 'วันนี้อยาก\nทำเมนูอะไรดี?');
  String get searchHint => _t('Search recipes…', 'ค้นหาเมนู…');
  String get featured => _t('Chef\'s picks', 'เมนูแนะนำ');
  String get allRecipes => _t('All recipes', 'สูตรทั้งหมด');
  String get noResults => _t('No recipes found', 'ไม่พบเมนูที่ค้นหา');
  String get noResultsHint => _t('Try another keyword or category', 'ลองใช้คำค้นหรือหมวดอื่น');

  String get catAll => _t('All', 'ทั้งหมด');
  String category(RecipeCategory c) => switch (c) {
        RecipeCategory.thai => _t('Thai', 'อาหารไทย'),
        RecipeCategory.asian => _t('Asian', 'เอเชีย'),
        RecipeCategory.western => _t('Western', 'ตะวันตก'),
        RecipeCategory.sweets => _t('Sweets', 'ของหวาน'),
      };

  String difficulty(Difficulty d) => switch (d) {
        Difficulty.easy => _t('Easy', 'ง่าย'),
        Difficulty.medium => _t('Medium', 'ปานกลาง'),
      };

  String minutes(int m) => _t('$m min', '$m นาที');
  String servings(int s) => _t('$s servings', '$s ที่');
  String kcal(int k) => _t('$k kcal', '$k แคล');

  String get time => _t('Time', 'เวลา');
  String get serves => _t('Serves', 'สำหรับ');
  String get level => _t('Level', 'ระดับ');
  String get calories => _t('Calories', 'พลังงาน');

  String get ingredients => _t('Ingredients', 'วัตถุดิบ');
  String get steps => _t('Steps', 'วิธีทำ');
  String itemsCount(int n) => _t('$n items', '$n รายการ');
  String stepLabel(int n) => _t('Step $n', 'ขั้นตอนที่ $n');
  String stepOf(int n, int total) => _t('Step $n of $total', 'ขั้นตอน $n จาก $total');
  String get startCooking => _t('Start cooking', 'เริ่มทำอาหาร');
  String get next => _t('Next', 'ถัดไป');
  String get back => _t('Back', 'ย้อนกลับ');
  String get done => _t('Done', 'เสร็จแล้ว');
  String get enjoy => _t('Enjoy your meal!', 'ขอให้อร่อยนะ!');
  String get enjoyHint => _t('You\'ve finished every step.', 'คุณทำครบทุกขั้นตอนแล้ว');
  String get savedToFavorites => _t('Saved to favorites', 'บันทึกเมนูแล้ว');
  String get removedFromFavorites => _t('Removed from favorites', 'นำออกจากรายการที่บันทึก');

  String get noFavorites => _t('No saved recipes yet', 'ยังไม่มีเมนูที่บันทึก');
  String get noFavoritesHint =>
      _t('Tap the heart on any recipe to keep it here.', 'แตะรูปหัวใจที่เมนูเพื่อบันทึกไว้ที่นี่');
  String savedCount(int n) => _t('$n saved recipes', 'บันทึกไว้ $n เมนู');

  String get appearance => _t('Appearance', 'ธีม');
  String get light => _t('Light', 'สว่าง');
  String get dark => _t('Dark', 'มืด');
  String get system => _t('System', 'ตามระบบ');
  String get language => _t('Language', 'ภาษา');
  String get about => _t('About', 'เกี่ยวกับ');
  String get version => _t('Version', 'เวอร์ชัน');
  String get aboutText =>
      _t('Simple recipes, beautifully made.', 'สูตรอาหารง่ายๆ ทำได้ทุกวัน');
  String get clearFavorites => _t('Clear saved recipes', 'ล้างเมนูที่บันทึก');
  String get clearFavoritesConfirm =>
      _t('Remove all saved recipes?', 'ต้องการลบเมนูที่บันทึกทั้งหมดหรือไม่?');
  String get cancel => _t('Cancel', 'ยกเลิก');
  String get clear => _t('Clear', 'ล้าง');
}
