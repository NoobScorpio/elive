import 'package:flutter/material.dart';

MaterialColor getPrimaryColor(context) {
  return Theme.of(context).primaryColor;
}

const headerText =
    TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87);

const cardText = TextStyle(
    fontSize: 16, fontWeight: FontWeight.normal, color: Colors.black87);

Widget getCard({title, image, height, width, special}) {
  return Card(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(15)),
    ),
    elevation: 6,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: special == null ? width * 0.422 : width * 0.9,
          height: special == null ? 175 : 145,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15), topRight: Radius.circular(15)),
            image: DecorationImage(image: AssetImage(image), fit: BoxFit.cover),
          ),
        ),
        Container(
          width: special == null ? width * 0.422 : width * 0.9,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(15)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(title,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
          ),
        )
      ],
    ),
  );
}

Widget getServiceCard({title, image, height, width}) {
  return Card(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(15)),
    ),
    elevation: 3,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: width * 0.422,
          height: 125,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15), topRight: Radius.circular(15)),
            image: DecorationImage(image: AssetImage(image), fit: BoxFit.cover),
          ),
        ),
        Container(
          width: width * 0.422,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(15)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(title,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
          ),
        )
      ],
    ),
  );
}
