import 'dart:typed_data';

import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:tailor_mate/customer/model/customer_item_local_model.dart';

Future<Uint8List> generateCustomerPdf(CustomerItemLocalModel customer) async {
  // 🔹 Load Gujarati fonts
  final gujaratiRegular = pw.Font.ttf(
    await rootBundle.load("assets/fonts/NotoSansGujarati-Regular.ttf"),
  );
  final gujaratiBold = pw.Font.ttf(
    await rootBundle.load("assets/fonts/NotoSansGujarati-Bold.ttf"),
  );

  final pdf = pw.Document(
    pageMode: PdfPageMode.fullscreen,
  );

  pdf.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a5.landscape,
      margin: const pw.EdgeInsets.all(12),
      build: (pw.Context context) {
        final boxWidth = PdfPageFormat.a5.landscape.availableWidth / 3 - 10;

        return [
          pw.Wrap(
            spacing: 16,
            runSpacing: 16,
            children: (customer.itemsModel ?? []).map((item) {
              return pw.Container(
                width: boxWidth,
                padding: const pw.EdgeInsets.all(6),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(width: 0.5),
                  borderRadius: pw.BorderRadius.circular(6),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    // 🔹 Customer details (Gujarati supported)
                    pw.Text(
                      " ${customer.name ?? ''}",
                      style: pw.TextStyle(
                        font: gujaratiBold,
                        fontSize: 12,
                      ),
                    ),
                    if (customer.mobile != null)
                      pw.Text(" ${customer.mobile}", style: pw.TextStyle(font: gujaratiRegular)),
                    if (customer.city != null) pw.Text(" ${customer.city}", style: pw.TextStyle(font: gujaratiRegular)),
                    pw.Text("Bill No:_________ ", style: pw.TextStyle(font: gujaratiRegular)),
                    pw.SizedBox(height: 4),

                    // 🔹 Item details
                    pw.Text(
                      " ${item.item?.name ?? ''}",
                      style: pw.TextStyle(
                        font: gujaratiBold,
                        fontSize: 11,
                        decoration: pw.TextDecoration.underline,
                      ),
                    ),
                    pw.SizedBox(height: 2),

                    ...((item.measurementRecords ?? []).map(
                      (m) => pw.Text(
                        "    ${m.measurement?.name ?? ''}: ${m.value ?? ''}",
                        style: pw.TextStyle(font: gujaratiRegular, fontSize: 10),
                      ),
                    )),

                    if ((item.styleRecords ?? []).isNotEmpty) ...[
                      pw.SizedBox(height: 2),
                      pw.Text(
                        "Styles:",
                        style: pw.TextStyle(
                          font: gujaratiRegular,
                          decoration: pw.TextDecoration.underline,
                          fontSize: 10,
                        ),
                      ),
                      ...item.styleRecords!.map(
                        (s) => pw.Text(
                          "   ${s.style?.name ?? ''}",
                          style: pw.TextStyle(font: gujaratiRegular, fontSize: 10),
                        ),
                      ),
                    ],
                  ],
                ),
              );
            }).toList(),
          ),
        ];
      },
    ),
  );

  return pdf.save();
}
