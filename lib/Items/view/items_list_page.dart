import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tailor_mate/Items/model/items_model.dart';
import 'package:tailor_mate/Items/repository/i_items_repository.dart';
import 'package:tailor_mate/Items/view/create_edit_item_page.dart';
import 'package:tailor_mate/core/theme/app_color.dart';
import 'package:tailor_mate/core/utils/utility.dart';
import 'package:tailor_mate/injector/injector.dart';
import 'package:tailor_mate/measurement/widget/measurement_card_widget.dart';
import 'package:tailor_mate/widget/common_app_bar.dart';
import 'package:tailor_mate/widget/floating_action_widget.dart';
import 'package:visibility_detector/visibility_detector.dart';

class ItemListPage extends StatefulWidget {
  const ItemListPage({super.key});

  @override
  State<ItemListPage> createState() => _ItemListPageState();
}

class _ItemListPageState extends State<ItemListPage> {
  final isLoading = ValueNotifier<bool>(false);
  final isPageLoading = ValueNotifier<bool>(false);
  final itemsList = ValueNotifier<List<ItemsModel>>([]);
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

    final failOrSucess = await getIt<IItemsRepository>().getItems(
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
        itemsList.value = [...itemsList.value, ...r.data ?? []];

        isLoading.value = false;
        isPageLoading.value = false;
      },
    );
  }

  void _refresh() {
    stop = false;
    page = 0;
    itemsList.value = [];
    getMeasurementList();
  }

  void _navigateToEdit({ItemsModel? item}) async {
    final result = await Navigator.push<ItemsModel>(
      context,
      MaterialPageRoute(
        builder: (context) => ItemEditPage(item: item),
      ),
    );

    log('result: $result');

    if (result != null) {
      // If editing -> update existing
      if (itemsList.value.any((e) => e.id == result.id)) {
        itemsList.value = itemsList.value.map((e) {
          if (e.id == result.id) {
            return result;
          }
          return e;
        }).toList();
      }
      // If new -> add
      else {
        itemsList.value = [...itemsList.value, result];
      }
    }
  }

  Widget itemsView(ItemsModel model) {
    return MeasurementCardWidget(
      label: model.name ?? "",
      value: '',
      onTapEdit: () {
        _navigateToEdit(item: model);
        // _showMeasurementDialog(model: model);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CommonAppBar(
        titleSpacing: 0,
        titleWidget: const Text("Items"),
        isLeading: true,
        onBackTap: () => Navigator.pop(context),
      ),
      body: ValueListenableBuilder<bool>(
          valueListenable: isLoading,
          builder: (context, loading, _) {
            if (loading) {
              return ListView.builder(itemCount: 5, itemBuilder: (context, index) => _shimmer());
            }
            return ValueListenableBuilder<List<ItemsModel>>(
              valueListenable: itemsList,
              builder: (context, list, _) {
                if (list.isEmpty) {
                  return const Center(child: Text("No items found"));
                }
                return RefreshIndicator(
                  onRefresh: () {
                    _refresh();
                    return Future.value();
                  },
                  child: ListView.builder(
                    shrinkWrap: true,
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 40),
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
                                    itemsView(list[index]),
                                    if (loading) _shimmer(),
                                  ],
                                );
                              }),
                        );
                      }
                      return itemsView(list[index]);
                    },
                  ),
                );
              },
            );
          }),
      floatingActionButton: FloatingActionWidget(
        onPressed: () {
          _navigateToEdit();
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
