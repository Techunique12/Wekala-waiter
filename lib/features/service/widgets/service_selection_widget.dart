import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wekala_waiter/core/extensions/build_context_extension.dart';
import 'package:wekala_waiter/features/service/controllers/service_controller.dart';
import 'package:wekala_waiter/features/service/widgets/service_shimmer.dart';
import 'package:wekala_waiter/helper/route_helper.dart';
import 'package:wekala_waiter/util/dimensions.dart';

class ServiceSelectionWidget extends StatelessWidget {
  const ServiceSelectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ServiceController>(
      builder: (controller) {
        if (controller.isLoading) {
          return const ServiceShimmer();
        }

        if (controller.services.isEmpty) {
          return Center(
            child: Text(
              'no_services_available'.tr,
              style: TextStyle(color: Theme.of(context).hintColor),
            ),
          );
        }
        final width = MediaQuery.sizeOf(context).width;
        final crossAxisCount = width >= 1000
            ? 4
            : width >= 600
            ? 3
            : 2;
        return GridView.builder(
          padding: EdgeInsets.fromLTRB(
            Dimensions.paddingSizeDefault,
            Dimensions.paddingSizeSmall,
            Dimensions.paddingSizeDefault,
            Dimensions.paddingSizeDefault,
          ),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.5,
          ),
          itemCount: controller.services.length,
          itemBuilder: (context, index) {
            final service = controller.services[index];

            return _ServiceCard(
              name: service.name,
              description: service.description ?? '',
              icon: service.icon,
              onTap: () {
                Get.toNamed(RouteHelper.order, arguments: service);
              },
            );
          },
        );
      },
    );
  }
}

class _ServiceCard extends StatelessWidget {
  final String name;
  final String description;
  final String? icon;
  final VoidCallback onTap;

  const _ServiceCard({
    required this.name,
    required this.description,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(Dimensions.radiusMedium),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.radiusMedium),
          border: Border.all(color: Colors.grey),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: theme.highlightColor,
                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
              ),
              alignment: Alignment.center,
              child: icon != null && icon!.isNotEmpty
                  ? Text(icon!, style: TextStyle(fontSize: context.iconSize))
                  : Icon(
                      Icons.star,
                      size: context.iconSize,
                      color: Colors.amberAccent,
                    ),
            ),

            const SizedBox(height: 10),

            Text(
              name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: theme.textTheme.bodyLarge?.color,
              ),
            ),

            if (description.isNotEmpty) ...[
              const SizedBox(height: 3),
              Text(
                description,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 12, color: theme.hintColor),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
