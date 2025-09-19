import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tailor_mate/core/theme/app_color.dart';
import 'package:tailor_mate/core/utils/utility.dart';
import 'package:tailor_mate/injector/injector.dart';
import 'package:tailor_mate/measurement/model/measurement_model.dart';
import 'package:tailor_mate/measurement/repository/i_measurement_repository.dart';
import 'package:tailor_mate/measurement/widget/add_edit_measurement_dailog.dart';
import 'package:tailor_mate/measurement/widget/measurement_card_widget.dart';
import 'package:tailor_mate/widget/common_app_bar.dart';
import 'package:tailor_mate/widget/floating_action_widget.dart';
import 'package:visibility_detector/visibility_detector.dart';

class MeasurementPage extends StatefulWidget {
  const MeasurementPage({super.key});

  @override
  State<MeasurementPage> createState() => _MeasurementPageState();
}

class _MeasurementPageState extends State<MeasurementPage> {
  final isLoading = ValueNotifier<bool>(false);
  final isPageLoading = ValueNotifier<bool>(false);
  final measurementsList = ValueNotifier<List<MeasurementModel>>([]);
  int page = 0;
  bool stop = false;

  @override
  void initState() {
    super.initState();
    getMeasurementList();
  }

  Future<void> getMeasurementList() async {
    page += 1;
    if (page == 1) {
      isLoading.value = true;
    } else {
      isPageLoading.value = true;
    }

    final failOrSucess = await getIt<IMeasurementRepository>().getMeasurements(
      page: page,
      perPage: 10,
    );

    failOrSucess.fold(
      (l) {
        isLoading.value = false;
        isPageLoading.value = false;
        Utility.toast(message: l.message);
      },
      (r) {
        if ((r.data?.length ?? 0) < 10) {
          stop = true;
        }
        measurementsList.value = [...measurementsList.value, ...r.data ?? []];

        isLoading.value = false;
        isPageLoading.value = false;
      },
    );
  }

  Future updateMeasurement({required MeasurementModel model}) async {
    final result = await getIt<IMeasurementRepository>().updateMeasurement(id: model.id!, name: model.name!);
    result.fold((l) => Utility.toast(message: l.message), (r) {
      measurementsList.value = measurementsList.value.map((e) {
        if (e.id == model.id) {
          return model;
        }
        return e;
      }).toList();
    });
  }

  Future createMeasurement({required String name}) async {
    final result = await getIt<IMeasurementRepository>().createMeasurement(name: name);
    result.fold((l) => Utility.toast(message: l.message), (r) {
      measurementsList.value = [
        r.data!,
        ...measurementsList.value,
      ];
    });
  }

  void _refresh() {
    stop = false;
    page = 0;
    measurementsList.value = [];
    getMeasurementList();
  }

  void _showMeasurementDialog({MeasurementModel? model}) {
    showDialog(
      context: context,
      builder: (context) {
        return MeasurementDialog(
          initialValue: model?.name,
          title: model == null ? "Add Measurement" : "Edit Measurement",
          onSave: (value) async {
            if (model == null) {
              // Create new measurement
              await createMeasurement(name: value);
            } else {
              // Update existing measurement
              await updateMeasurement(
                model: model.copyWith(name: value),
              );
            }
          },
        );
      },
    );
  }

  Widget measurementView(MeasurementModel model) {
    return MeasurementCardWidget(
      label: model.name ?? "",
      value: '',
      onTapEdit: () {
        _showMeasurementDialog(model: model);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CommonAppBar(
        titleSpacing: 0,
        titleWidget: const Text("Measurements"),
        isLeading: true,
        onBackTap: () => Navigator.pop(context),
      ),
      body: ValueListenableBuilder<bool>(
          valueListenable: isLoading,
          builder: (context, loading, _) {
            if (loading) {
              return ListView.builder(itemCount: 5, itemBuilder: (context, index) => _shimmer());
            }
            return ValueListenableBuilder<List<MeasurementModel>>(
              valueListenable: measurementsList,
              builder: (context, list, _) {
                if (list.isEmpty) {
                  return const Center(child: Text("No measurements found"));
                }
                return RefreshIndicator(
                  onRefresh: () {
                    _refresh();
                    return Future.value();
                  },
                  child: ListView.builder(
                    shrinkWrap: true,
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 75),
                    itemCount: list.length,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      if (index == (list.length - 1)) {
                        return VisibilityDetector(
                          key: Key(index.toString()),
                          onVisibilityChanged: (info) {
                            if (!isPageLoading.value && !stop) {
                              getMeasurementList();
                            }
                          },
                          child: ValueListenableBuilder<bool>(
                              valueListenable: isPageLoading,
                              builder: (context, loading, _) {
                                return Column(
                                  children: [
                                    measurementView(list[index]),
                                    if (loading) _shimmer(),
                                  ],
                                );
                              }),
                        );
                      }
                      return measurementView(list[index]);
                    },
                  ),
                );
              },
            );
          }),
      floatingActionButton: FloatingActionWidget(
        onPressed: () {
          _showMeasurementDialog();
        },
      ),
    );
  }

  Widget _shimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Container(
              height: 14,
              width: 60,
              color: Colors.white,
            ),
            const SizedBox(width: 8),
            Container(
              height: 14,
              width: 80,
              color: Colors.white,
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.all(Radius.circular(6)),
              ),
              height: 24,
              width: 24,
            ),
          ],
        ),
      ),
    );
  }
}
