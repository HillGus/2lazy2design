library too_lazy_to_code;

import 'package:flutter/material.dart';

class App extends StatelessWidget {

    final String name;
    final String title;
    final Widget body;
    final TextStyle txtStyle = TextStyle(fontSize: 20);

    App({this.name, this.title, this.body, Key key}) : super(key: key);

    @override
    Widget build(BuildContext context) {

    return MaterialApp(
        title: name,
        home: Scaffold(
            appBar: AppBar(
                title: Text(
                    title,
                    style: txtStyle
                ),
            ),
            body: body,
        ),
    );
  }
}

class LabeledCard extends StatelessWidget {

    final Widget background;
    final String text;
    final double height;
    final double width;
    final EdgeInsets margin;
    final EdgeInsets padding;
    final double elevation;

    const LabeledCard({@required this.background, this.text, this.margin,
        this.padding, this.width, this.height, this.elevation,
        Key key}) : super(key: key);

    @override
    Widget build(BuildContext context) {

        return Container(
            width: width,
            height: height,
            margin: margin ?? EdgeInsets.all(0),
            child: Card(
                elevation: elevation ?? 1,
                child: Container(
                    padding: padding ?? EdgeInsets.all(0),
                    child: Stack(
                        alignment: Alignment(-0.9, 0.9),
                        children: <Widget>[
                            Center(
                                child: background
                            ),
                            Text(
                                text ?? '',
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    shadows: [
                                        Shadow(
                                            offset: Offset(0, 0),
                                            blurRadius: 5,
                                            color: Colors.black
                                        ),
                                        Shadow(
                                            offset: Offset(0, 0),
                                            blurRadius: 10,
                                            color: Colors.black
                                        )
                                    ]
                                )
                            )
                        ],
                    )
                )
            )
        );
    }
}

class ImageCard extends StatelessWidget {

    final String text;
    final ImageProvider provider;
    final DecorationImage image;
    final double height;
    final double width;
    final EdgeInsets margin;
    final EdgeInsets padding;
    final double elevation;

    const ImageCard({this.text, this.provider, this.image,
        this.height = 225, this.width = double.infinity, this.margin,
        this.padding, this.elevation, Key key}) : super(key: key);

    @override
    Widget build(BuildContext context) {

        return LabeledCard(
            margin: margin,
            padding: padding,
            elevation: elevation,
            background: Container(
                height: height,
                width: width,
                decoration: BoxDecoration(
                    image: image ??
                        DecorationImage(
                            image: provider,
                            fit: BoxFit.cover
                        )
                )
            ),
            text: text
        );
    }
}

class DetailsCard extends StatelessWidget {

    final Widget details;
    final Widget showCard;
    final Widget dialogCard;
    final EdgeInsets margin;
    final Function onOpen;
    final Function onClose;

    const DetailsCard({this.details, this.margin, this.onOpen, this.onClose,
        this.showCard, this.dialogCard, Key key}) : super(key: key);

    _open(BuildContext context) {

        showDialog(context: context,
            builder: (_) =>
                SlidingPopup(
                    child: ListView(
                        shrinkWrap: true,
                        children: [
                            dialogCard ?? showCard,
                            Container(
                                color: Colors.white,
                                child: details ?? Container()
                            )
                        ]
                    )
                ));
    }

    @override
    Widget build(BuildContext context) {

        return GestureDetector(
            onTap: () => _open(context),
            child: Container(
                margin: margin,
                child: showCard ?? dialogCard
            ),
        );
    }
}

class SlidingPopup extends StatefulWidget {

    final Widget child;

    const SlidingPopup({this.child, Key key}) : super(key: key);

    @override
    _SlidingPopupState createState() => _SlidingPopupState();
}

class _SlidingPopupState extends State<SlidingPopup> with TickerProviderStateMixin {

    AnimationController opacityController;
    AnimationController offsetController;
    Animation<double> opacityAnimation;
    Animation<Offset> offsetAnimation;

    @override
    void initState() {

        super.initState();

        opacityController = AnimationController(vsync: this, duration: Duration(milliseconds: 250));
        offsetController = AnimationController(vsync: this, duration: Duration(milliseconds: 250));

        opacityAnimation = Tween<double>(begin: 0.0, end: 1).animate(CurvedAnimation(parent: opacityController, curve: Curves.linear));
        offsetAnimation = Tween<Offset>(begin: const Offset(0, 1), end: Offset(0, 0)).animate(CurvedAnimation(parent: offsetController, curve: Curves.linear));

        opacityController.addListener(() => setState(() {}));
        offsetController.addListener(() => setState(() {}));

        opacityController.forward();
        offsetController.forward();
    }

    @override
    void dispose() {

        opacityController.dispose();
        offsetController.dispose();
        super.dispose();
    }

    void pop() {

        opacityController.reverse();
        offsetController.reverse();
        Navigator.of(context).pop(this);
    }

    @override
    Widget build(BuildContext context) {

        return SlideTransition(
            position: offsetAnimation,
            child: Opacity(
                opacity: opacityAnimation.value,
                child: Center(
                    child: Stack(
                        alignment: Alignment(-0.97, -0.97),
                        children: [
                            widget.child,
                            GestureDetector(
                                onTap: pop,
                                child: Icon(Icons.clear, color: Colors.white, size: 30),
                            )
                        ],
                    )
                )
            )
        );
    }
}