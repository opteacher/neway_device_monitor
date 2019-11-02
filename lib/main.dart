import 'dart:async';import 'dart:convert';import 'dart:ui' as ui;import 'package:flutter/material.dart';import 'package:flutter/services.dart';import 'package:flutter/widgets.dart';import 'package:toast/toast.dart';import 'package:url_launcher/url_launcher.dart';import 'package:webview_flutter/webview_flutter.dart';import 'async.dart';void main() {	SystemChrome.setPreferredOrientations([		DeviceOrientation.landscapeLeft,		DeviceOrientation.landscapeLeft	]);	SystemChrome.setEnabledSystemUIOverlays([]);	return runApp(MyApp());}class MyApp extends StatelessWidget {	@override	Widget build(BuildContext context) => MaterialApp(		theme: ThemeData(			accentColor: Color(0xff616161)		),		home: MyHomePage(),		debugShowCheckedModeBanner: false	);}class MyHomePage extends StatefulWidget {	@override	_MyHomePageState createState() => _MyHomePageState();}const _refreshInterval = 10;class _PointInfo {	static const int released = 0;	static const int warning = 1;	final int pointID;	final String title;	final String desc;	final String time;	final String value;	final int status;	_PointInfo.fromJSON(Map<String, dynamic> json):		pointID = json["pointID"], status = json["status"],		time = json["time"], title = json["title"],		value = json["currentValue"].toString(),		desc = _MyHomePageState.poiDescs[json["pointID"]];}class _MyHomePageState extends State<MyHomePage> {	TextStyle _infoTxtStyle;	Timer _timer;	Timer _wngDlgTimer;	WebViewController _webViewController;	String _id = "...";	String _name = "...";	String _brand = "...";	String _prodDate = "...";	String _location = "...";	String _power = "...";	String _fullFuelHR = "...";	String _leftFuel = "...";	String _recycle = "...";	String _mtcycle = "...";	String _svcTime = "...";	String _noFaultTime = "...";	String _antifreezeTemp = "...";	String _batResistance = "...";	String _batLoadFactor = "...";	List<Map<String, String>> _svcRecords = [];	Map<int, _PointInfo> _points = {};	static final Map<int, String> poiDescs = {		17671279: "日用油箱液位低报警",		28365978: "液体泄漏报警",		10020979: "发电机烟雾报警",		26316957: "润滑油液位低报警",		25044485: "冷却水液位低报警",		-1: "蓄电池低压报警",		0: "机房烟雾报警"	};	bool _showWarning = false;	bool _showWarningDlg = false;	@override	void initState() {		super.initState();		_timer = Timer.periodic(Duration(seconds: _refreshInterval), _refresh);		_refresh(null);	}	@override	void dispose() {		super.dispose();		_timer.cancel();		_wngDlgTimer.cancel();	}	_chkShowWarningDlg(Timer t) async {		if (!_showWarningDlg && _points.values.any((p) => p.status == _PointInfo.warning)) {			_showWarningDlg = true;			await showDialog(context: context, builder: _buildWarningDlg);			_showWarningDlg = false;		}	}	_refresh(Timer timer) async {		// 报警信息		ResponseInfo ri = await getWarning();		List<dynamic> points = [];		if (ri.data != null && ri.data.isNotEmpty) {			points = ri.data.toList();			print(points);		}		ri = await getDevice();		if (ri.data == null) {			return;		}		setState(() {			_id = ri.data["code"];			_name = ri.data["deviceName"];			_brand = ri.data["brand"];			_prodDate = ri.data["buildTime"];			_location = ri.data["address"];			_power = ri.data["power"];			_fullFuelHR = ri.data["fuel"];			_leftFuel = ri.data["remainFuel"];			_recycle = ri.data["batteryReplaceCycle"];			_mtcycle = ri.data["mainteCycle"];			_svcTime = ri.data["serverStarted"];			_noFaultTime = ri.data["nullAlarmTime"];			_antifreezeTemp = ri.data["antifreeze"];			_batResistance = ri.data["batteryVoltage"];			_batLoadFactor = ri.data["batteryPower"];			final String contentBase64 = base64Encode(const Utf8Encoder().convert(ri.data["prompt"]));			if (_webViewController != null) {				_webViewController.loadUrl('data:text/html; charset=utf-8;base64,$contentBase64');			}			_svcRecords = ri.data["reports"].map<Map<String, String>>((report) => <String, String>{				"time": report["createdAt"].toString().replaceFirst(" ", "\n"),				"event": "${report["managerName"]}  ${report["typeStr"]}",				"id": report["code"]			}).toList();			_points = {				-1: _PointInfo.fromJSON(<String, dynamic>{					"pointID": -1,					"status": _PointInfo.released				}),				0: _PointInfo.fromJSON(<String, dynamic>{					"pointID": 0,					"status": _PointInfo.released				})			};			for (dynamic json in points) {				_PointInfo pi = _PointInfo.fromJSON(json);				_points[pi.pointID] = pi;			}		});		if (_wngDlgTimer == null) {			_wngDlgTimer = Timer.periodic(Duration(seconds: 30), _chkShowWarningDlg);			_chkShowWarningDlg(null);		}		print(ri.data);	}	Widget _genElecIndicator(String title, int ttlColor, Widget content) {		return Expanded(child: Container(			decoration: BoxDecoration(				color: Colors.white,				boxShadow: [BoxShadow(					color: Colors.black38,					blurRadius: 2.0				)],				borderRadius: BorderRadius.all(Radius.circular(5))			),			margin: EdgeInsets.all(5.0),			child: Column(children: <Widget>[				Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[					Expanded(child: Container(						decoration: BoxDecoration(							color: Color(ttlColor),							borderRadius: BorderRadius.vertical(top: Radius.circular(5))						),						padding: EdgeInsets.symmetric(vertical: 5),						child: Center(child: Text(title, style: TextStyle(							color: Colors.white,							fontSize: 20						)))					))				]),				Expanded(child: Center(child: content))			])		));	}	Widget _genRecordTable() {		Color txtClr = Color(0xff616161);		List<TableRow> children = [			TableRow(children: [				Padding(padding: EdgeInsets.symmetric(vertical: 10), child: Center(					child: Text("时间", style: TextStyle(color: txtClr))				)),				Padding(padding: EdgeInsets.symmetric(vertical: 10), child: Center(					child: Text("事项", style: TextStyle(color: txtClr))				)),				Padding(padding: EdgeInsets.symmetric(vertical: 10), child: Center(					child: Text("报告编号", style: TextStyle(color: txtClr))				)),			])		];		children.addAll(_svcRecords.map<TableRow>((rcd) => TableRow(children: [			Padding(padding: EdgeInsets.symmetric(vertical: 10), child: Center(				child: Text(rcd["time"], textAlign: TextAlign.center, style: TextStyle(color: txtClr))			)),			Padding(padding: EdgeInsets.symmetric(vertical: 10), child: Center(				child: Text(rcd["event"], textAlign: TextAlign.center, style: TextStyle(color: txtClr))			)),			Padding(padding: EdgeInsets.symmetric(vertical: 10), child: Center(				child: Text(rcd["id"], textAlign: TextAlign.center, style: TextStyle(color: txtClr))			)),		])));		return Container(decoration: BoxDecoration(			border: Border.all(color: Colors.grey[300])		), child: Table(			columnWidths: {				0: FractionColumnWidth(0.25),				1: FractionColumnWidth(0.5),				2: FractionColumnWidth(0.25),			},			border: TableBorder.symmetric(inside: BorderSide(color: Colors.grey[300])),			defaultVerticalAlignment: TableCellVerticalAlignment.middle,			children: children		));	}	Widget _genInfoCard(String title, Color hcolor, Widget child) => Expanded(		child: GestureDetector(			child: Container(				decoration: BoxDecoration(					color: Color(0xffe6fafa),					border: Border.all(color: Color(0xffB4B4B4)),					borderRadius: BorderRadius.all(Radius.circular(10))				),				margin: EdgeInsets.only(bottom: 5),				child: Row(children: <Widget>[					Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[						Expanded(child: Container(							decoration: BoxDecoration(								color: hcolor,								borderRadius: BorderRadius.horizontal(left: Radius.circular(10))							),							padding: EdgeInsets.symmetric(horizontal: 10),							child: Center(child: Text(title, style: TextStyle(								color: Colors.white,								fontSize: 25							)))						))					]),					Padding(						padding: EdgeInsets.symmetric(horizontal: 35),						child: Center(child: child)					)				])			),			onTap: () => setState(() { _showWarning = !_showWarning; })		)	);	AlertDialog _buildWarningDlg(BuildContext context) {		Color blackClr = Color(0xff616161);		Color blueClr = Color(0xff417DE7);		Color redClr = Color(0xffC46262);		final onClickContact = () async {			const url = "tel:4006609233";			if (await canLaunch(url)) {				await launch(url);			} else {				Toast.show("无法拨打电话", context);			}		};		return AlertDialog(			shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),			titlePadding: EdgeInsets.all(0),			title: Row(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[				IconButton(icon: Icon(Icons.cancel, color: Color(0xffC6CCD5)), onPressed: () {					Navigator.pop(context);					_showWarningDlg = false;				})			]),			contentPadding: EdgeInsets.only(bottom: 35),			content: Container(width: 500, height: 200,				child: Center(child: Column(					mainAxisAlignment: MainAxisAlignment.center,					children: <Widget>[						Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[							Image.asset("images/warning.png", width: 80, height: 80),							VerticalDivider(color: Colors.white),							Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[								Text("烟雾报警器报警！", style: TextStyle(fontSize: 30, color: redClr)),								Text("请尽快联系我司", style: TextStyle(fontSize: 20, color: blackClr)),								Row(children: <Widget>[									Text("联系电话", style: TextStyle(fontSize: 20, color: blackClr)),									FlatButton(										padding: EdgeInsets.symmetric(horizontal: 10),										child: Text("400-660-9233", style: TextStyle(fontSize: 20, color: blueClr)),										onPressed: onClickContact									)								])							])						])					]				))			)		);	}	Widget _geninfoRecord(String content, [Color flgColor = const Color(0xffD8D8D8)]) => Row(children: <Widget>[		Icon(Icons.brightness_1, color: flgColor, size: 15),		VerticalDivider(),		Text(content, style: _infoTxtStyle)	]);	@override	Widget build(BuildContext context) {		_infoTxtStyle = TextStyle(color: Color(0xff616161), fontSize: 20);		return Scaffold(			body: Padding(padding: EdgeInsets.all(10), child: Column(children: <Widget>[				Expanded(child: Row(children: <Widget>[					Expanded(flex: 2, child: Container(						margin: EdgeInsets.only(right: 20, bottom: 5),						child: DeviceStatus(this)					)),					Expanded(child: _showWarning ? Column(children: <Widget>[						_genInfoCard("报\n警\n显\n示", Color(0xffC46262), Column(							crossAxisAlignment: CrossAxisAlignment.start,							mainAxisAlignment: MainAxisAlignment.center,							children: _points.values.map<Widget>((point) => _geninfoRecord(point.desc,								point.status == _PointInfo.warning ? Color(0xffC46262) : Color(0xff85C25E)							)).toList()						))					]) : Column(children: <Widget>[						_genInfoCard("机\n组\n信\n息", Color(0xff62c4ac), Column(							crossAxisAlignment: CrossAxisAlignment.start,							mainAxisAlignment: MainAxisAlignment.center,							children: <Widget>[								_geninfoRecord("乐维编号：$_id"),								_geninfoRecord("名称：$_name"),								_geninfoRecord("品牌：$_brand"),								_geninfoRecord("生产日期：$_prodDate"),								_geninfoRecord("位置：$_location"),								_geninfoRecord("功率：$_power")							]						)),						_genInfoCard("参\n考\n信\n息", Color(0xff77C0F4), Column(							crossAxisAlignment: CrossAxisAlignment.start,							mainAxisAlignment: MainAxisAlignment.center,							children: <Widget>[								_geninfoRecord("满载耗油：$_fullFuelHR"),								_geninfoRecord("剩余燃油：$_leftFuel"),								_geninfoRecord("蓄电池更换周期：$_recycle"),								_geninfoRecord("机组保养周期：$_mtcycle")							]						))					])),				])),				Expanded(child: Container(					decoration: BoxDecoration(						border: Border.all(color: Color(0xffB4B4B4)),						borderRadius: BorderRadius.all(Radius.circular(10))					),					padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),					child: Row(children: <Widget>[						Expanded(child: Column(children: <Widget>[							Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[								Text("发电机相关指标", style: TextStyle(color: Color(0xff616161), fontSize: 25))							]),							Divider(color: Color(0xffF8A72C), endIndent: 180),							Expanded(child: Column(children: <Widget>[								Expanded(child: Row(children: <Widget>[									_genElecIndicator("乐维服务时长", 0xffF8A72C, Row(										mainAxisAlignment: MainAxisAlignment.center,										crossAxisAlignment: CrossAxisAlignment.end,										children: <Widget>[											Text(_svcTime.toString(), style: TextStyle(color: Color(0xffB4B4B4), fontSize: 50)),											Text("天", style: TextStyle(color: Color(0xffB4B4B4), fontSize: 20))										]									)),									_genElecIndicator("平均无故障时间", 0xff62C4AC, Row(										mainAxisAlignment: MainAxisAlignment.center,										crossAxisAlignment: CrossAxisAlignment.end,										children: <Widget>[											Text(_noFaultTime.toString(), style: TextStyle(color: Color(0xffB4B4B4), fontSize: 50)),											Text("天", style: TextStyle(color: Color(0xffB4B4B4), fontSize: 20))										]									))								])),								Expanded(child: Row(children: <Widget>[									_genElecIndicator("防冻液", 0xff77C0F4, Row(										mainAxisAlignment: MainAxisAlignment.center,										crossAxisAlignment: CrossAxisAlignment.end,										children: <Widget>[											Text(_antifreezeTemp.toString(), style: TextStyle(color: Color(0xffB4B4B4), fontSize: 50)),											Text("℃", style: TextStyle(color: Color(0xffB4B4B4), fontSize: 20))										]									)),									_genElecIndicator("蓄电池", 0xffC46262, Padding(										padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),										child: Column(children: <Widget>[											Expanded(child: Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[												Text("${_batResistance}mΩ", style: TextStyle(color: Color(0xffB4B4B4), fontSize: 30))											])),											Expanded(child: Row(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[												Text("$_batLoadFactor%", style: TextStyle(color: Color(0xffB4B4B4), fontSize: 30))											]))										])									))								]))							]))						])),						VerticalDivider(width: 40),						Expanded(child: Column(children: <Widget>[							Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[								Text("服务记录", style: TextStyle(color: Color(0xff616161), fontSize: 25))							]),							Divider(color: Color(0xffF8A72C), endIndent: 250),							_genRecordTable()						])),						VerticalDivider(width: 40),						Expanded(child: Column(children: <Widget>[							Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[								Text("温馨提示", style: TextStyle(color: Color(0xff616161), fontSize: 25))							]),							Divider(color: Color(0xffF8A72C), endIndent: 250),							Container(								height: 350,								child: WebView(									initialUrl: "",									onWebViewCreated: (WebViewController webViewController) {										_webViewController = webViewController;									}								)							)						]))					])				))			]))		);	}}class DeviceStatus extends StatefulWidget {	final _MyHomePageState _parent;	DeviceStatus(this._parent);	@override	State<StatefulWidget> createState() => _DeviceStatusState(_parent);}enum DetailLoc {	LT, LB, RT, RB}class _PoiOnPic {	static final double size = 40;	Offset location;	final int id;	final String name;	String type;	String status;	DetailLoc dtlLoc;	bool show = false;	_PoiOnPic(this.location, this.id, this.name, this.dtlLoc);	_PoiOnPic.fromSensorJSON(Map json):			id = json["id"],			name = json["name"],			type = json["type"].toString() {		String dictionary = json["dictionary"];		if (dictionary != null && dictionary.isNotEmpty) {			status = dictionary;		} else {			status = '${json["value"].toString()}${" " + json["unit"]}';		}	}}class _DeviceStatusState extends State<DeviceStatus> with SingleTickerProviderStateMixin {	final _MyHomePageState _parent;	ui.Image imgBackground;	AnimationController _controller;	Animation<Color> _animation;	Color infoColor;	static final List<int> poiSort = [		10578605, // 1#蓄电池电压		10681384, // 2#蓄电池电压		18571413, // 3#蓄电池电压		19809727, // 4#蓄电池电压		20299919, // 1#蓄电池温度		20767452, // 2#蓄电池温度		21253465, // 3#蓄电池温度		21311334, // 4#蓄电池温度		22856421, // 1#蓄电池内阻		23853631, // 2#蓄电池内阻		24730169, // 3#蓄电池内阻		24839049, // 4#蓄电池内阻		10020979, // 烟雾报警器		17433258, // 预留		17671279, // 油箱液位		20625587, // 预留		23331729, // 电池电压		25044485, // 冷却水液位		26316957, // 润滑油液位		28365978, // 液体泄漏		18958266, // 温度		22837511, // 湿度	];	List<_PoiOnPic> picPois = [		_PoiOnPic(Offset(1 / 16.4,    1 / 1.35),      17671279,   "日用油箱", DetailLoc.LB),		_PoiOnPic(Offset(1 / 27.33,   1 / 3.208),     0,          "温湿度",         DetailLoc.LB),		_PoiOnPic(Offset(1 / 1.80,    1 / 1.25),      26316957,   "润滑油",  DetailLoc.LB),		_PoiOnPic(Offset(1 / 2.05,    -_PoiOnPic.size), -1,         "蓄电池",  DetailLoc.LB),		_PoiOnPic(Offset(1 / 4.5,     -_PoiOnPic.size), 28365978,   "液体泄漏", DetailLoc.LB),		_PoiOnPic(Offset(1 / 1.58,    1 / 3.208),     10020979,   "发电机烟雾",    DetailLoc.LT),		_PoiOnPic(Offset(1 / 1.25,     1 / 1.48),      25044485,   "冷却水",  DetailLoc.RB)	];	List<_PoiOnPic> _poiInfos = [];	double _cvsWid = 0;	double _cvsHgt = 0;	bool _showDetailList = false;	Timer _timer;	_DeviceStatusState(this._parent);	@override	void initState() {		super.initState();		_initialize();		_startAnim();	}	_startAnim() {		_controller = AnimationController(			duration: const Duration(seconds: 1),			vsync: this		);		var tween = ColorTween(begin: Color(0xFFd81e06), end: Color(0x00d81e06));		_animation = tween.animate(_controller);		_animation.addListener(() {			infoColor = _animation.value;			setState(() {});		});		_animation.addStatusListener((status) {			switch (status) {				case AnimationStatus.forward:					break;				case AnimationStatus.reverse:					break;				case AnimationStatus.completed:					_controller.reverse();					break;				case AnimationStatus.dismissed:					_controller.forward();					break;			}		});		_controller.forward();	}	@override	void dispose() {		super.dispose();		_controller.dispose();		_timer.cancel();	}	_refresh(Timer t) async {		// 点位信息		ResponseInfo ri = await getSensor();		if (ri.data == null) {			return;		}		Map<int, _PoiOnPic> shuffle = {};		for (var item in ri.data) {			_PoiOnPic pi = _PoiOnPic.fromSensorJSON(item);			shuffle[pi.id] = pi;		}		setState(() {			_poiInfos = [];			for (int id in poiSort) {				if (shuffle[id] != null) {					_poiInfos.add(shuffle[id]);				}			}		});		print(ri.data);	}	_initialize() async {		imgBackground = await _loadImage("images/background.png");		_timer = Timer.periodic(Duration(seconds: _refreshInterval), _refresh);		_refresh(_timer);	}	_loadImage(String asset) async {		ByteData data = await rootBundle.load(asset);		ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List());		ui.FrameInfo fi = await codec.getNextFrame();		return fi.image;	}	@override	Widget build(BuildContext context) => !_showDetailList ? GestureDetector(		onTapUp: (TapUpDetails detail) {			RenderBox rb = context.findRenderObject();			Offset pos = rb.globalToLocal(detail.globalPosition);			bool clkPoiInfo = false;			for (_PoiOnPic info in picPois) {				if (Rect.fromLTWH(					info.location.dx, info.location.dy,					_PoiOnPic.size, _PoiOnPic.size				).contains(pos)) {					info.show = !info.show;					setState(() {});					clkPoiInfo = true;					break;				}			}			if (!clkPoiInfo) {				setState(() {					_showDetailList = true;				});			}		},		child: CustomPaint(			size: Size(1600, 900),			painter: _DeviceStatusView(this, _parent)		)	) : GestureDetector(		onTap: () => setState(() {			_showDetailList = false;		}),		child: GridView.count(childAspectRatio: 5 / 2, crossAxisCount: 4, children: _poiInfos.map<Widget>((info) => Padding(			padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),			child: Column(children: <Widget>[				Row(children: <Widget>[					Expanded(child: Text(info.name, style: TextStyle(color: Color(0xff616161), fontSize: 15)), flex: 2),					Expanded(child: Row(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[						Text(info.status, style: TextStyle(color: Color(0xff616161), fontSize: 15))					]))				]),				Divider()			])		)).toList())	);	set cvsSize(Size size) {		if (_cvsWid != 0 && _cvsHgt != 0) {			return;		}		_cvsWid = size.width;		_cvsHgt = size.height;		for (_PoiOnPic info in picPois) {			info.location = Offset(				info.location.dx > 0 ? _cvsWid * info.location.dx : _cvsWid + info.location.dx,				info.location.dy > 0 ? _cvsHgt * info.location.dy : _cvsHgt + info.location.dy			);		}	}}class _DeviceStatusView extends CustomPainter {	final _DeviceStatusState _state;	final _MyHomePageState _parent;	_DeviceStatusView(this._state, this._parent);	@override	void paint(Canvas canvas, Size size) {		// 绘制背景		if (_state.imgBackground == null) {			_state.cvsSize = size;			return;		}		Paint _paint = Paint();		canvas.drawImageRect(_state.imgBackground,			Rect.fromLTWH(0, 0,				_state.imgBackground.width.toDouble(),				_state.imgBackground.height.toDouble()),			Rect.fromLTWH(0, 0, size.width, size.height), _paint);		// 绘制点位		if (_parent._points == null) {			return;		}		TextPainter icnTp = TextPainter(textDirection: TextDirection.rtl);		for (_PoiOnPic info in _state.picPois) {			_PointInfo pi = _parent._points[info.id];			Color color = Color(0xff21ef2f);			if (pi != null && pi.status == _PointInfo.warning) {				color = _state.infoColor;//				if (info.show) {//					color = Color(0xFFF79D27);////					// 绘制点位信息//					double left = info.location.dx + _PoiOnPic.size;//					double top = info.location.dy;//					double hpadding = 15;//					double vpadding = 10;////					TextPainter dtlTp = TextPainter(textDirection: TextDirection.ltr);//					dtlTp.text = TextSpan(//						text: "名称：${info.name}\n型号：${info.type}\n状态：${info.status}",//						style: TextStyle(fontSize: 20, color: Colors.white)//					);//					dtlTp.layout();////					_paint.color = Color(0xAA02093D);//					double dtlX = left;//					double dtlY = top;//					double dtlWid = dtlTp.size.width + hpadding * 2;//					double dtlHgt = dtlTp.size.height + vpadding * 2;//					switch (info.dtlLoc) {//						case DetailLoc.LT://							break;//						case DetailLoc.LB://							dtlY -= dtlHgt - _PoiOnPic.size;//							break;//						case DetailLoc.RT://							dtlX -= dtlWid + _PoiOnPic.size;//							break;//						case DetailLoc.RB://							dtlY -= dtlHgt - _PoiOnPic.size;//							dtlX -= dtlWid + _PoiOnPic.size;//							break;//					}//					canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(//						dtlX, dtlY, dtlWid, dtlHgt//					), Radius.circular(8)), _paint);//					dtlTp.paint(canvas, Offset(dtlX + hpadding, dtlY + vpadding));//				}			}			icnTp.text = TextSpan(				text: String.fromCharCode(Icons.info.codePoint),				style: TextStyle(					fontSize: _PoiOnPic.size,					fontFamily: Icons.info.fontFamily,					color: color				)			);			icnTp.layout();			icnTp.paint(canvas, info.location);		}	}	@override	bool shouldRepaint(CustomPainter oldDelegate) => true;}