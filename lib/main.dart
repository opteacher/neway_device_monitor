import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'dart:ui' as ui;

void main() {
	SystemChrome.setPreferredOrientations([
		DeviceOrientation.landscapeLeft,
		DeviceOrientation.landscapeLeft
	]);
	SystemChrome.setEnabledSystemUIOverlays([]);
	return runApp(MyApp());
}

class MyApp extends StatelessWidget {
	@override
	Widget build(BuildContext context) => MaterialApp(
		theme: ThemeData(
			accentColor: Color(0xff616161)
		),
		home: MyHomePage(),
	);
}

class MyHomePage extends StatefulWidget {
	@override
	_MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
	TextStyle _infoTxtStyle;

	int _id = 10032;
	String _name = "乐维机组1#";
	String _brand = "Cummins";
	String _prodDate = "2014/03/27";
	String _location = "虹口区邯郸路173号";
	int _power = 1200;
	int _fullFuelHR = 180;
	int _leftFuel = 100;
	int _recycle = 2;
	int _mtcycle = 1;
	int _svcTime = 288;
	int _noFaultTime = 365;
	double _antifreezeTemp = -16;
	double _batResistance = 1.62;
	double _batLoadFactor = 68;
	List<Map<String, String>> _svcRecords = [{
		"time": "2019.03.15",
		"event": "工程师张伟强 机组保养",
		"id": "B190327"
	}, {
		"time": "2019.03.15",
		"event": "工程师张伟强 机组保养",
		"id": "B190327"
	}, {
		"time": "2019.03.15",
		"event": "工程师张伟强 机组保养",
		"id": "B190327"
	}, {
		"time": "2019.03.15",
		"event": "工程师张伟强 机组保养",
		"id": "B190327"
	}, {
		"time": "2019.03.15",
		"event": "工程师张伟强 机组保养",
		"id": "B190327"
	}, {
		"time": "2019.03.15",
		"event": "工程师张伟强 机组保养",
		"id": "B190327"
	}];
	bool _showWarning = false;

	Widget _genElecIndicator(String title, int ttlColor, double ttlHpdg, Widget content) {
		return Expanded(child: Card(child: Column(children: <Widget>[
			Container(
				decoration: BoxDecoration(
					color: Color(ttlColor),
					borderRadius: BorderRadius.vertical(top: Radius.circular(4))
				),
				padding: EdgeInsets.symmetric(vertical: 10, horizontal: ttlHpdg),
				child: Text(title, style: TextStyle(color: Colors.white, fontSize: 20))
			),
			Expanded(child: Center(child: content))
		])));
	}

	Widget _genRecordTable() {
		Color txtClr = Color(0xff616161);
		List<TableRow> children = [
			TableRow(children: [
				Padding(padding: EdgeInsets.symmetric(vertical: 10), child: Center(
					child: Text("时间", style: TextStyle(color: txtClr))
				)),
				Padding(padding: EdgeInsets.symmetric(vertical: 10), child: Center(
					child: Text("事项", style: TextStyle(color: txtClr))
				)),
				Padding(padding: EdgeInsets.symmetric(vertical: 10), child: Center(
					child: Text("报告编号", style: TextStyle(color: txtClr))
				)),
			])
		];
		children.addAll(_svcRecords.map<TableRow>((rcd) => TableRow(children: [
			Padding(padding: EdgeInsets.symmetric(vertical: 10), child: Center(
				child: Text(rcd["time"], style: TextStyle(color: txtClr))
			)),
			Padding(padding: EdgeInsets.symmetric(vertical: 10), child: Center(
				child: Text(rcd["event"], style: TextStyle(color: txtClr))
			)),
			Padding(padding: EdgeInsets.symmetric(vertical: 10), child: Center(
				child: Text(rcd["id"], style: TextStyle(color: txtClr))
			)),
		])));
		return Container(decoration: BoxDecoration(
			border: Border.all(color: Colors.grey[300])
		), child: Table(
			columnWidths: {
				0: FractionColumnWidth(0.25),
				1: FractionColumnWidth(0.5),
				2: FractionColumnWidth(0.25),
			},
			border: TableBorder.symmetric(inside: BorderSide(color: Colors.grey[300])),
			defaultVerticalAlignment: TableCellVerticalAlignment.middle,
			children: children
		));
	}

	Widget _genInfoCard(String title, Color hcolor, Widget child) => Expanded(
		child: GestureDetector(
			child: Container(
				decoration: BoxDecoration(
					color: Color(0xffe6fafa),
					border: Border.all(color: Color(0xffB4B4B4)),
					borderRadius: BorderRadius.all(Radius.circular(10))
				),
				margin: EdgeInsets.only(bottom: 5),
				child: Row(children: <Widget>[
					Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
						Expanded(child: Container(
							decoration: BoxDecoration(
								color: hcolor,
								borderRadius: BorderRadius.horizontal(left: Radius.circular(10))
							),
							padding: EdgeInsets.symmetric(horizontal: 10),
							child: Center(child: Text(title, style: TextStyle(
								color: Colors.white,
								fontSize: 25
							)))
						))
					]),
					Padding(
						padding: EdgeInsets.symmetric(horizontal: 35, vertical: 10),
						child: Center(child: child)
					)
				])
			),
			onTap: () => setState(() { _showWarning = !_showWarning; })
		)
	);

	Widget _geninfoRecord(String content, [Color flgColor = const Color(0xffD8D8D8)]) => Row(children: <Widget>[
		Icon(Icons.brightness_1, color: flgColor, size: 15),
		VerticalDivider(),
		Text(content, style: _infoTxtStyle)
	]);

	@override
	Widget build(BuildContext context) {
		_infoTxtStyle = TextStyle(color: Color(0xff616161), fontSize: 20);
		Timer(Duration(milliseconds: 500), () {
			Color blackClr = Color(0xff616161);
			Color blueClr = Color(0xff417DE7);
			Color redClr = Color(0xffC46262);
			showDialog(context: context, builder: (BuildContext context) => AlertDialog(
				shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
				titlePadding: EdgeInsets.all(0),
				title: Row(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
					IconButton(icon: Icon(Icons.cancel, color: Color(0xffC6CCD5)), onPressed: () {
						Navigator.pop(context);
					})
				]),
				contentPadding: EdgeInsets.only(bottom: 35),
				content: Container(
					width: 500,
					height: 200,
					child: Center(child: Column(
						mainAxisAlignment: MainAxisAlignment.center,
						children: <Widget>[
							Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
								Icon(Icons.warning, size: 80, color: redClr),
								VerticalDivider(color: Colors.white),
								Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
									Text("烟雾报警器报警！", style: TextStyle(fontSize: 30, color: redClr)),
									Text("请尽快联系我司", style: TextStyle(fontSize: 20, color: blackClr)),
									Row(children: <Widget>[
										Text("联系电话", style: TextStyle(fontSize: 20, color: blackClr)),
										VerticalDivider(color: Colors.white),
										Text("400-660-9233", style: TextStyle(fontSize: 20, color: blueClr))
									])
								])
							])
						]
					))
				)
			));
		});
		return Scaffold(
			body: Padding(padding: EdgeInsets.all(10), child: Column(children: <Widget>[
				Expanded(child: Row(children: <Widget>[
					Expanded(flex: 2, child: Container(
						margin: EdgeInsets.only(right: 20, bottom: 5),
						child: DeviceStatus()
					)),
					Expanded(child: _showWarning ? Column(children: <Widget>[
						_genInfoCard("报\n警\n显\n示", Color(0xffC46262), Column(
							crossAxisAlignment: CrossAxisAlignment.start,
							children: <Widget>[
								_geninfoRecord("发电机房烟雾报警", Color(0xffC46262)),
								_geninfoRecord("日用油箱液位低报警", Color(0xff85C25E)),
								_geninfoRecord("蓄电池低压报警", Color(0xff85C25E)),
								_geninfoRecord("冷却水液位低报警"),
								_geninfoRecord("润滑油液位低"),
								_geninfoRecord("液体泄露报警")
							]
						))
					]) : Column(children: <Widget>[
						_genInfoCard("机\n组\n信\n息", Color(0xff62c4ac), Column(
							crossAxisAlignment: CrossAxisAlignment.start,
							children: <Widget>[
								_geninfoRecord("乐维编号：$_id"),
								_geninfoRecord("名称：$_name"),
								_geninfoRecord("品牌：$_brand"),
								_geninfoRecord("生产日期：$_prodDate"),
								_geninfoRecord("位置：$_location"),
								_geninfoRecord("功率：${_power}KW")
							]
						)),
						_genInfoCard("参\n考\n信\n息", Color(0xff77C0F4), Column(
							crossAxisAlignment: CrossAxisAlignment.start,
							children: <Widget>[
								_geninfoRecord("满载耗油：${_fullFuelHR}L/h"),
								_geninfoRecord("剩余燃油：${_leftFuel}L"),
								_geninfoRecord("蓄电池更换周期：$_recycle年"),
								_geninfoRecord("机组保养周期：$_mtcycle年")
							]
						))
					])),
				])),
				Expanded(child: Container(
					decoration: BoxDecoration(
						border: Border.all(color: Color(0xffB4B4B4)),
						borderRadius: BorderRadius.all(Radius.circular(10))
					),
					padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
					child: Row(children: <Widget>[
						Expanded(child: Column(children: <Widget>[
							Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
								Text("发电机相关指标", style: TextStyle(color: Color(0xff616161), fontSize: 25))
							]),
							Divider(color: Color(0xffF8A72C), endIndent: 180),
							Expanded(child: Column(children: <Widget>[
								Expanded(child: Row(children: <Widget>[
									_genElecIndicator("乐维服务时长", 0xffF8A72C, 30, Row(
										mainAxisAlignment: MainAxisAlignment.center,
										crossAxisAlignment: CrossAxisAlignment.end,
										children: <Widget>[
											Text(_svcTime.toString(), style: TextStyle(color: Color(0xffB4B4B4), fontSize: 50)),
											Text("天", style: TextStyle(color: Color(0xffB4B4B4), fontSize: 20))
										]
									)),
									_genElecIndicator("平均无故障时间", 0xff62C4AC, 20, Row(
										mainAxisAlignment: MainAxisAlignment.center,
										crossAxisAlignment: CrossAxisAlignment.end,
										children: <Widget>[
											Text(_noFaultTime.toString(), style: TextStyle(color: Color(0xffB4B4B4), fontSize: 50)),
											Text("天", style: TextStyle(color: Color(0xffB4B4B4), fontSize: 20))
										]
									))
								])),
								Expanded(child: Row(children: <Widget>[
									_genElecIndicator("防冻液", 0xff77C0F4, 60, Row(
										mainAxisAlignment: MainAxisAlignment.center,
										crossAxisAlignment: CrossAxisAlignment.end,
										children: <Widget>[
											Text(_antifreezeTemp.toString(), style: TextStyle(color: Color(0xffB4B4B4), fontSize: 50)),
											Text("℃", style: TextStyle(color: Color(0xffB4B4B4), fontSize: 20))
										]
									)),
									_genElecIndicator("蓄电池", 0xffC46262, 60, Padding(
										padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
										child: Column(children: <Widget>[
											Expanded(child: Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
												Text("${_batResistance}mΩ", style: TextStyle(color: Color(0xffB4B4B4), fontSize: 30))
											])),
											Expanded(child: Row(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
												Text("${_batLoadFactor}%", style: TextStyle(color: Color(0xffB4B4B4), fontSize: 30))
											]))
										])
									))
								]))
							]))
						])),
						VerticalDivider(width: 40),
						Expanded(child: Column(children: <Widget>[
							Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
								Text("服务记录", style: TextStyle(color: Color(0xff616161), fontSize: 25))
							]),
							Divider(color: Color(0xffF8A72C), endIndent: 250),
							_genRecordTable()
						])),
						VerticalDivider(width: 40),
						Expanded(child: Column(children: <Widget>[
							Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
								Text("温馨提示", style: TextStyle(color: Color(0xff616161), fontSize: 25))
							]),
							Divider(color: Color(0xffF8A72C), endIndent: 250),
							Text("1.机组建议使用复合标准的防冻液，严禁使用自来水\n"
								"2.建议发电机组不能再低于30%负荷下长时间进行\n"
								"3.建议定期启动发电机组，运行10-15分钟，检查机组运行状况\n"
								"4.机组需映入市电，为电池浮充及加热器提供电源\n"
								"5.冬季建议开启加热器", style: TextStyle(color: Color(0xff616161), fontSize: 18)),
							Expanded(child: Column(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
								Container(
									margin: EdgeInsets.only(top: 20),
									decoration: BoxDecoration(
										gradient: LinearGradient(colors: [
											Color(0xffF9F9F9),
											Color(0xffD1D1D1)
										], begin: Alignment.topCenter, end: Alignment.bottomCenter)
									),
									child: Column(children: <Widget>[
										Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
											Image.asset("images/tags.png", color: Color(0xffC46262), width: 25, height: 25)
										]),
										Padding(
											padding: EdgeInsets.only(left: 25, right: 25, bottom: 25, top: 3),
											child: Text("近期天气炎热，机组加热器可以关闭", style: TextStyle(fontSize: 20, color: Color(0xff616161)))
										)
									])
								)
							]))
						]))
					])
				))
			]))
		);
	}
}

class DeviceStatus extends StatefulWidget {
	@override
	State<StatefulWidget> createState() => _DeviceStatusState();
}

enum DetailLoc {
	LT, LB, RT, RB
}

class PoiInfo {
	static final double SIZE = 40;
	Offset _location;
	final String _name;
	final String _type;
	String _status;
	DetailLoc _dtlLoc;
	bool _show = false;

	PoiInfo(this._location, this._name, this._type, this._status, this._dtlLoc);

	bool get show => _show;
	set show(bool value) {
		_show = value;
	}
	String get status => _status;
	String get type => _type;
	String get name => _name;
	Offset get location => _location;
	set location(Offset value) {
		_location = value;
	}
	DetailLoc get dtlLoc => _dtlLoc;
}

class _DeviceStatusState extends State<DeviceStatus> with SingleTickerProviderStateMixin {
	ui.Image _imgBackground;
	AnimationController _controller;
	Animation<Color> _animation;
	Color _infoColor;
	final List<PoiInfo> _poiInfos = [
		PoiInfo(Offset(1 / 27.33,   1 / 3.208),     "烟感器", "aabb", "正常", DetailLoc.LT),
		PoiInfo(Offset(1 / 16.4,    1 / 1.35),      "烟感器", "aabb", "正常", DetailLoc.LB),
		PoiInfo(Offset(1 / 3.57,    1 / 1.25),      "烟感器", "aabb", "正常", DetailLoc.LB),
		PoiInfo(Offset(1 / 2.05,    -PoiInfo.SIZE), "烟感器", "aabb", "正常", DetailLoc.LB),
		PoiInfo(Offset(1 / 1.58,    1 / 3.208),     "烟感器", "aabb", "正常", DetailLoc.LT),
		PoiInfo(Offset(1 / 1.3,     1 / 1.48),      "烟感器", "aabb", "正常", DetailLoc.RB)
	];
	double _cvsWid = 0;
	double _cvsHgt = 0;

	@override
	void initState() {
		super.initState();

		_initialize();
		_startAnim();
	}

	_startAnim() {
		_controller = AnimationController(
			duration: const Duration(seconds: 1),
			vsync: this
		);
		var tween = ColorTween(begin: Color(0xFFF79D27), end: Color(0x00F79D27));
		_animation = tween.animate(_controller);
		_animation.addListener(() {
			_infoColor = _animation.value;
			setState(() {});
		});
		_animation.addStatusListener((status) {
			switch (status) {
				case AnimationStatus.forward:
					break;
				case AnimationStatus.reverse:
					break;
				case AnimationStatus.completed:
					_controller.reverse();
					break;
				case AnimationStatus.dismissed:
					_controller.forward();
					break;
			}
		});
		_controller.forward();
	}

	@override
	void dispose() {
		super.dispose();
		_controller.dispose();
	}

	_initialize() async {
		_imgBackground = await _loadImage("images/background.png");
	}

	_loadImage(String asset) async {
		ByteData data = await rootBundle.load(asset);
		ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
		ui.FrameInfo fi = await codec.getNextFrame();
		return fi.image;
	}

	@override
	Widget build(BuildContext context) => GestureDetector(
		onTapUp: (TapUpDetails detail) {
			RenderBox rb = context.findRenderObject();
			Offset pos = rb.globalToLocal(detail.globalPosition);
			for (PoiInfo info in _poiInfos) {
				if (Rect.fromLTWH(
					info.location.dx, info.location.dy,
					PoiInfo.SIZE, PoiInfo.SIZE
				).contains(pos)) {
					info.show = !info.show;
					setState(() {});
					break;
				}
			}
		},
		child: CustomPaint(
			size: Size(1600, 900),
			painter: _DeviceStatusView(this)
		)
	);

	List<PoiInfo> get poiInfos => _poiInfos;

	Color get infoColor => _infoColor;

	ui.Image get imgBackground => _imgBackground;

	set cvsSize(Size size) {
		if (_cvsWid != 0 && _cvsHgt != 0) {
			return;
		}
		_cvsWid = size.width;
		_cvsHgt = size.height;
		for (PoiInfo info in _poiInfos) {
			info.location = Offset(
				info.location.dx > 0 ? _cvsWid * info.location.dx : _cvsWid + info.location.dx,
				info.location.dy > 0 ? _cvsHgt * info.location.dy : _cvsHgt + info.location.dy
			);
		}
	}
}

class _DeviceStatusView extends CustomPainter {
	final _DeviceStatusState _state;

	_DeviceStatusView(this._state);

	@override
	void paint(Canvas canvas, Size size) {
		// 绘制背景
		if (_state.imgBackground == null) {
			_state.cvsSize = size;
			return;
		}
		Paint _paint = Paint();
		canvas.drawImageRect(_state.imgBackground,
			Rect.fromLTWH(0, 0,
				_state.imgBackground.width.toDouble(),
				_state.imgBackground.height.toDouble()),
			Rect.fromLTWH(0, 0, size.width, size.height), _paint);

		// 绘制点位
		TextPainter icnTp = TextPainter(textDirection: TextDirection.rtl);
		for (PoiInfo info in _state.poiInfos) {
			Color color = _state.infoColor;
			if (info.show) {
				color = Color(0xFFF79D27);

				// 绘制点位信息
				double left = info.location.dx + PoiInfo.SIZE;
				double top = info.location.dy;
				double hpadding = 15;
				double vpadding = 10;

				TextPainter dtlTp = TextPainter(textDirection: TextDirection.ltr);
				dtlTp.text = TextSpan(
					text: "名称：${info.name}\n型号：${info.type}\n状态：${info.status}",
					style: TextStyle(fontSize: 20, color: Colors.white)
				);
				dtlTp.layout();

				_paint.color = Color(0xAA02093D);
				double dtlX = left;
				double dtlY = top;
				double dtlWid = dtlTp.size.width + hpadding * 2;
				double dtlHgt = dtlTp.size.height + vpadding * 2;
				switch (info.dtlLoc) {
					case DetailLoc.LT:
						break;
					case DetailLoc.LB:
						dtlY -= dtlHgt - PoiInfo.SIZE;
						break;
					case DetailLoc.RT:
						dtlX -= dtlWid + PoiInfo.SIZE;
						break;
					case DetailLoc.RB:
						dtlY -= dtlHgt - PoiInfo.SIZE;
						dtlX -= dtlWid + PoiInfo.SIZE;
						break;
				}
				canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(
					dtlX, dtlY, dtlWid, dtlHgt
				), Radius.circular(8)), _paint);
				dtlTp.paint(canvas, Offset(dtlX + hpadding, dtlY + vpadding));
			}
			icnTp.text = TextSpan(
				text: String.fromCharCode(Icons.info.codePoint),
				style: TextStyle(
					fontSize: PoiInfo.SIZE,
					fontFamily: Icons.info.fontFamily,
					color: color
				)
			);
			icnTp.layout();
			icnTp.paint(canvas, info.location);
		}

//		_paint
//			..color = Colors.red
//			..style = PaintingStyle.stroke;
//		for (double i = 0; i < size.width; i += 50) {
//			canvas.drawLine(Offset(i, 0), Offset(i, size.height), _paint);
//		}
//		for (double i = 0; i < size.height; i += 50) {
//			canvas.drawLine(Offset(0, i), Offset(size.width, i), _paint);
//		}
	}

	@override
	bool shouldRepaint(CustomPainter oldDelegate) => true;
}
