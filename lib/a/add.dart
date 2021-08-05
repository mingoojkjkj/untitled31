import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitled31/a/postcards.dart';
import 'package:untitled31/a/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path ; //중요!!!! 임시 저장소에 압충하기 위해 입시 저장소 path을 알아내기 위한 라이브러리
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Add extends StatefulWidget {
  Add({Key key}) : super(key : key);
  static const routeName = "/Add";

  @override
  _AddState createState() => _AddState();
}

class _AddState extends State<Add> {


  int Image_q = 0;
  String Image_Url;

  String downloadURL;
  File _image;
  final picker = ImagePicker();
  final _valueList = [
    'seventeen', //1
    'exo', //2
    'bts', //3
    'enhyphen', //4
    'nct' //5
  ];
  var _selectedValue = 'seventeen';
  var selectCheck = int.parse('1');
  final _demageList = [
     //1
    'demage no',
    'demage yes',
  ];
  var _selectedDemage = 'demage no';
  var selectdemage = int.parse('2');


  final GlobalKey<FormState> _titlefk = GlobalKey<FormState>();
  final GlobalKey<FormState> _pricefk=GlobalKey<FormState>();
  final GlobalKey<FormState> _memberfk = GlobalKey<FormState>();
  final GlobalKey<FormState> _demagefk = GlobalKey<FormState>();
  final GlobalKey<FormState> _callfk = GlobalKey<FormState>();

  TextEditingController title = TextEditingController();
  TextEditingController price =TextEditingController();
  TextEditingController member =TextEditingController();
  TextEditingController demage = TextEditingController();
  TextEditingController call = TextEditingController();

  FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  //컬랙션 명
  final String colName = 'data';

  // 필드명
  final String Image_Title = "title";
  final String Image_Price = 'price';
  final String Image_URL = "image_url";

  final String Image_demage= 'demage';
  final String Image_member = 'member';
  final String Image_call= 'call';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChangeNotifierProvider<ChangeSign>(
        create: (_) => ChangeSign(),
        child: SingleChildScrollView(
          child: ListBody(children: <Widget>[
            Stack(
                alignment: Alignment.bottomCenter,
                children: <Widget>[
                  Container(
                      child: _image == null ? Image.asset(
                        'assets/add_image.jpg',
                        fit: BoxFit.cover,
                      ): Image.file(_image, fit: BoxFit.cover,)
                  ),
                  Container(
                    color: Colors.black45,
                    height: 70,
                  ),
                  Column(

                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[

                        SimpleDialogOption(
                          child: Text('Capture Image with Camera', style: TextStyle(color: Colors.black,fontSize: 20.0),),
                          onPressed: captureImageWithCamera,
                        ),
                        SimpleDialogOption(
                          child: Text('Select Image from Gallery', style: TextStyle(color: Colors.black,fontSize: 20.0)),
                          onPressed: pickImageFromGallery,
                        ),
                      ]
                  )
                ]
            ),
            Center(
              child: Consumer<ChangeSign>(
                builder: (context, pro_value, child) => DropdownButton(
                  value: _selectedValue,
                  items: _valueList.map(
                        (value) {
                      return DropdownMenuItem(
                        value: value,
                        child: Text(value),
                      );
                    },
                  ).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedValue = value;
                      if (value == 'seventeen') selectCheck = 1;
                      if (value == 'bts') selectCheck = 1;
                      if (value == 'exo') selectCheck = 1;
                      if (value == 'enhyphen') selectCheck = 1;
                      if (value == 'nct') selectCheck = 1;
                      pro_value.ChangSelectedVale(selectCheck);
                    });
                  },
                ),
              ),
            ),
            if (selectCheck == 1) member_information(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                key: _titlefk,
                decoration: InputDecoration(
                    labelText: '글의 제목을 입력해주세요',
                    hintText: "title",
                    border: OutlineInputBorder()),
                controller: title,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                key: _pricefk,
                decoration: InputDecoration(
                    labelText: '가격을 입력해주세요',
                    hintText: "price",
                    border: OutlineInputBorder()),
                controller: price,
              ),
            ),
            Center(
              child: Consumer<ChangeSign>(
                builder: (context, pro_value, child) => DropdownButton(
                  value: _selectedDemage,
                  items: _demageList.map(
                        (value) {
                      return DropdownMenuItem(
                        value: value,
                        child: Text(value),
                      );
                    },
                  ).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedDemage = value;
                      if (value == 'demage no') selectdemage = 2;
                      if (value == 'demage yes') selectdemage = 3;
                      pro_value.ChangSelectedVale(selectdemage);
                    });
                  },
                ),
              ),
            ),
            if (selectdemage == 2) demageno_information(),
            if (selectdemage == 3) demageyes_information(),


            Seller_information(),
            SizedBox(
              height: 10,
            ),

            Row(
              children: <Widget>[
                Expanded(
                  child: RaisedButton(
                    child: Text('올리기'),
                    onPressed: () {
                      UpdateCustomDialog(context);
                    },
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: RaisedButton(
                    child: Text('취소'),
                    onPressed: () {
                      CancelCustomDialog(context);
                    },
                  ),
                )
              ],
            )
          ]),
        ),
      ),
    );
  }









  void createDoc(String name, String realprice,String URL,String calling, String who,String realdemage )
  {
    Firestore.instance.collection(colName).document(name).setData({
      Image_Title : name, //이미지 제목
      Image_Price : realprice,
      Image_URL: URL, // 이미지 URL
      Image_demage: realdemage,
    Image_call: calling,

    Image_member: who,

    });
  }






  //firebase에 이미지를 업로드 하는 함수
  _Update() async {
    //저장소 images 패키지에 title.txt라는 제목으로 저장한다.
    StorageReference storageReference = _firebaseStorage.ref().child("profile/${title.text}");

    // 파일 업로드
    StorageUploadTask storageUploadTask = storageReference.putFile(_image);

    // 파일 업로드 완료까지 대기
    await storageUploadTask.onComplete;

    String downloadURL = await storageReference.getDownloadURL();

    Image_q++;

    createDoc(title.text, price.text, downloadURL,member.text, call.text ,demage.text);

    Navigator.of(context).pop();


    return downloadURL;

  }

  Future _download() async{

  }

  void UpdateCustomDialog(BuildContext context) {
    Dialog simpleDialog = Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Container(
        height: 200.0,
        width: 300.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 15.0, top: 20.0, right: 15.0, bottom: 0.0),
              child: Text(
                '정말 올리시겠습니까?',
                style: TextStyle(
                    color: Color(0xFFFF1744),
                    fontFamily: 'Multilingual',
                    fontStyle: FontStyle.normal,
                    fontSize: 25
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  RaisedButton(
                    color: Color(0xFF0277BD),
                    onPressed: () async {
                      Image_Url = _Update();
                      print(Image_Url);
                      Navigator.pushNamed(context, '/b');
                    },
                    child: Text(
                      '올리기',
                      style: TextStyle(fontSize: 18.0, color: Colors.white,fontFamily: 'Multilingual',),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  RaisedButton(
                    color: Colors.red,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      '취소',
                      style: TextStyle(fontSize: 18.0, color: Colors.white),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
    showDialog(
        context: context, builder: (BuildContext context) => simpleDialog);
  }


  void CancelCustomDialog(BuildContext context) {
    Dialog simpleDialog = Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Container(
        height: 200.0,
        width: 300.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 15.0, top: 20.0, right: 15.0, bottom: 0.0),
              child: Text(
                '정말 취소할래요?',
                style: TextStyle(
                    color: Color(0xFFFF1744),
                    fontFamily: 'Multilingual',
                    fontStyle: FontStyle.normal,
                    fontSize: 25
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  RaisedButton(
                    color: Colors.red,
                    onPressed: ()
                    {Navigator.pushNamed(context, '/b');}

                    ,
                    child: Text(
                      '화면으로 돌아가기',
                      style: TextStyle(fontSize: 18.0, color: Colors.white),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
    showDialog(
        context: context, builder: (BuildContext context) => simpleDialog);
  }



  pickImageFromGallery() async {

    PickedFile imageFile = await picker.getImage(
      source: ImageSource.gallery,
      maxHeight: 680,
      maxWidth: 970,
    );
    setState(() {
      this._image = File(imageFile.path);
    });
  }

  captureImageWithCamera() async {

    PickedFile imageFile = await picker.getImage(
      source: ImageSource.camera,
      maxHeight: 680,
      maxWidth: 970,
    );
    setState(() {
      this._image = File(imageFile.path);
    });
  }







  //사진 파일 압축
  Future<File> _compressImage(File file, String targetPath) async {
    var result = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        targetPath,
        quality: 88,
        minWidth: 500,
        minHeight: 500
      //rotate: 180,
    );

    //단위 바이트 확률 높음
    print(file.lengthSync());
    print(result.lengthSync());

    return result;
  }

  //image을 가져오는 함수
  Future getImage(ImageSource source) async {
    // ignore: deprecated_member_use
    var image = await ImagePicker.pickImage(source: source);// sourece을 통해 이미지를 가져온다.
    var tempDir = await getTemporaryDirectory(); // 디렉토리경로를 가져온다.
    String tempPath = path.join(tempDir.path, path.basename(image.path));

    File tempImage = await _compressImage(image, tempPath);// 이미지 파일 압축

    //이미지에 이미지를 가져온 파일 경로에 있는 파일을 대입한다.
    setState(() {
      _image = File(tempImage.path);
    });
  }


  Widget member_information() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 6,
        child: Padding(
          padding: const EdgeInsets.only(
              left: 12.0, right: 12.0, top: 12.0, bottom: 12.0),
          child: Form(
            key:_memberfk,
            child: Column(children: <Widget>[
              Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Text(
                    '멤버를 입력합니다',
                    style: TextStyle(
                      fontFamily: 'Multilingual',
                      fontStyle: FontStyle.normal,
                      fontSize: 20,
                    ),
                  )),
              Row(
                children: <Widget>[
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: '멤버',
                        hintText: '활동명으로 입력해주세요',
                        border: OutlineInputBorder(),
                      ),
                      controller: member
                    ),
                  ),

                ],
              ),
            ]),
          ),
        ),
      ),
    );


  }


  Widget demageno_information() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 6,
        child: Padding(
          padding: const EdgeInsets.only(
              left: 12.0, right: 12.0, top: 12.0, bottom: 12.0),
          child: Form(

            child:
              Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Text(
                    '하자가 있는지 다시한번 확인해주세요',
                    style: TextStyle(
                      fontFamily: 'Multilingual',
                      fontStyle: FontStyle.normal,
                      fontSize: 20,
                    ),
                  )),

            ),
          ),
        ),
      );



  }


  Widget demageyes_information() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 6,
        child: Padding(
          padding: const EdgeInsets.only(
              left: 12.0, right: 12.0, top: 12.0, bottom: 12.0),
          child: Form(
            key: _demagefk,
            child: Column(children: <Widget>[
              Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Text(
                    '하자에 대해 상세히 설명해주세요.',
                    style: TextStyle(
                      fontFamily: 'Multilingual',
                      fontStyle: FontStyle.normal,
                      fontSize: 20,
                    ),
                  )),
              SizedBox(
                height: 10,
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: '내용',
                        hintText: '상세히 적어주세요',
                        border: OutlineInputBorder(),
                      ),
                      controller: demage,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),

            ]),
          ),
        ),
      ),
    );

}




  Widget Seller_information() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 6,
        child: Padding(
          padding: const EdgeInsets.only(
              left: 12.0, right: 12.0, top: 12.0, bottom: 12.0),
          child: Form(
            key: _callfk,
            child: Column(children: <Widget>[
              Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Text(
                    '판매자의 연락수단을 입력하세요.',
                    style: TextStyle(
                      fontFamily: 'Multilingual',
                      fontStyle: FontStyle.normal,
                      fontSize: 20,
                    ),
                  )),
              SizedBox(
                height: 10,
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: '채팅주소',
                        hintText: '카카오오픈채팅주소를 적어주세요',
                        border: OutlineInputBorder(),
                      ),
                      controller: call,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),

            ]),
          ),
        ),
      ),
    );
  }
}