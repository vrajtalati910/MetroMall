import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:tailor_mate/customer/model/customer_item_local_model.dart';

Future<Uint8List> generateCustomerPdf(CustomerItemLocalModel customer) async {
  final pdf = pw.Document(
    pageMode: PdfPageMode.fullscreen,
  );

  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a5.landscape, // ✅ A5 landscape
      margin: const pw.EdgeInsets.all(12),
      build: (pw.Context context) {
        final boxWidth = PdfPageFormat.a5.landscape.availableWidth / 3 - 10;
        return pw.Wrap(
          spacing: 16,
          runSpacing: 16,
          children: (customer.itemsModel ?? []).map((item) {
            return pw.Container(
              width: boxWidth, // ✅ 3 per row
              padding: const pw.EdgeInsets.all(6),
              decoration: pw.BoxDecoration(
                border: pw.Border.all(width: 0.5),
                borderRadius: pw.BorderRadius.circular(6),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  // 🔹 Always show customer name + details
                  pw.Text(" ${customer.name ?? ''}", style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
                  if (customer.mobile != null) pw.Text(" ${customer.mobile}"),
                  if (customer.city != null) pw.Text(" ${customer.city}"),
                  pw.Text("Bill No:_________ "),
                  pw.SizedBox(height: 4),

                  // 🔹 Now show item details
                  pw.Text(" ${item.item?.name ?? ''}",
                      style: pw.TextStyle(
                        fontSize: 11,
                        fontWeight: pw.FontWeight.bold,
                        decoration: pw.TextDecoration.underline,
                      )),
                  pw.SizedBox(height: 2),

                  ...((item.measurementRecords ?? []).map((m) => pw.Text(
                      "    ${m.measurement?.name ?? ''}: ${m.value ?? ''}",
                      style: const pw.TextStyle(fontSize: 10)))),

                  if ((item.styleRecords ?? []).isNotEmpty) ...[
                    pw.SizedBox(height: 2),
                    pw.Text("Styles:",
                        style: const pw.TextStyle(decoration: pw.TextDecoration.underline, fontSize: 10)),
                    ...item.styleRecords!
                        .map((s) => pw.Text("   ${s.style?.name ?? ''}", style: const pw.TextStyle(fontSize: 10))),
                  ],
                ],
              ),
            );
          }).toList(),
        );
      },
    ),
  );

  return pdf.save();
}
