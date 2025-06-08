import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:kobo/core/enums/question_type.dart';
import 'package:kobo/core/helpers/extensions/widget_animation_ext.dart';
import 'package:kobo/features/submission/widget/field_container.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

class MapWidget extends StatelessWidget {
  final String title;
  final QuestionType questionType;
  final String data;
  final String? xmlValue;

  const MapWidget({
    super.key,
    required this.title,
    required this.questionType,
    required this.data,
    this.xmlValue,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final geoData = data.trim();

    // Parse semicolon-separated points (for trace/shape) or single point
    final pointStrings = geoData.split(';');
    final points = <LatLng>[];
    for (var pt in pointStrings) {
      final parts = pt.trim().split(RegExp(r"\s+"));
      if (parts.length >= 2) {
        final lat = double.tryParse(parts[0]);
        final lon = double.tryParse(parts[1]);
        if (lat != null && lon != null) {
          points.add(LatLng(lat, lon));
        }
      }
    }

    Widget? mapChild;
    if (points.isNotEmpty) {
      final center =
          points.length == 1
              ? points.first
              : LatLng(
                points.map((p) => p.latitude).reduce((a, b) => a + b) /
                    points.length,
                points.map((p) => p.longitude).reduce((a, b) => a + b) /
                    points.length,
              );

      final layers = <Widget>[
        TileLayer(
          urlTemplate:
              'http://mt0.google.com/vt/lyrs=m&hl=en&x={x}&y={y}&z={z}',
        ),
      ];

      switch (questionType) {
        case QuestionType.geopoint:
          layers.add(
            MarkerLayer(
              markers: [
                Marker(
                  point: center,
                  width: 40,
                  height: 40,
                  child: const Icon(
                    Icons.location_on,
                    color: Colors.red,
                    shadows: [
                      Shadow(color: Colors.black54, offset: Offset(0, 1)),
                    ],
                  ),
                ),
              ],
            ),
          );
          break;

        case QuestionType.geotrace:
          layers.add(
            PolylineLayer(
              polylines: [
                Polyline(
                  points: points,
                  strokeWidth: 4.0,
                  color: theme.colorScheme.primary,
                ),
              ],
            ),
          );
          break;

        case QuestionType.geoshape:
          layers.add(
            PolygonLayer(
              polygons: [
                Polygon(
                  points: points,
                  borderStrokeWidth: 2.0,
                  borderColor: theme.colorScheme.primary,
                  color: theme.colorScheme.primary.withAlpha(50),
                ),
              ],
            ),
          );
          break;

        default:
          layers.add(
            MarkerLayer(
              markers: [
                Marker(
                  point: center,
                  width: 40,
                  height: 40,
                  child: const Icon(
                    Icons.location_on,
                    color: Colors.red,
                    shadows: [
                      Shadow(color: Colors.black54, offset: Offset(0, 1)),
                    ],
                  ),
                ),
              ],
            ),
          );
      }

      mapChild = FlutterMap(
        options: MapOptions(
          initialCenter: center,
          initialZoom: 13,
          interactionOptions: const InteractionOptions(
            flags: InteractiveFlag.none,
          ),
        ),
        children: [
          ...layers,
          if (points.length > 1)
            Builder(
              builder: (context) {
                final mapController = MapController.of(context);
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (context.mounted) {
                    mapController.fitCamera(
                      CameraFit.bounds(
                        bounds: LatLngBounds.fromPoints(points),
                        padding: const EdgeInsets.all(16),
                      ),
                    );
                  }
                });
                return const SizedBox.shrink();
              },
            ),
        ],
      );
    }

    return FieldContainer(
      title: title,
      xmlValue: xmlValue,
      data: geoData,
      child:
          mapChild != null
              ? Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4.0),
                  boxShadow: [
                    BoxShadow(
                      color: theme.colorScheme.shadow.withAlpha(50),
                      blurRadius: 4.0,
                    ),
                  ],
                ),
                width: 200,
                height: 200,
                child: IgnorePointer(ignoring: true, child: mapChild),
              ).tapScale(
                onTap: points.length == 1 ? () => openMap(points.first) : null,
              )
              : null,
    );
  }
}

Future<bool> openMap(LatLng point) async {
  Uri googleUrl = Uri.parse(
    'https://www.google.com/maps/search/?api=1&query=${point.latitude},${point.longitude}',
  );
  if (await launchUrl(googleUrl, mode: LaunchMode.platformDefault)) {
    return true;
  } else {
    return false;
  }
}
