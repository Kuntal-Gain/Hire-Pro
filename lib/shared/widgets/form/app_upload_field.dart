import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:hire_pro/core/constants/color_constants.dart';
import 'package:hire_pro/core/constants/sizes_constants.dart';
import 'package:hire_pro/core/network/client_manager.dart';

/// Generic upload trigger — a 3:4 drop-zone card with a centered icon
/// and subtitle when empty, and the selected file's name once picked.
///
/// Self-contained: tapping it opens the native file picker, uploads the
/// chosen file straight to Supabase storage under `bucket/pathPrefix-*`,
/// and reports the resulting public URL via [onUploaded]. The caller
/// only needs to persist that URL — no picker/upload plumbing required
/// at the call site.
class AppUploadField extends StatefulWidget {
  const AppUploadField({
    super.key,
    required this.bucket,
    required this.onUploaded,
    this.pathPrefix = 'upload',
    this.fileName,
    this.onRemove,
    this.label,
    this.hint = 'Tap to upload',
    this.subtitle = 'PNG, JPG or PDF',
    this.icon = Icons.cloud_upload_outlined,
    this.allowedExtensions = const ['png', 'jpg', 'jpeg', 'pdf'],
    this.width,
    this.previewUrl,
  });

  /// Supabase storage bucket to upload into (see [Buckets]).
  final String bucket;

  /// Prefix used to build the storage object path, e.g. the user id.
  final String pathPrefix;

  /// Called with the uploaded file's public URL once the upload succeeds.
  final ValueChanged<String> onUploaded;

  /// Currently selected file's display name (owned by the caller).
  final String? fileName;
  final VoidCallback? onRemove;
  final String? label;
  final String hint;
  final String subtitle;
  final IconData icon;
  final List<String>? allowedExtensions;
  final double? width;

  /// Public URL to render as an image preview once uploaded. Pass this
  /// (usually the same URL returned by [onUploaded]) when the upload is
  /// an image — leave null for non-image uploads like a resume.
  final String? previewUrl;

  static const _imageExtensions = ['png', 'jpg', 'jpeg', 'gif', 'webp'];

  bool get _looksLikeImage {
    final url = previewUrl;
    if (url == null || url.isEmpty) return false;
    final ext = url.split('.').last.toLowerCase().split('?').first;
    return _imageExtensions.contains(ext);
  }

  @override
  State<AppUploadField> createState() => _AppUploadFieldState();
}

class _AppUploadFieldState extends State<AppUploadField> {
  bool _isLoading = false;

  bool get _hasFile => widget.fileName != null && widget.fileName!.isNotEmpty;

  Future<void> _pickAndUpload() async {
    final result = await FilePicker.platform.pickFiles(
      type: widget.allowedExtensions == null ? FileType.any : FileType.custom,
      allowedExtensions: widget.allowedExtensions,
      withData: true,
    );

    final file = result?.files.single;
    if (file == null || file.bytes == null) return;

    setState(() => _isLoading = true);
    try {
      final path = '${widget.pathPrefix}-${DateTime.now().millisecondsSinceEpoch}-${file.name}';

      final url = await SupabaseManager.uploadFile(
        bucket: widget.bucket,
        path: path,
        bytes: file.bytes!,
      );

      widget.onUploaded(url);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Upload failed: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColor.textPrimary,
            ),
          ),
          SizedBox(height: AppSizes.s8),
        ],
        SizedBox(
          width: widget.width ?? double.infinity,
          child: AspectRatio(
            aspectRatio: 1 / 0.5,
            child: InkWell(
              onTap: _isLoading ? null : _pickAndUpload,
              borderRadius: BorderRadius.circular(AppSizes.r16),
              child: DottedBorderBox(
                isFilled: _hasFile,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    if (_hasFile && widget.previewUrl?.isNotEmpty == true && widget._looksLikeImage)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(AppSizes.r16),
                        child: Image.network(
                          widget.previewUrl!,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, progress) {
                            if (progress == null) return child;
                            return Center(
                              child: SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.2,
                                  valueColor: AlwaysStoppedAnimation<Color>(AppColor.primary),
                                ),
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
                        ),
                      )
                    else
                      Padding(
                        padding: EdgeInsets.all(AppSizes.s16),
                        child: Center(child: _buildPlaceholder()),
                      ),
                    if (_hasFile && widget.onRemove != null)
                      Positioned(
                        top: AppSizes.s8,
                        right: AppSizes.s8,
                        child: InkWell(
                          onTap: widget.onRemove,
                          borderRadius: BorderRadius.circular(AppSizes.r20),
                          child: Container(
                            padding: EdgeInsets.all(AppSizes.p4),
                            decoration: BoxDecoration(
                              color: AppColor.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.08),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.close_rounded,
                              size: 16,
                              color: AppColor.error,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPlaceholder() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (_isLoading)
          SizedBox(
            width: 28,
            height: 28,
            child: CircularProgressIndicator(
              strokeWidth: 2.4,
              valueColor: AlwaysStoppedAnimation<Color>(AppColor.primary),
            ),
          )
        else
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: _hasFile ? AppColor.primary : AppColor.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _hasFile ? Icons.insert_drive_file_rounded : widget.icon,
              size: 22,
              color: _hasFile ? AppColor.white : AppColor.primary,
            ),
          ),
        SizedBox(height: AppSizes.s12),
        Text(
          _hasFile ? widget.fileName! : widget.hint,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 12.5,
            fontWeight: _hasFile ? FontWeight.w700 : FontWeight.w600,
            color: _hasFile ? AppColor.primaryDark : AppColor.textSecondary,
          ),
        ),
        if (!_hasFile) ...[
          SizedBox(height: AppSizes.s4),
          Text(
            widget.subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 11, color: AppColor.textTertiary),
          ),
        ],
      ],
    );
  }
}

/// Dashed-border rounded container used by [AppUploadField]'s empty state.
class DottedBorderBox extends StatelessWidget {
  const DottedBorderBox({
    super.key,
    required this.child,
    required this.isFilled,
  });

  final Widget child;
  final bool isFilled;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DashedBorderPainter(
        color: isFilled ? AppColor.primary : AppColor.border,
        strokeWidth: isFilled ? 1.4 : 1.2,
        dashed: !isFilled,
        radius: AppSizes.r16,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: isFilled
              ? AppColor.primaryContainer
              : AppColor.textSecondary.withValues(alpha: 0.04),
          borderRadius: BorderRadius.circular(AppSizes.r16),
        ),
        child: child,
      ),
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  _DashedBorderPainter({
    required this.color,
    required this.strokeWidth,
    required this.dashed,
    required this.radius,
  });

  final Color color;
  final double strokeWidth;
  final bool dashed;
  final double radius;

  @override
  void paint(Canvas canvas, Size size) {
    final rrect = RRect.fromRectAndRadius(
      Offset.zero & size,
      Radius.circular(radius),
    );
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    if (!dashed) {
      canvas.drawRRect(rrect, paint);
      return;
    }

    const dashWidth = 6.0;
    const dashGap = 4.0;
    final path = Path()..addRRect(rrect);
    for (final metric in path.computeMetrics()) {
      double distance = 0;
      while (distance < metric.length) {
        final next = distance + dashWidth;
        canvas.drawPath(
          metric.extractPath(distance, next.clamp(0, metric.length)),
          paint,
        );
        distance = next + dashGap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedBorderPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.dashed != dashed;
}
