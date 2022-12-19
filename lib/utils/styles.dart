import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class MyColors {
//Уусалттай үндсэн өнгө
  static Color fadedRed = const Color(0xFFFF0002).withOpacity(0.045);
  //Шаргал өнгө
  //Саарал өнгө
  static const Color grey = Color.fromRGBO(204, 204, 204, 1);
  //Уусалттай саарал өнгө
  static Color fadedGrey = const Color(0xFFCCCCCC).withOpacity(0.15);
  //Ногоон өнгө
  static const Color green = Color.fromRGBO(19, 177, 92, 1);
  //Дэвсгэр өнгө
  static const Color bgColor = Color.fromRGBO(250, 248, 248, 1);
  //Дэвсгэр өнгө
  static const Color gr1 = Color.fromRGBO(255, 229, 45, 0.15);
  //Дэвсгэр өнгө
  static const Color gr2 = Color.fromRGBO(255, 179, 18, 0.09);
  //Бууралттай улаан өнгө
  static const Color pinkyRed = Color.fromARGB(237, 67, 55, 1);
  //Шинэ өнгөнүүд

  // Үндсэн өнгө
  static const Color primary = Color(0xffF01F0E);
  static const Color black = Color(0xff222222);
  static const Color gray = Color(0xff9B9B9B);
  static const Color background = Color(0xffedeff4);
  static const Color white = Color(0xffFFFFFF);
  static const Color error = Color(0xffee476f);
  static const Color success = Color(0xff28a745);
  static const Color warning = Color(0xFFffd200);
  static const Color border = Color(0xffdddddd);
  static const Color fadedGreen = Color(0xffd8f4e5);
}

//Үсгийн фонт
class MyFonts {
  static const String firaSans = 'FiraSans';
}

class URL {
  static const String AWS =
      "https://et24-images.s3.ap-northeast-1.amazonaws.com";
  static const String data =
      'https://us-central1-erdenet-12083.cloudfunctions.net/app/api/read';
  static const String userInfo =
      "https://erdenet-12083-default-rtdb.firebaseio.com/orders.json";
  // static const String userInfo =
  //     "https://shine-d823c-default-rtdb.firebaseio.com/orders.json";
}

//Үсгийн хэмжээ
class MyFontSizes {
  static const double large = 16;
  static const double normal = 14;
  static const double small = 12;
}

class MyDimentions {
  //Үндсэн border radius
  static const double cornerRadius = 8;
  static const double smallRadius = 4;
  static const double buttonRadius = 8;
//Хажуугийн padding
  static const double smallPadding = 10;
  static const double normalPadding = 20;
  static const double largePadding = 30;
  //Border width
  static const double borderWidth = 0.3;
  static const double borderSmallWidth = 0.05;
  //Button elevation
  static const double elevation = 2;
}

class MyTexts {
  static const contract =
      "1. Erdenet24.mn вэбсайтын хүнс захиалга хүргэлтийн үйлчилгээ нь өдөр бүр 10:00-11:00, 12:30-13:30, 15:30-16:30, 18:00-19:00 цагуудад хүргэлт хийгдэнэ. \n 2. Захиалагч захиалгын мэдээллээ үнэн зөв бөглөсний дараа гүйлгээний утга хэсэгт утасны дугаараа оруулж, дансаар гүйлгээ хийсний дараа БАТЛАХ товчыг дарсанаар гүйлгээ идэвхжинэ. \n 3. Барааг бүрэн бүтэн хүргэж өгнө. Захиалагчид хүлээлгэн өгч гарын үсэг зуруулснаас хойш барааг захиалагчийн мэдэлд бүрэн шилжсэнд тооцно. \n 4. 3 –т зааснаас бусад тохиолдолд бараа бүтээгдэхүүний буцаалт хийх боломжгүй тул сонголтоо зөв хийнэ үү. \n 5. Үйлдвэрлэл болон хадгалалт, хүргэлтээс үүдэлтэй бараа бүтээгдэхүүний гэмтэл ба чанарын доголдлыг 12 цагийн дотор Erdenet24.mn – ийн 99352223 дугаарт мэдэгдэж буцаалт хийнэ. \n 6. Захиалагч илүү төлөлт хийсэн тохиолдолд илүүдэл дүнг захиалагчийн дансруу эргүүлэн шилжүүлнэ. \n 7. Захиалагч төлбөрөө дутуу шилжүүлсэн тохиолдолд үлдэгдэл дүнг гүйцээж шилжүүлсэний хийсний дараа гүйлгээ баталгаажих ба уг захиалгын хүргэлтийн хугацааг үлдэгдэл төлбөр хийгдсэний дараа дахин сонгоно. \n 8. Захиалагч 20000 төгрөгнөөс дээш үнийн дүнтэй захиалга өгсөн тохиолдолд Эрдэнэт микр хороолол дотор үнэгүй хүргэлт хийнэ.";
}

String capitalize(String value) {
  var result = value[0].toUpperCase();
  bool cap = true;
  for (int i = 1; i < value.length; i++) {
    if (value[i - 1] == " " && cap == true) {
      result = result + value[i].toUpperCase();
    } else {
      result = result + value[i];
      cap = false;
    }
  }
  return result;
}
// final helloWorld = 'hello world'.toCapitalized(); // 'Hello world'
// final helloWorld = 'hello world'.toUpperCase(); // 'HELLO WORLD'
// final helloWorldCap = 'hello world'.toTitleCase(); // 'Hello World'
