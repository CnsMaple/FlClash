import 'package:fl_clash/clash/core.dart';
import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/widgets/widgets.dart';
import 'package:flutter/material.dart';

class GenProfile extends StatefulWidget {
  final String profileId;

  const GenProfile({
    super.key,
    required this.profileId,
  });

  @override
  State<GenProfile> createState() => _GenProfileState();
}

class _GenProfileState extends State<GenProfile> {
  final _currentClashConfigNotifier = ValueNotifier<ClashConfigSnippet?>(null);

  @override
  void initState() {
    super.initState();
    _initCurrentClashConfig();
  }

  _initCurrentClashConfig() async {
    _currentClashConfigNotifier.value =
        await clashCore.getProfile(widget.profileId);
  }

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      body: ValueListenableBuilder(
        valueListenable: _currentClashConfigNotifier,
        builder: (_, clashConfig, ___) {
          if (clashConfig == null) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    '代理组',
                    style: context.textTheme.titleMedium,
                  ),
                ),
              ),
              SliverPadding(
                padding: EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                sliver: SliverGrid.builder(
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 120,
                    mainAxisExtent: 54,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                  ),
                  itemCount: clashConfig.proxyGroups.length,
                  itemBuilder: (BuildContext context, int index) {
                    final group = clashConfig.proxyGroups[index];
                    return CommonCard(
                      type: CommonCardType.filled,
                      onPressed: () {},
                      child: Container(
                        constraints: BoxConstraints.expand(),
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              group.name,
                              maxLines: 1,
                              style: context.textTheme.bodyMedium?.copyWith(
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Text(
                              group.type.name,
                              style: context.textTheme.bodySmall?.toLight,
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    '规则',
                    style: context.textTheme.titleMedium,
                  ),
                ),
              ),
              SliverList.builder(
                itemBuilder: (BuildContext context, int index) {
                  final rule = clashConfig.rule[index];
                  return Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16,
                    ),
                    child: Container(
                      padding: EdgeInsets.all(4),
                      color: (index % 2 == 0)
                          ? context.colorScheme.surfaceContainer
                          : context.colorScheme.surfaceContainer,
                      child: Text(rule),
                    ),
                  );
                },
                itemCount: clashConfig.rule.length,
              ),
            ],
          );
        },
      ),
      title: "自定义",
    );
  }
}
